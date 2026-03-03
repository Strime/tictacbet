import 'package:flutter/material.dart';

/// Casino-themed color palette.
class AppColors {
  AppColors._();

  // --- Casino felt & atmosphere ---
  static const Color feltGreen = Color(0xFF35654D);
  static const Color feltGreenDark = Color(0xFF264A38);
  static const Color feltGreenLight = Color(0xFF4A8B6A);

  // --- Card colors ---
  static const Color heartRed = Color(0xFFE53935);
  static const Color heartRedLight = Color(0xFFFF6F60);
  static const Color spadeBlack = Color(0xFF263238);
  static const Color spadeBlackLight = Color(0xFF4F5B62);

  // --- Chips & gold ---
  static const Color chipGold = Color(0xFFFFD54F);
  static const Color chipGoldDark = Color(0xFFC9A825);
  static const Color chipSilver = Color(0xFFB0BEC5);

  // --- Bonus colors ---
  static const Color coinColor = Color(0xFFFFD54F);
  static const Color cloverColor = Color(0xFF66BB6A);
  static const Color xpColor = Color(0xFF7C4DFF);

  // --- Semantic ---
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // --- Surface & text ---
  static const Color background = Color(0xFF1A1A2E);
  static const Color backgroundDeep = Color(0xFF1F2040);
  static const Color surface = Color(0xFF16213E);
  static const Color surfaceLight = Color(0xFF1F2E50);
  static const Color onBackground = Color(0xFFE0E0E0);
  static const Color onSurface = Color(0xFFBDBDBD);
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFB0B0B0);

  // --- Material 3 ColorScheme ---
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: feltGreen,
    brightness: Brightness.dark,
    primary: feltGreen,
    secondary: chipGold,
    surface: surface,
    error: error,
  );
}
