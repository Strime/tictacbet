import 'package:flutter/material.dart';

/// 8dp grid system for consistent spacing.
class AppSpacing {
  AppSpacing._();

  static const double _unit = 8.0;

  // Spacing scale
  static const double xxs = _unit * 0.25; // 2dp
  static const double xs = _unit * 0.5; // 4dp
  static const double sm = _unit * 1; // 8dp
  static const double md = _unit * 1.5; // 12dp
  static const double lg = _unit * 2; // 16dp
  static const double xl = _unit * 3; // 24dp
  static const double xxl = _unit * 4; // 32dp
  static const double xxxl = _unit * 5; // 40dp

  // Component sizes
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 72.0;
  static const double cardSize = 80.0;
  static const double boardCellSize = 100.0;
  static const double navFabSize = 64.0;
  static const double navFabOverhang = 16.0;
  static const double navNotchMargin = 6.0;

  // Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // Animation durations (ms)
  static const int animationFast = 150;
  static const int animationMedium = 300;
  static const int animationSlow = 500;
}
