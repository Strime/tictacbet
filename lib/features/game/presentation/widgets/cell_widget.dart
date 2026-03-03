import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/card_entity.dart';
import '../../domain/entities/cell_entity.dart';
import 'card_back_painter.dart';

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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        child: CustomPaint(
          painter: const CardBackPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }

  Widget _buildRevealedContent(BuildContext context) {
    final card = cell.card;
    if (card == null) return const SizedBox.shrink();

    final isHeart = card.suit == CardSuit.heart;
    final color = isHeart ? AppColors.heartRed : AppColors.spadeBlackLight;
    final icon = isHeart ? LucideIcons.heart : LucideIcons.spade;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconLg),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          card.rank.name.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
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
      CellBonus.coin => (LucideIcons.coins, AppColors.coinColor),
      CellBonus.clover => (LucideIcons.clover, AppColors.cloverColor),
      CellBonus.xp => (LucideIcons.sparkles, AppColors.xpColor),
    };

    return Icon(icon, color: color, size: AppSpacing.iconSm);
  }
}