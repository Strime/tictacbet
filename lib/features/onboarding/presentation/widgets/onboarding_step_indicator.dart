import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  static const double _connectorWidth = 32.0;
  static const double _connectorThickness = 2.0;
  static const double _dotSizeActive = 12.0;
  static const double _dotSizeInactive = 8.0;
  static const double _connectorRadius = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < totalSteps; i++) ...[
          if (i > 0)
            AnimatedContainer(
              duration:
                  const Duration(milliseconds: AppSpacing.animationMedium),
              curve: Curves.easeOut,
              width: _connectorWidth,
              height: _connectorThickness,
              margin:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              decoration: BoxDecoration(
                color: i <= currentStep
                    ? AppColors.chipGold
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(_connectorRadius),
              ),
            ),
          AnimatedContainer(
            duration:
                const Duration(milliseconds: AppSpacing.animationMedium),
            curve: Curves.easeOut,
            width: i == currentStep ? _dotSizeActive : _dotSizeInactive,
            height: i == currentStep ? _dotSizeActive : _dotSizeInactive,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= currentStep
                  ? AppColors.chipGold
                  : AppColors.surfaceLight,
              boxShadow: i == currentStep ? AppShadows.glow : null,
            ),
          ),
        ],
      ],
    );
  }
}
