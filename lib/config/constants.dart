import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF75270);
  static const Color primaryLight = Color(0xFFF7CAC9);
  static const Color primaryDark = Color(0xFFDC143C);
  static const Color cream = Color(0xFFFDEBD0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF808080);
  static const Color lightGrey = Color(0xFFBEBEBE);
  
  static const Color background = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF6B6B6B);
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
  static const String onboarding1 = 'assets/images/onboarding1.png';
  static const String onboarding2 = 'assets/images/onboarding2.png';
  static const String onboarding3 = 'assets/images/onboarding3.png';
  static const String googleIcon = 'assets/images/Google_Icon.png';

  // --- Cycle Phase Images ---
  static const String faseMenstruasi = 'assets/images/fase_menstruasi.png';
  static const String faseFolikular = 'assets/images/fase_folikular.png';
  static const String faseOvulasi = 'assets/images/fase_ovulasi.png';
  static const String faseLuteal = 'assets/images/fase_luteal.png';

  // --- Ikon Riwayat & Gejala ---
  static const String moodSwing = 'assets/icon/mood_swing.png';
  static const String kembung = 'assets/icon/kembung.png';
  static const String nyeriPunggung = 'assets/icon/nyeri_punggung.png';
  static const String kelelahan = 'assets/icon/kelelahan.png';
  static const String nyeriPerut = 'assets/icon/nyeri_perut.png';
  static const String sakitKepala = 'assets/icon/sakit_kepala.png';
  
  // Aliran
  static const String flowLow = 'assets/images/flow_low.png';
  static const String flowNormal = 'assets/images/flow_normal.png';
  static const String flowHeavy = 'assets/images/flow_heavy.png';
  
  // Suasana Hati
  static const String moodBaikIcon = 'assets/images/mood_baik.png';
  static const String moodBurukIcon = 'assets-images/mood_buruk.png';
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
