import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getWidth(3),
          vertical: SizeConfig.getHeight(1.2),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.borderColor,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: SizeConfig.getWidth(10),
                    height: SizeConfig.getWidth(10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(63),
                    ),
                    child: Image.asset(
                      iconPath,
                    ),
                  ),
                  SizedBox(width: SizeConfig.getWidth(3)),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: SizeConfig.getFontSize(14),
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
