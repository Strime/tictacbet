import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class PotentialWinningsWidget extends StatefulWidget {
  final int potentialWinnings;

  const PotentialWinningsWidget({
    super.key,
    required this.potentialWinnings,
  });

  @override
  State<PotentialWinningsWidget> createState() =>
      _PotentialWinningsWidgetState();
}

class _PotentialWinningsWidgetState extends State<PotentialWinningsWidget> {
  int _previousWinnings = 0;

  @override
  void didUpdateWidget(PotentialWinningsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.potentialWinnings != widget.potentialWinnings) {
      _previousWinnings = oldWidget.potentialWinnings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: AppColors.chipGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: AppColors.chipGold,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Potential winnings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          TweenAnimationBuilder<int>(
            tween: IntTween(
              begin: _previousWinnings,
              end: widget.potentialWinnings,
            ),
            duration: const Duration(milliseconds: AppSpacing.animationMedium),
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return Text(
                '+\$$value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
