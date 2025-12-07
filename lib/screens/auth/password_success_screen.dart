import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/gradient_background.dart';

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({Key? key}) : super(key: key);

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Success Content
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getWidth(4),
                      vertical: SizeConfig.getHeight(5),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE7EA),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD0D5),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF75270),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(3)),

                        // Success Text
                        const Text(
                          'Selesai',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFDC143C),
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.20,
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(1.5)),
                        const Text(
                          'Kata sandimu berhasil diubah!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),

                        SizedBox(height: SizeConfig.getHeight(4)),

                        // Back to Home Button
                        PrimaryButton(
                          text: 'Kembali ke Beranda',
                          onPressed: () => context.go('/home'),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Bottom Policy Text
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.getHeight(2),
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
          ),
        ],
      ),
    );
  }
}
