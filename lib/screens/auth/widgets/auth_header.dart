import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
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
          subtitle,
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
    );
  }
}
