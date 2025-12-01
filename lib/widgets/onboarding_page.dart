import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/models/onboarding_content.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPage({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.getHeight(5)),
        
        // Image
        Expanded(
          flex: 6,
          child: Image.asset(
            content.imagePath,
            fit: BoxFit.contain,
          ),
        ),
        
        SizedBox(height: SizeConfig.getHeight(2)),
        
        // Text Content
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getWidth(8),
            ),
            child: Column(
              children: [
                Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textHighlight,
                    fontSize: SizeConfig.getFontSize(24),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(2)),
                Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: SizeConfig.getFontSize(14),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
