import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.pink,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: Colors.white,
        error: Colors.red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.primary,
        ),
      ),
    );
  }
}
