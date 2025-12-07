import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF75270);
  static const Color primaryLight = Color(0xFFF7CAC9); // Approximate from usage
  static const Color primaryDark = Color(0xFFDC143C); // Approximate from usage
  static const Color cream = Color(0xFFFDEBD0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF808080);
  static const Color lightGrey = Color(0xFFBEBEBE);
  
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF6B6B6B); // Darkened Grey
  static const Color textHighlight = Color(0xFFDC143C);
  static const Color borderColor = Color(0xFFF1F1F1);
  static const Color borderColorDark = Color(0xFFCCCCCC);
  
  static const Color gradientStart = Color(0xFFF75270);
  static const Color gradientMiddle = Color(0xFFFDEBD0);
  static const Color gradientEnd = Colors.white;

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [gradientStart, Color(0xFFF76B85)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppFonts {
  static const String primary = 'Poppins';
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';
}

class AppAssets {
  static const String logoWhite = 'assets/images/Logo_White.png';
  static const String logoRed = 'assets/images/Logo_Red.png';
  static const String onboarding1 = 'assets/images/onboarding1.png'; // Placeholder name
  static const String onboarding2 = 'assets/images/onboarding2.png'; // Placeholder name
  static const String onboarding3 = 'assets/images/onboarding3.png'; // Placeholder name
  static const String googleIcon = 'assets/images/Google_Icon.png';
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 15.0;
  static const double lg = 30.0;
  static const double xl = 40.0;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration normal = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
}
