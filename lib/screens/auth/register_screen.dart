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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isAgreed = false;
  bool _isPasswordVisible = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Mulai Hari ini!',
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
                                  'Bergabung sekarang dan prediksi siklusmu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: SizeConfig.getFontSize(14),
                                    fontFamily: AppTextStyles.fontFamily,
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: SizeConfig.getHeight(3)),

                          // Form Fields
                          // Nama Lengkap
                          Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: SizeConfig.getFontSize(16),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w500,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Nama Lengkap',
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Email
                          Text(
                            'Email',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: SizeConfig.getFontSize(16),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w500,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Password
                          Text(
                            'Kata Sandi',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: SizeConfig.getFontSize(16),
                              fontFamily: AppTextStyles.fontFamily,
                              fontWeight: FontWeight.w500,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(1)),
                          PasswordField(
                            controller: _passwordController,
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

                                    context.push(AppRoutes.profileSetup);
                                  }
                                : null,
                          ),

                          SizedBox(height: SizeConfig.getHeight(2.5)),

                          // Divider "atau hubungkan dengan"
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'atau hubungkan dengan ',
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
                                    print('Google Sign In from Register');
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(2.5)),

                    // Footer Link
                    GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.login);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Sudah punya akun?',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: SizeConfig.getFontSize(16),
                                fontFamily: AppTextStyles.fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' Masuk',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: SizeConfig.getFontSize(16),
                                fontFamily: AppTextStyles.fontFamily,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: SizeConfig.getHeight(5)),
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
