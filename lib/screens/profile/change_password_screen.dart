import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/password_field.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorPopup('Semua kolom harus diisi.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorPopup('Kata sandi baru tidak cocok.');
      return;
    }

    if (newPassword.length < 6) {
      _showErrorPopup('Kata sandi baru harus terdiri dari minimal 6 karakter.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak ditemukan, silakan login kembali.');
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // If re-authentication is successful, update the password
      await user.updatePassword(newPassword);

      if (mounted) {
        _showSuccessPopup('Kata sandi berhasil diubah!');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = 'Kata sandi lama yang Anda masukkan salah.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Kata sandi baru terlalu lemah.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali untuk mengubah kata sandi.';
      } else {
        errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
      if (mounted) {
        _showErrorPopup(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        _showErrorPopup('Gagal mengubah kata sandi: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Gagal', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSuccessPopup(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Berhasil', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from ChangePasswordScreen
            },
            child: const Text('OK', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  CustomBackButton(onPressed: () => Navigator.of(context).pop()),
                  const Expanded(
                    child: Center(
                      child: Text('Ubah Kata Sandi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to balance the title
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  children: [
                    PasswordField(
                      controller: _oldPasswordController,
                      hintText: 'Kata Sandi Lama',
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: _newPasswordController,
                      hintText: 'Kata Sandi Baru',
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: _confirmPasswordController,
                      hintText: 'Konfirmasi Kata Sandi Baru',
                    ),
                    const SizedBox(height: 40),
                    _isLoading
                        ? const CircularProgressIndicator(color: AppColors.primary)
                        : PrimaryButton(
                            text: 'Simpan Perubahan',
                            onPressed: _handleChangePassword,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
