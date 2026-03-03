import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';

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
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.trophy,
            color: AppColors.chipGold,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.lobby_potentialWinnings,
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
                value.toSignedCurrency(),
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
