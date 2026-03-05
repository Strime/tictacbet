import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/board_entity.dart';
import '../../domain/entities/player_side.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final BoardEntity board;
  final PlayerSide humanSide;
  final bool enabled;
  final int? lastMoveIndex;
  final List<int>? winningLine;
  final int? betAmount;
  final void Function(int row, int col) onCellTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.humanSide,
    required this.enabled,
    this.lastMoveIndex,
    this.winningLine,
    this.betAmount,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasBet = betAmount != null;

    return AspectRatio(
      aspectRatio:
          hasBet ? AppSpacing.boardAspectRatio : AppSpacing.cardAspectRatio,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: hasBet
            ? AppDecorations.pokerTable
            : BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.8),
                borderRadius: AppSpacing.borderRadiusLg,
                border: Border.all(
                  color: AppColors.chipGold.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
        child: Column(
          children: [
            if (hasBet) ...[
              const SizedBox(height: AppSpacing.xs),
              _PotLabel(betAmount: betAmount!),
              const SizedBox(height: AppSpacing.sm),
            ],
            Expanded(
              child: Center(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: AppSpacing.cardAspectRatio,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final cell = board.cellAtIndex(index);
                    return CellWidget(
                      cell: cell,
                      humanSide: humanSide,
                      enabled: enabled,
                      isLastMove: lastMoveIndex == index,
                      isWinningCell: winningLine?.contains(index) ?? false,
                      onTap: () => onCellTap(index ~/ 3, index % 3),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PotLabel extends StatelessWidget {
  final int betAmount;

  const _PotLabel({required this.betAmount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            LucideIcons.coins,
            color: AppColors.chipGold,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            l10n.game_pot(betAmount * 2),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.chipGold,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
