import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class FloatingBetBar extends StatefulWidget {
  final int betAmount;
  final bool canPlay;
  final VoidCallback onPlay;

  const FloatingBetBar({
    super.key,
    required this.betAmount,
    required this.canPlay,
    required this.onPlay,
  });

  @override
  State<FloatingBetBar> createState() => _FloatingBetBarState();
}

class _FloatingBetBarState extends State<FloatingBetBar> {
  int _previousBet = 0;

  @override
  void didUpdateWidget(FloatingBetBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.betAmount != widget.betAmount) {
      _previousBet = oldWidget.betAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        bottomPadding + AppSpacing.sm,
      ),
      child: GestureDetector(
        onTap: widget.canPlay ? widget.onPlay : null,
        child: AnimatedOpacity(
          opacity: widget.canPlay ? 1.0 : 0.4,
          duration: const Duration(milliseconds: AppSpacing.animationFast),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.feltGreen,
              borderRadius: AppSpacing.borderRadiusLg,
              boxShadow: AppShadows.elevated,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.play,
                  size: AppSpacing.iconSm,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.sm),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: _previousBet, end: widget.betAmount),
                  duration: const Duration(
                    milliseconds: AppSpacing.animationMedium,
                  ),
                  curve: Curves.easeOut,
                  builder: (_, value, _) => Text(
                    l10n.lobby_playWithBet(value),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
