import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../game/presentation/extensions/player_side_ui.dart';
import '../../domain/entities/game_result_entity.dart';

class HistoryListItem extends StatelessWidget {
  final GameResultEntity result;

  const HistoryListItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final (:Color accentColor, :IconData icon, :String label) = switch (result) {
      GameResultEntity(isCashOut: true) => (
          accentColor: AppColors.chipGold,
          icon: LucideIcons.banknote,
          label: l10n.history_result_cashOut,
        ),
      GameResultEntity(isWin: true) => (
          accentColor: AppColors.success,
          icon: LucideIcons.trophy,
          label: l10n.history_result_win,
        ),
      GameResultEntity(isDraw: true) => (
          accentColor: AppColors.chipGold,
          icon: LucideIcons.scale,
          label: l10n.history_result_draw,
        ),
      _ => (
          accentColor: AppColors.error,
          icon: LucideIcons.x,
          label: l10n.history_result_loss,
        ),
    };

    final difficultyLabel = _difficultyLabel(result.aiLevel, l10n);
    final netAmount = result.netAmount;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.iconXl,
            height: AppSpacing.iconXl,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: AppSpacing.iconMd),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Icon(
                      result.humanSide.icon,
                      size: AppSpacing.iconXs,
                      color: result.humanSide.color,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text(
                        difficultyLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${l10n.history_bet(result.betAmount)}  •  ${DateFormat.MMMd(l10n.localeName).add_Hm().format(result.playedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _NetAmountLabel(netAmount: netAmount),
        ],
      ),
    );
  }

  String _difficultyLabel(double aiLevel, AppLocalizations l10n) =>
      switch (aiLevel) {
        >= 1.0 => l10n.lobby_difficulty_expert,
        >= 0.7 => l10n.lobby_difficulty_hard,
        >= 0.3 => l10n.lobby_difficulty_medium,
        _ => l10n.lobby_difficulty_easy,
      };
}

class _NetAmountLabel extends StatelessWidget {
  final int netAmount;

  const _NetAmountLabel({required this.netAmount});

  @override
  Widget build(BuildContext context) {
    if (netAmount == 0) return const SizedBox.shrink();

    final color = netAmount > 0 ? AppColors.success : AppColors.error;

    return Text(
      netAmount.toSignedCurrency(),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
