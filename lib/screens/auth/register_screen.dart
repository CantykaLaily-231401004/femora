import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/auth_footer.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/text_field_custom.dart';
import 'package:femora/widgets/password_field.dart';
import 'package:provider/provider.dart';
import 'package:femora/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isAgreed = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showAlert(String title, String message) {
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

  Future<void> _handleSignUp() async {
    if (_isLoading) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi field kosong
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlert('Peringatan', 'Semua field harus diisi');
      return;
    }

    // Validasi email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _showAlert('Email Tidak Valid', 'Format email tidak valid. Silakan periksa kembali.');
      return;
    }

    // Validasi password minimal 6 karakter
    if (password.length < 6) {
      _showAlert('Password Lemah', 'Kata sandi harus minimal 6 karakter.');
      return;
    }

    // Validasi checkbox syarat & ketentuan
    if (!_isAgreed) {
      _showAlert('Peringatan', 'Anda harus menyetujui Syarat & Ketentuan untuk melanjutkan.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final success = await auth.signUp(
        fullName: name,
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (success) {
        // Registrasi berhasil, redirect ke profile setup (user baru)
        debugPrint('✅ Registration successful, redirecting to profile setup');
        context.go(AppRoutes.profileSetup);
      } else {
        setState(() => _isLoading = false);
        _showAlert('Registrasi Gagal', auth.errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showAlert('Error', 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final success = await auth.loginWithGoogle();

      if (!mounted) return;

      if (success) {
        context.go(AppRoutes.home);
      } else {
        setState(() => _isLoading = false);
        _showAlert('Login Gagal', auth.errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showAlert('Error', 'Terjadi kesalahan: ${e.toString()}');
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
                    child: Form(
                      key: _formKey,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AuthHeader(
                                  title: 'Mulai Hari ini!',
                                  subtitle: 'Bergabung sekarang dan prediksi siklusmu',
                                  titleColor: AppColors.primary,
                                ),
                                SizedBox(height: SizeConfig.getHeight(3)),
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: 'Nama Lengkap',
                                  icon: Icons.person_outline,
                                ),
                                SizedBox(height: SizeConfig.getHeight(2)),
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  icon: Icons.email_outlined,
                                ),
                                SizedBox(height: SizeConfig.getHeight(2)),
                                PasswordField(
                                  controller: _passwordController,
                                  hintText: 'Kata Sandi',
                                ),
                                SizedBox(height: SizeConfig.getHeight(2)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: _isAgreed,
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.textSecondary,
                                        width: 1.2,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _isAgreed = value ?? false;
                                        });
                                      },
                                    ),
                                    SizedBox(width: SizeConfig.getWidth(1)),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isAgreed = !_isAgreed;
                                          });
                                        },
                                        child: Text(
                                          'Saya setuju dengan Syarat & Ketentuan Femora.',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: SizeConfig.getFontSize(12),
                                            fontFamily: AppTextStyles.fontFamily,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.getHeight(3)),
                                PrimaryButton(
                                  text: 'Daftar',
                                  onPressed: _isLoading ? null : _handleSignUp,
                                  isLoading: _isLoading,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(3)),
                          AuthFooter(
                            bottomText: 'Sudah punya akun?',
                            actionText: 'Masuk',
                            onAction: () => context.replace(AppRoutes.login),
                            onSocialLogin: _isLoading ? null : _handleGoogleLogin,
                          ),
                          SizedBox(height: SizeConfig.getHeight(2)),
                        ],
                      ),
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