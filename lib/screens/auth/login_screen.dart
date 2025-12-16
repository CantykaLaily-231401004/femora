import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; // Updated import
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
  final _emailFocusNode = FocusNode();

  // State for smart login
  String? _loginMethod; // Can be 'password' or 'google'
  bool _isCheckingEmail = false;
  String _infoMessage = '';

  @override
  void initState() {
    super.initState();
    // Check email when the user finishes typing
    _emailFocusNode.addListener(_onEmailFocusChange);
    _loginMethod = 'password'; // Default to password login
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.removeListener(_onEmailFocusChange);
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onEmailFocusChange() {
    if (!_emailFocusNode.hasFocus) {
      _checkEmailProvider(_emailController.text.trim());
    }
  }

  Future<void> _checkEmailProvider(String email) async {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      setState(() {
        _infoMessage = ''; 
        _loginMethod = 'password';
      });
      return;
    }

    setState(() {
      _isCheckingEmail = true;
      _infoMessage = '';
    });

    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (!mounted) return;

      if (methods.contains('google.com') && !methods.contains('password')) {
        setState(() {
          _loginMethod = 'google';
          _infoMessage = 'Akun ini terhubung dengan Google. Silakan lanjutkan dengan Google.';
        });
      } else {
        setState(() {
          _loginMethod = 'password';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loginMethod = 'password';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
        });
      }
    }
  }

  void _showAlert(String message) {
    if (!mounted) return;
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

    if (email.isEmpty || password.isEmpty) {
      _showAlert('Email dan kata sandi tidak boleh kosong.');
      return;
    }

    bool ok = await auth.login(email: email, password: password);

    if (ok) {
      if (!mounted) return;
      context.go('/home');
    } else {
      if (!mounted) return;
      _showAlert(auth.errorMessage.isNotEmpty ? auth.errorMessage : 'Email atau kata sandi yang Anda masukkan salah.');
    }
  }

  void _handleGoogleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool ok = await auth.loginWithGoogle();
    if (ok) {
      if (!mounted) return;
      context.go('/home');
    } else {
      if (mounted && auth.errorMessage.isNotEmpty) {
        _showAlert(auth.errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final auth = Provider.of<AuthProvider>(context);
    bool isPasswordLogin = _loginMethod != 'google';

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
                                focusNode: _emailFocusNode,
                                hintText: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                suffixIcon: _isCheckingEmail
                                    ? const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              if (_infoMessage.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
                                  child: Text(
                                    _infoMessage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              SizedBox(height: SizeConfig.getHeight(2)),
                              PasswordField(
                                controller: _passwordController,
                                hintText: 'Kata Sandi',
                                enabled: isPasswordLogin,
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
                                onPressed: isPasswordLogin ? _handleLogin : null,
                                isLoading: auth.isLoading,
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
