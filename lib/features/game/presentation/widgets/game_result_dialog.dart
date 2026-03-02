import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';

class GameResultDialog extends StatelessWidget {
  final bool humanWon;
  final bool isDraw;
  final int betAmount;
  final AppLocalizations l10n;
  final VoidCallback onPlayAgain;
  final int winnings;

  const GameResultDialog({
    super.key,
    required this.humanWon,
    required this.isDraw,
    required this.betAmount,
    required this.l10n,
    required this.onPlayAgain,
    required this.winnings,
  });

  @override
  Widget build(BuildContext context) {
    final resultText = humanWon
        ? l10n.game_result_win
        : isDraw
            ? l10n.game_result_draw
            : l10n.game_result_loss;

    final resultColor = humanWon
        ? AppColors.success
        : isDraw
            ? AppColors.chipGold
            : AppColors.error;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusLg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              resultText,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: resultColor,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().scale(),
            const SizedBox(height: AppSpacing.md),
            _WinningsText(
              humanWon: humanWon,
              isDraw: isDraw,
              winnings: winnings,
              betAmount: betAmount,
            ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
            const SizedBox(height: AppSpacing.lg),
            _XpSection(l10n: l10n)
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 400)),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPlayAgain,
                child: Text(l10n.game_result_playAgain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WinningsText extends StatelessWidget {
  final bool humanWon;
  final bool isDraw;
  final int winnings;
  final int betAmount;

  const _WinningsText({
    required this.humanWon,
    required this.isDraw,
    required this.winnings,
    required this.betAmount,
  });

  @override
  Widget build(BuildContext context) {
    final String text;
    final Color color;

    if (humanWon) {
      final netProfit = winnings - betAmount;
      text = '+\$$netProfit';
      color = AppColors.success;
    } else if (isDraw) {
      text = '\$0';
      color = AppColors.chipGold;
    } else {
      text = '-\$$betAmount';
      color = AppColors.error;
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _XpSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _XpSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProgressionBloc, ProgressionState>(
      builder: (context, state) {
        if (state is! ProgressionLoaded) {
          return const SizedBox.shrink();
        }
        final progression = state.progression;
        final xpEarned = state.xpEarned ?? 0;
        final streak = progression.currentWinStreak;
        final multiplier = GameConstants.streakMultiplier(streak);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.game_result_xpEarned(xpEarned),
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.xpColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (streak >= 2) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.game_result_streakBonus(
                  multiplier.toStringAsFixed(1),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.xpColor.withValues(alpha: 0.8),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: LinearProgressIndicator(
                value: progression.progressFraction,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.xpColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.profile_levelXp(
                progression.level,
                progression.totalXp - progression.xpForCurrentLevel,
                progression.xpForNextLevel - progression.xpForCurrentLevel,
              ),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (state.leveledUp) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.game_result_levelUp,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.xpColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
