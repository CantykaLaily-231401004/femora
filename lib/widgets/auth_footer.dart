import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class AuthFooter extends StatelessWidget {
  final String bottomText;
  final String actionText;
  final VoidCallback onAction;
  final VoidCallback? onSocialLogin;

  const AuthFooter({
    Key? key,
    required this.bottomText,
    required this.actionText,
    required this.onAction,
    this.onSocialLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      children: [
        if (onSocialLogin != null) ...[
          const Text(
            'atau hubungkan dengan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(2)),
          Center(
            child: GestureDetector(
              onTap: onSocialLogin,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Image.asset(AppAssets.googleIcon, width: 28, height: 28),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.getHeight(3)),
        ],

        // Bottom Text
        _FooterLink(
          text: bottomText,
          linkText: actionText,
          onTap: onAction,
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const _FooterLink({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: '$text ',
          style: TextStyle(
            color: AppColors.textPrimary, // Changed to black
            fontSize: SizeConfig.getFontSize(14),
            fontFamily: AppTextStyles.fontFamily,
          ),
          children: [
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: AppColors.primary, // Changed to pink
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
