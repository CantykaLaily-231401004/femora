import 'package:femora/services/cycle_data_service.dart';
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
import 'package:femora/widgets/password_field.dart';
import 'package:provider/provider.dart';
import 'package:femora/provider/auth_provider.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isAgreed = false;

    final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

void _handleSignUp() async {
  final auth = Provider.of<AuthProvider>(context, listen: false);

  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  // Validasi Input
  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua field harus diisi')),
    );
    return;
  }

  // Proses Sign Up
  bool ok = await auth.signUp(
    fullName: name,
    email: email,
    password: password,
  );

  if (ok) {
    if (!mounted) return;
    context.go(AppRoutes.home); // redirect
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              const AuthHeader(
                                title: 'Mulai Hari ini!',
                                subtitle: 'Bergabung sekarang dan prediksi siklusmu',
                                titleColor: Color(0xFFDC143C),
                              ),
                              
                              SizedBox(height: SizeConfig.getHeight(3)),

                              // Form Fields
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
                              ),

                              SizedBox(height: SizeConfig.getHeight(2)),

                              // Checkbox Terms
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

                              // Button Daftar
                              PrimaryButton(
                                text: 'Daftar',
                                onPressed: _isAgreed
                                    ? () {
                                        if (_nameController.text.isEmpty || 
                                            _emailController.text.isEmpty || 
                                            _passwordController.text.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Harap isi semua data')),
                                          );
                                          return;
                                        }
                                        _handleSignUp();
                                        // "Menabung" nama ke brankas data
                                        CycleDataService().setFullName(_nameController.text);
                                        context.push('/profile-setup');
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.getHeight(3)),

                        Text(
                          'atau hubungkan dengan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: SizeConfig.getFontSize(14),
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(1.5)),

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

                        SizedBox(height: SizeConfig.getHeight(2.5)),

                        Center(
                          child: GestureDetector(
                            onTap: () => context.replace(AppRoutes.login),
                            child: RichText(
                              text: TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: SizeConfig.getFontSize(14),
                                  fontFamily: AppTextStyles.fontFamily,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Masuk',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        AuthFooter(
                          bottomText: 'Sudah punya akun?',
                          actionText: 'Masuk',
                          onAction: () => context.replace('/login'),
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
