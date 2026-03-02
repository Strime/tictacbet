import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileLoaded state;

  const ProfileHeaderCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: AppDecorations.card,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _MiniMetric(
            label: l10n.profile_gamesPlayed,
            value: '${state.gamesPlayed}',
          ),
          _MiniMetric(
            label: l10n.profile_winRate,
            value: '${state.winRate.toStringAsFixed(1)}%',
          ),
          _MiniMetric(
            label: l10n.profile_totalEarnings,
            value: _formatEarnings(state.totalEarnings),
            valueColor: state.totalEarnings >= 0
                ? AppColors.success
                : AppColors.error,
          ),
        ],
      ),
    );
  }

  String _formatEarnings(int amount) {
    final sign = amount >= 0 ? '+' : '-';
    return '$sign\$${amount.abs()}';
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MiniMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
