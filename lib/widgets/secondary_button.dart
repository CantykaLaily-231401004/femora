import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.borderColorDark,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16, // Using fixed size for button text usually, or SizeConfig.getFontSize(16)
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w600,
            height: 1.20,
          ),
        ),
      ),
    );
  }
}
