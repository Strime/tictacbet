import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class BetAmountDisplay extends StatelessWidget {
  final int remainingBalance;

  const BetAmountDisplay({
    super.key,
    required this.remainingBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.wallet,
            size: AppSpacing.iconSm,
            color: AppColors.chipGold,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '\$$remainingBalance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.chipGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
