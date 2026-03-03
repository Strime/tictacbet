import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';

class FloatingBetBar extends StatefulWidget {
  final int betAmount;
  final int potentialWinnings;
  final bool canPlay;
  final VoidCallback onPlay;

  const FloatingBetBar({
    super.key,
    required this.betAmount,
    required this.potentialWinnings,
    required this.canPlay,
    required this.onPlay,
  });

  @override
  State<FloatingBetBar> createState() => _FloatingBetBarState();
}

class _FloatingBetBarState extends State<FloatingBetBar> {
  int _previousBet = 0;
  int _previousWinnings = 0;

  @override
  void didUpdateWidget(FloatingBetBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.betAmount != widget.betAmount) {
      _previousBet = oldWidget.betAmount;
    }
    if (oldWidget.potentialWinnings != widget.potentialWinnings) {
      _previousWinnings = oldWidget.potentialWinnings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        bottomPadding + AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: AppColors.chipGold.withValues(alpha: 0.25),
          ),
          boxShadow: AppShadows.elevated,
        ),
        child: Row(
          children: [
            // Bet amount
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: _previousBet, end: widget.betAmount),
              duration:
                  const Duration(milliseconds: AppSpacing.animationMedium),
              curve: Curves.easeOut,
              builder: (_, value, _) => Text(
                value.toCurrency(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.chipGold,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Icon(
              LucideIcons.arrowRight,
              size: AppSpacing.iconSm,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),

            // Potential winnings
            TweenAnimationBuilder<int>(
              tween: IntTween(
                begin: _previousWinnings,
                end: widget.potentialWinnings,
              ),
              duration:
                  const Duration(milliseconds: AppSpacing.animationMedium),
              curve: Curves.easeOut,
              builder: (_, value, _) => Text(
                value.toSignedCurrency(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Spacer(),

            // Play button pill
            GestureDetector(
              onTap: widget.canPlay ? widget.onPlay : null,
              child: AnimatedOpacity(
                opacity: widget.canPlay ? 1.0 : 0.4,
                duration:
                    const Duration(milliseconds: AppSpacing.animationFast),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.feltGreen,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Play',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(
                        LucideIcons.play,
                        size: AppSpacing.iconSm,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
