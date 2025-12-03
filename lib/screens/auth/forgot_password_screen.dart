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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi email')),
      );
      return;
    }
    context.push(AppRoutes.resetPassword);
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
                                title: 'Lupa Kata Sandi',
                                subtitle: 'Masukkan alamat emailmu untuk kirim tautan reset kata sandi',
                                titleColor: Color(0xFFDC143C),
                              ),
                              
                              SizedBox(height: SizeConfig.getHeight(3)),

                              // Email Field
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              SizedBox(height: SizeConfig.getHeight(4)),

                              // Kirim Kode OTP Button
                              PrimaryButton(
                                text: 'Kirim Kode OTP',
                                onPressed: _sendOtp,
                              ),
                            ],
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
