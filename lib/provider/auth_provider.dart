import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/material.dart';
import 'package:femora/services/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ditambahkan untuk pengecekan email

class AuthProvider extends ChangeNotifier {
  final AuthController _authController = AuthController();
  final CycleDataService _cycleDataService = CycleDataService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  // SIGN UP (dengan logika sinkronisasi)
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError("");

    try {
      // 1. Cek apakah email sudah terdaftar dengan metode lain (Google, dll)
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        // Jika email sudah ada, jangan buat akun baru. Beri pesan error.
        _setError('Email sudah terdaftar. Silakan login atau gunakan fitur Lupa Kata Sandi.');
        _setLoading(false);
        return false;
      }

      // 2. Jika email belum terdaftar, lanjutkan proses pembuatan akun
      String result = await _authController.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      _setLoading(false);

      if (result == "success") {
        _cycleDataService.setFullName(fullName);
        return true;
      } else {
        _setError(_parseFirebaseError(result));
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e.toString()));
      return false;
    }
  }

  // LOGIN
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError("");

    try {
      String result = await _authController.login(
        email: email,
        password: password,
      );

      _setLoading(false);

      if (result == "success") {
        String? userName = await _authController.getUserName();
        if (userName != null) {
          _cycleDataService.setFullName(userName);
        }
        await _cycleDataService.loadUserData();
        return true;
      } else {
        _setError(_parseFirebaseError(result));
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e.toString()));
      return false;
    }
  }

  // GOOGLE LOGIN
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError("");

    try {
      String result = await _authController.signInWithGoogle();

      _setLoading(false);

      if (result == "success") {
        String? userName = await _authController.getUserName();
        if (userName != null) {
          _cycleDataService.setFullName(userName);
        }
        await _cycleDataService.loadUserData();
        return true;
      } else if (result == "cancelled"){
        _setError("Login dibatalkan.");
        return false;
      } else {
        _setError(_parseFirebaseError(result));
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError(_parseFirebaseError(e.toString()));
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    _setLoading(true);
    try {
      _cycleDataService.clearAllData();
      await _authController.logout();
      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  String _parseFirebaseError(String error) {
    if (error.contains('email-already-in-use')) {
      return 'Email sudah terdaftar. Silakan login atau gunakan Lupa Kata Sandi.';
    } else if (error.contains('invalid-email')) {
      return 'Format email tidak valid.';
    } else if (error.contains('weak-password')) {
      return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
    } else if (error.contains('user-not-found')) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    } else if (error.contains('wrong-password') || error.contains('invalid-credential')) {
      return 'Email atau kata sandi salah.';
    } else if (error.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    } else if (error.contains('network-request-failed')) {
      return 'Tidak ada koneksi internet. Periksa koneksi Anda.';
    }
    return 'Terjadi kesalahan. Silakan coba lagi.'; 
  }
}
