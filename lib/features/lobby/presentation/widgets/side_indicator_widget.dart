import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../game/domain/entities/player_side.dart';
import '../../../game/presentation/extensions/player_side_ui.dart';

class SideIndicatorWidget extends StatelessWidget {
  final PlayerSide side;

  const SideIndicatorWidget({super.key, required this.side});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            side.color.withValues(alpha: 0.2),
            side.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: side.color.withValues(alpha: 0.4),
          width: AppSpacing.thinBorderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(side.icon, size: AppSpacing.iconLg, color: side.color),
          const SizedBox(width: AppSpacing.md),
          Text(
            l10n.lobby_playingAs(
              side == PlayerSide.red ? l10n.lobby_red : l10n.lobby_black,
            ),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
