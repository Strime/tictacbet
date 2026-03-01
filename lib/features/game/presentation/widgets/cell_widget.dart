import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/cell_entity.dart';

class CellWidget extends StatelessWidget {
  final CellEntity cell;
  final bool enabled;
  final bool isLastMove;
  final bool isWinningCell;
  final VoidCallback? onTap;

  const CellWidget({
    super.key,
    required this.cell,
    this.enabled = true,
    this.isLastMove = false,
    this.isWinningCell = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && cell.isEmpty ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppSpacing.animationMedium),
        decoration: cell.revealed
            ? _revealedDecoration()
            : AppDecorations.cellHidden,
        child: cell.revealed ? _buildRevealedContent(context) : _buildHiddenContent(),
      ),
    );
  }

  BoxDecoration _revealedDecoration() {
    Color borderColor = Colors.transparent;
    if (isWinningCell) {
      borderColor = AppColors.chipGold;
    } else if (isLastMove) {
      borderColor = AppColors.feltGreenLight;
    }

    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppSpacing.borderRadiusSm,
      border: Border.all(
        color: borderColor,
        width: isWinningCell ? 3 : (isLastMove ? 2 : 0),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Center(
      child: Container(
        width: AppSpacing.xxxl,
        height: AppSpacing.xxxl,
        decoration: BoxDecoration(
          color: AppColors.feltGreenDark,
          borderRadius: AppSpacing.borderRadiusSm,
          border: Border.all(
            color: AppColors.chipGold.withValues(alpha: 0.3),
          ),
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(
              color: AppColors.chipGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevealedContent(BuildContext context) {
    final card = cell.card;
    if (card == null) return const SizedBox.shrink();

    final isHeart = card.suit == CardSuit.heart;
    final color = isHeart ? AppColors.heartRed : AppColors.spadeBlackLight;
    final icon = isHeart ? Icons.favorite : Icons.spa;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconLg),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          card.rank.name.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (cell.bonus != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          _BonusBadge(bonus: cell.bonus!),
        ],
      ],
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }
}

class _BonusBadge extends StatelessWidget {
  final CellBonus bonus;

  const _BonusBadge({required this.bonus});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (bonus) {
      CellBonus.coin => (Icons.monetization_on, AppColors.coinColor),
      CellBonus.clover => (Icons.eco, AppColors.cloverColor),
      CellBonus.xp => (Icons.star, AppColors.xpColor),
    };

    return Icon(icon, color: color, size: AppSpacing.iconSm);
  }
}
