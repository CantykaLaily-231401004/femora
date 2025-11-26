import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';

/// Reusable Auth Footer dengan link kebijakan privasi dan syarat ketentuan
class AuthFooter extends StatelessWidget {
  const AuthFooter({Key? key}) : super(key: key);

  void _onPrivacyPolicyPressed() {
    // TODO: Navigasi ke kebijakan privasi
    debugPrint('Kebijakan Privasi clicked');
  }

  void _onTermsPressed() {
    // TODO: Navigasi ke syarat & ketentuan
    debugPrint('Syarat & Ketentuan clicked');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FooterLink(
          text: 'Kebijakan Privasi',
          onPressed: _onPrivacyPolicyPressed,
        ),
        SizedBox(width: SizeConfig.getWidth(5)),
        _FooterLink(
          text: 'Syarat & Ketentuan',
          onPressed: _onTermsPressed,
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _FooterLink({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: SizeConfig.getFontSize(12),
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w400,
          height: 1.20,
          decoration: TextDecoration.underline, // Optional: untuk memperjelas bahwa ini link
        ),
      ),
    );
  }
}
