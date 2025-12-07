import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/text_field_custom.dart';
import 'package:femora/widgets/password_field.dart';
import'package:provider/provider.dart';
import 'package:femora/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

void _handleLogin() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  // Validasi input
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email dan Kata sandi tidak boleh kosong')),
    );
    return;
  }

  // Proses Login
  bool ok = await auth.login(email: email, password: password);

  if (ok) {
    if (!mounted) return;
    context.go(AppRoutes.home); // redirect setelah login
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(auth.errorMessage)),
    );
  }
}

void _handleGoogleLogin() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  bool ok = await auth.loginWithGoogle();

  if (ok) {
    if (!mounted) return;
    context.go(AppRoutes.home);
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(auth.errorMessage)));
  }
}


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Gradient Background
          GradientBackground(
            height: SizeConfig.getHeight(40),
            child: const SizedBox(),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Back button
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

                // Form Area
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
                              // Header
                              const AuthHeader(
                                title: 'Halo,',
                                subtitle: 'Masuk dan pantau siklusmu',
                                titleColor: Color(0xFFDC143C),
                              ),
                              
                              SizedBox(height: SizeConfig.getHeight(3)),

                              // Form Fields
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              SizedBox(height: SizeConfig.getHeight(2)),

                              PasswordField(
                                controller: _passwordController,
                                hintText: 'Password',
                              ),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push(AppRoutes.forgotPassword),
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

                              // Login Button
                              PrimaryButton(
                                text: 'Masuk',
                                onPressed: _handleLogin,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.getHeight(3)),

                        const Text(
                          'Atau lanjutkan dengan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),

                        Center(
                          child: GestureDetector(
                            onTap: _handleGoogleLogin,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor, width: 1),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Image.asset(AppAssets.googleIcon, width: 28, height: 28),
                            ),
                          ),
                        ),

                        SizedBox(height: SizeConfig.getHeight(3)),

                        Center(
                          child: GestureDetector(
                            onTap: () => context.replace(AppRoutes.register),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontFamily: AppTextStyles.fontFamily,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Daftar',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                         SizedBox(height: SizeConfig.getHeight(2)),
                      ],
                    ),
                  ),
                ),

                // Bottom Policy Text
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getHeight(2),
                    horizontal: SizeConfig.getWidth(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kebijakan Privasi',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: SizeConfig.getFontSize(12),
                          fontFamily: AppTextStyles.fontFamily,
                        ),
                      ),
                      SizedBox(width: SizeConfig.getWidth(8)),
                      Text(
                        'Syarat & Ketentuan',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: SizeConfig.getFontSize(12),
                          fontFamily: AppTextStyles.fontFamily,
                        ),
                      ),
                    ],
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
