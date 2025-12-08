import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/material.dart';
import 'package:femora/services/auth_controller.dart';

class AuthProvider with ChangeNotifier {
  final AuthController _authController = AuthController();
  final CycleDataService _cycleDataService = CycleDataService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  // Ubah loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Ubah pesan error
  void _setError(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  // ==========================================================
  // SIGN UP
  // ==========================================================
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError("");

    String result = await _authController.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );

    _setLoading(false);

    if (result == "success") {
      // Simpan nama pengguna setelah berhasil mendaftar
      _cycleDataService.setFullName(fullName);
      _cycleDataService.finalizeData(); // Commit nama ke notifier
      return true;
    } else {
      _setError(result);
      return false;
    }
  }

  // ==========================================================
  // LOGIN
  // ==========================================================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError("");

    String result = await _authController.login(
      email: email,
      password: password,
    );

    _setLoading(false);

    if (result == "success") {
      // Ambil nama pengguna setelah berhasil login
      String? userName = await _authController.getUserName();
      if (userName != null) {
        _cycleDataService.setFullName(userName);
        _cycleDataService.finalizeData(); // Commit nama ke notifier
      }
      return true;
    } else {
      _setError(result);
      return false;
    }
  }

  // ==========================================================
  // GOOGLE LOGIN
  // ==========================================================
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError("");

    String result = await _authController.signInWithGoogle();

    _setLoading(false);

    if (result == "success") {
      // Ambil nama pengguna setelah berhasil login dengan Google
      String? userName = await _authController.getUserName();
      if (userName != null) {
        _cycleDataService.setFullName(userName);
        _cycleDataService.finalizeData(); // Commit nama ke notifier
      }
      return true;
    } else {
      _setError(result);
      return false;
    }
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================
  Future<void> logout() async {
    await _authController.logout();
  }
}
