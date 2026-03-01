import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/board_entity.dart';
import 'cell_widget.dart';

class BoardWidget extends StatelessWidget {
  final BoardEntity board;
  final bool enabled;
  final int? lastMoveIndex;
  final List<int>? winningLine;
  final void Function(int row, int col) onCellTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.enabled,
    this.lastMoveIndex,
    this.winningLine,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.feltGreen.withValues(alpha: 0.3),
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: AppColors.chipGold.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final cell = board.cellAtIndex(index);
            return CellWidget(
              cell: cell,
              enabled: enabled,
              isLastMove: lastMoveIndex == index,
              isWinningCell: winningLine?.contains(index) ?? false,
              onTap: () => onCellTap(index ~/ 3, index % 3),
            );
          },
        ),
      ),
    );
  }
}
