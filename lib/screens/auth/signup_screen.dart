import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/secondary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/social_login_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Gradient
          GradientBackground(
            height: SizeConfig.getHeight(45),
            child: const SizedBox(),
          ),

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

                // Main Content Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getWidth(4),
                      vertical: SizeConfig.getHeight(4),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(
                          title: 'Daftar',
                          subtitle: 'Waktunya mengakses akunmu',
                          titleColor: Color(0xFFDC143C),
                        ),
                        SizedBox(height: SizeConfig.getHeight(3)),
                        SocialLoginButton(
                          text: 'Lanjutkan dengan Google',
                          iconPath: AppAssets.googleIcon,
                          onPressed: () {},
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        PrimaryButton(
                          text: 'Daftar',
                          onPressed: () => context.push('/register'),
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        SecondaryButton(
                          text: 'Masuk',
                          onPressed: () => context.push('/login'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),

                // Bottom Policy Text
                Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.getHeight(2),
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
