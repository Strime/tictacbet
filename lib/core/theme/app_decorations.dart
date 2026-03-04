import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_shadows.dart';
import 'app_spacing.dart';

/// Pre-built BoxDecoration presets for casino theme.
class AppDecorations {
  AppDecorations._();

  static BoxDecoration get card => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusMd,
    boxShadow: AppShadows.card,
  );

  static BoxDecoration get feltBackground => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.feltGreenDark, AppColors.feltGreen],
    ),
  );

  static BoxDecoration get cellHidden => BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: AppSpacing.borderRadiusSm,
  );

  static BoxDecoration get cellRevealed => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppSpacing.borderRadiusSm,
    boxShadow: AppShadows.subtle,
  );

  static BoxDecoration get outlined => BoxDecoration(
    border: Border.all(
      color: AppColors.onSurface.withValues(alpha: 0.12),
    ),
    borderRadius: AppSpacing.borderRadiusSm,
  );

  static BoxDecoration get backgroundGradient => const BoxDecoration(
    gradient: RadialGradient(
      center: Alignment(0, -0.3),
      radius: 1.2,
      colors: [
        AppColors.backgroundDeep,
        AppColors.background,
      ],
    ),
  );
}
