import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/provider/auth_provider.dart';
import 'package:femora/widgets/auth_footer.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/password_field.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/text_field_custom.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Gagal'),
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

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 1. Validasi jika salah satu atau kedua field kosong
    if (email.isEmpty || password.isEmpty) {
      _showAlert('Email dan kata sandi tidak boleh kosong.');
      return;
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _showAlert('Format email tidak valid. Silakan periksa kembali.');
      return;
    }

    // Panggil fungsi login dari provider
    bool ok = await auth.login(email: email, password: password);

    if (ok) {
      if (!mounted) return;
      context.go('/home');
    } else {
      // 2. Tampilkan pesan error umum jika login gagal (karena email/kata sandi salah)
      _showAlert('Email atau kata sandi yang Anda masukkan salah. Silakan periksa kembali.');
    }
  }

  void _handleGoogleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool ok = await auth.loginWithGoogle();
    if (ok) {
      if (!mounted) return;
      context.go('/home');
    } else {
      if (!mounted) return;
      // Untuk login Google, kita bisa tampilkan error yang lebih spesifik jika perlu
      _showAlert(auth.errorMessage);
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
                                title: 'Halo,',
                                subtitle: 'Masuk dan pantau siklusmu',
                                titleColor: AppColors.primary,
                              ),
                              SizedBox(height: SizeConfig.getHeight(3)),
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: SizeConfig.getHeight(2)),
                              PasswordField(
                                controller: _passwordController,
                                hintText: 'Kata Sandi',
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push('/forgot-password'),
                                  child: const Text(
                                    'Lupa Kata Sandi?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.getHeight(2)),
                              PrimaryButton(
                                text: 'Masuk',
                                onPressed: _handleLogin,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(3)),
                        AuthFooter(
                          bottomText: 'Belum punya akun?',
                          actionText: 'Daftar',
                          onAction: () => context.replace('/register'),
                          onSocialLogin: _handleGoogleLogin,
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
