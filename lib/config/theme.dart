import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';

// Custom transition builder that does nothing.
class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.pink,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      // 1. Set the global font family
      fontFamily: AppFonts.primary, 

      // 2. Explicitly set it for the TextTheme to ensure consistency
      textTheme: const TextTheme().apply(fontFamily: AppFonts.primary),
      primaryTextTheme: const TextTheme().apply(fontFamily: AppFonts.primary),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: NoTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionsBuilder(),
        },
      ),
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
