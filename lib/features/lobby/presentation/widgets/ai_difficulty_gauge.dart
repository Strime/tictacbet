import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AiDifficultyGauge extends StatelessWidget {
  final double aiLevel;
  final String label;

  const AiDifficultyGauge({
    super.key,
    required this.aiLevel,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = _difficultyColor(aiLevel);

    return Row(
      children: [
        Text(
          'AI',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Background track
                  Container(
                    height: AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                    ),
                  ),
                  // Filled track
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: AppSpacing.animationMedium,
                    ),
                    curve: Curves.easeOut,
                    height: AppSpacing.sm,
                    width: constraints.maxWidth * aiLevel.clamp(0.05, 1.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _gradientColors(aiLevel),
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: AppSpacing.animationFast),
          child: Text(
            label,
            key: ValueKey(label),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _gradientColors(double level) {
    if (level >= 1.0) {
      return [AppColors.warning, AppColors.error];
    }
    if (level >= 0.7) {
      return [AppColors.chipGold, AppColors.warning];
    }
    if (level >= 0.3) {
      return [AppColors.success, AppColors.chipGold];
    }
    return [AppColors.success, AppColors.success];
  }

  Color _difficultyColor(double level) {
    if (level >= 1.0) return AppColors.error;
    if (level >= 0.7) return AppColors.warning;
    if (level >= 0.3) return AppColors.chipGold;
    return AppColors.success;
  }
}
