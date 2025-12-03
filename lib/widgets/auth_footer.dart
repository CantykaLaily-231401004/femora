import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/social_login_button.dart';

class AuthFooter extends StatelessWidget {
  final String bottomText;
  final String actionText;
  final VoidCallback onAction;

  const AuthFooter({
    Key? key,
    required this.bottomText,
    required this.actionText,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Column(
      children: [
        // Or Divider
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.lightGrey)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(4)),
              child: Text(
                'Atau',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: SizeConfig.getFontSize(14),
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.lightGrey)),
          ],
        ),

        SizedBox(height: SizeConfig.getHeight(2.5)),

        // Social Login
        SocialLoginButton(
          text: 'Masuk dengan Google',
          iconPath: AppAssets.googleIcon,
          onPressed: () {
            // TODO: Implement Google Sign In
          },
        ),

        SizedBox(height: SizeConfig.getHeight(5)),

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
            color: AppColors.textPrimary,
            fontSize: SizeConfig.getFontSize(12),
            fontFamily: AppTextStyles.fontFamily,
          ),
          children: [
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
