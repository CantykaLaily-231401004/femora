import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/core/widgets/buttons/custom_back_button.dart';
import 'package:femora/core/widgets/buttons/primary_button.dart';
import 'package:femora/core/widgets/common/gradient_background.dart';
import 'package:femora/core/widgets/inputs/text_field_custom.dart';
import 'package:femora/core/widgets/inputs/password_field.dart';
import 'package:femora/screens/auth/widgets/auth_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAgreed = false;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
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
          Positioned(
            left: 0,
            top: 0,
            child: GradientBackground(
              height: SizeConfig.getHeight(60),
              child: const SizedBox(),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(5),
                ),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.getHeight(2.5)),

                    // Back Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomBackButton(
                        onPressed: () => context.pop(),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(5)),

                    // White Card Container
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getWidth(4),
                        vertical: SizeConfig.getHeight(2.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header
                          Text(
                            'Halo,',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textHighlight,
                              fontSize: SizeConfig.getFontSize(30),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w700,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          Text(
                            'Masuk dan pantau siklusmu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: SizeConfig.getFontSize(14),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),

                          SizedBox(height: SizeConfig.getHeight(3)),

                          // Email Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: SizeConfig.getFontSize(16),
                                fontFamily: AppTextStyles.fontFamily,
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            icon: Icons.email_outlined,
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Password Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Kata Sandi',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: SizeConfig.getFontSize(16),
                                fontFamily: AppTextStyles.fontFamily,
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          PasswordField(
                            controller: _passwordController,
                          ),

                          SizedBox(height: SizeConfig.getHeight(1)),

                          // Lupa Kata Sandi
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: SizeConfig.getFontSize(14),
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Checkbox Terms
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
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
                              ),
                              SizedBox(width: SizeConfig.getWidth(2.5)),
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
                                      fontWeight: FontWeight.w500,
                                      height: 1.20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: SizeConfig.getHeight(3)),

                          // Masuk Button
                          PrimaryButton(
                            text: 'Masuk',
                            onPressed: _isAgreed
                                ? () {
                                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Harap isi email dan password')),
                                      );
                                      return;
                                    }
                                    // Login Logic and Navigate to Home
                                    context.go(AppRoutes.home); 
                                  }
                                : null,
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Atau lanjutkan dengan
                          Text(
                            'Atau lanjutkan dengan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: SizeConfig.getFontSize(14),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1.5)),
                          GestureDetector(
                            onTap: () {
                              // TODO: Google Sign In
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                AppAssets.googleIcon,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                           // Footer Link
                          GestureDetector(
                            onTap: () {
                              context.push(AppRoutes.register);
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Belum punya akun?',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: SizeConfig.getFontSize(12),
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Daftar',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: SizeConfig.getFontSize(12),
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: SizeConfig.getHeight(5)),

                    // Footer Links
                    const AuthFooter(),
                    
                    SizedBox(height: SizeConfig.getHeight(2.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
