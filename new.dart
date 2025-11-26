import 'package:flutter/material.dart';

/// Kelas untuk mengelola ukuran responsif aplikasi
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late EdgeInsets safeAreaPadding;

  /// Inisialisasi SizeConfig, panggil di build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    safeAreaPadding = _mediaQueryData.padding;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeBlockHorizontal =
        (screenWidth - safeAreaPadding.left - safeAreaPadding.right) / 100;
    safeBlockVertical =
        (screenHeight - safeAreaPadding.top - safeAreaPadding.bottom) / 100;
  }

  /// Mendapatkan width responsif berdasarkan persentase layar
  static double getWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  /// Mendapatkan height responsif berdasarkan persentase layar
  static double getHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  /// Mendapatkan font size responsif
  static double getFontSize(double size) {
    return size * (screenWidth / 375); // 375 adalah baseline width (iPhone X)
  }
}
