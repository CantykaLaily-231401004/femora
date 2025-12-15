import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/material.dart';
import 'package:femora/services/auth_controller.dart';

// 👇 Perhatikan "extends ChangeNotifier", ini kuncinya biar main.dart ga error
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

  // SIGN UP
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
      _cycleDataService.setFullName(fullName);
      await _cycleDataService.finalizeData(); 
      return true;
    } else {
      _setError(result);
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

    String result = await _authController.login(
      email: email,
      password: password,
    );

    _setLoading(false);

    if (result == "success") {
      String? userName = await _authController.getUserName();
      if (userName != null) {
        _cycleDataService.setFullName(userName);
        await _cycleDataService.loadUserData();
      }
      return true;
    } else {
      _setError(result);
      return false;
    }
  }

  // GOOGLE LOGIN
  Future<bool> loginWithGoogle() async {
    _setLoading(true);
    _setError("");

    String result = await _authController.signInWithGoogle();

    _setLoading(false);

    if (result == "success") {
      String? userName = await _authController.getUserName();
      if (userName != null) {
        _cycleDataService.setFullName(userName);
        await _cycleDataService.loadUserData();
      }
      return true;
    } else {
      _setError(result);
      return false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authController.logout();
    _cycleDataService.clearAllData(); 
  }
}