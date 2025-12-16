import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/auth_footer.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/text_field_custom.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showInfoDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _sendResetLink() async {
    if (!mounted || _isLoading) return;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap masukkan alamat email Anda.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Cek apakah email terdaftar dengan metode apa pun.
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (!mounted) return;

      if (signInMethods.isEmpty) {
        // HANYA jika email benar-benar tidak ada, tampilkan error ini.
        _showInfoDialog('Gagal', 'Email tidak terdaftar. Silakan periksa kembali atau daftar akun baru.');
      } else {
        // JIKA EMAIL ADA (via Google, password, dll), selalu kirim link reset.
        // Ini adalah alur yang benar dan memungkinkan pengguna yang daftar via Google untuk membuat password.
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tautan reset kata sandi telah dikirim ke email Anda.')),
          );
          context.pop();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage = 'Terjadi kesalahan, coba lagi nanti.';
        if (e.code == 'invalid-email') {
          errorMessage = 'Format email tidak valid.';
        }
        _showInfoDialog('Gagal', errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          GradientBackground(
            height: SizeConfig.getHeight(40),
            child: const SizedBox(),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: CustomBackButton(
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(4)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getWidth(4),
                            vertical: SizeConfig.getHeight(3.5),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const AuthHeader(
                                title: 'Lupa Kata Sandi',
                                subtitle: 'Masukkan email terdaftar untuk reset kata sandi',
                                titleColor: AppColors.primary,
                              ),
                              SizedBox(height: SizeConfig.getHeight(3)),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: SizeConfig.getHeight(4)),
                              PrimaryButton(
                                text: 'Kirim Tautan',
                                onPressed: _sendResetLink,
                                isLoading: _isLoading,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(4)),
                        AuthFooter(
                          bottomText: 'Kembali ke',
                          actionText: 'Masuk',
                          onAction: () => context.go('/login'),
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
