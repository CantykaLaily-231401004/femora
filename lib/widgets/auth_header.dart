import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? titleColor;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SizeConfig.getFontSize(30),
            fontFamily: AppTextStyles.fontFamily, // Ini adalah font Poppins
            fontWeight: FontWeight.w800, // Extra Bold
            color: titleColor ?? AppColors.textPrimary,
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(1)),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SizeConfig.getFontSize(14),
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
