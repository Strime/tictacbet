import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../core/config/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/cell_entity.dart';
import '../../domain/entities/player_side.dart';
import '../extensions/card_suit_ui.dart';
import '../extensions/cell_bonus_ui.dart';
import 'card_back_painter.dart';

class CellWidget extends StatefulWidget {
  final CellEntity cell;
  final PlayerSide humanSide;
  final bool enabled;
  final bool isLastMove;
  final bool isWinningCell;
  final VoidCallback? onTap;

  const CellWidget({
    super.key,
    required this.cell,
    required this.humanSide,
    this.enabled = true,
    this.isLastMove = false,
    this.isWinningCell = false,
    this.onTap,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppSpacing.animationMedium),
    );
    // If already revealed on first build, show front immediately.
    if (widget.cell.revealed) {
      _showFront = true;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.cell.revealed && widget.cell.revealed) {
      _controller.forward().then((_) {
        // Ensure we stay on front after animation completes.
        setState(() => _showFront = true);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled && widget.cell.isEmpty ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final value = _controller.value;
          // First half: rotate back face from 0° to 90°
          // Second half: rotate front face from -90° to 0°
          final isBack = value <= 0.5;
          final angle = isBack
              ? value *
                    math
                        .pi // 0 → π/2
              : (1 - value) * math.pi; // π/2 → 0 (but mirrored)

          // Switch content and decoration at the halfway point.
          final showFront = _showFront || value > 0.5;
          final decoration = showFront
              ? _revealedDecoration()
              : AppDecorations.cellHidden;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002)
              ..rotateY(angle),
            child: Container(
              decoration: decoration,
              child: showFront
                  ? _buildRevealedContent(context)
                  : _buildHiddenContent(),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _revealedDecoration() {
    Color borderColor = Colors.transparent;
    if (widget.isWinningCell) {
      borderColor = AppColors.chipGold;
    } else if (widget.isLastMove) {
      borderColor = AppColors.feltGreenLight;
    }

    return BoxDecoration(
      color: AppColors.cardFace,
      borderRadius: AppSpacing.borderRadiusSm,
      border: Border.all(
        color: borderColor,
        width: widget.isWinningCell ? 3 : (widget.isLastMove ? 2 : 0),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      child: CustomPaint(painter: const CardBackPainter(), size: Size.infinite),
    );
  }

  Widget _buildRevealedContent(BuildContext context) {
    final card = widget.cell.card;
    if (card == null) return const SizedBox.shrink();

    final color = card.suit.color;
    final suitChar = card.suit.symbol;
    final label = card.rank.displayLabel;

    final smallSuit = Text(
      suitChar,
      style: TextStyle(color: color, fontSize: AppSpacing.iconXs, height: 1),
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top-left: rank above suit
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RankLabel(label: label, color: color),
              const SizedBox(height: AppSpacing.xs),
              smallSuit,
            ],
          ),
          // Center: bonus only (hidden on opponent cards)
          Expanded(
            child: Center(
              child:
                  widget.cell.bonus != null &&
                      card.suit == widget.humanSide.suit
                  ? _BonusBadge(bonus: widget.cell.bonus!)
                  : const SizedBox.shrink(),
            ),
          ),
          // Bottom-right: suit above rank (rotated 180°)
          Align(
            alignment: Alignment.centerRight,
            child: Transform.rotate(
              angle: math.pi,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RankLabel(label: label, color: color),
                  const SizedBox(height: AppSpacing.xs),
                  smallSuit,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _RankLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}

class _BonusBadge extends StatelessWidget {
  final CellBonus bonus;

  const _BonusBadge({required this.bonus});

  @override
  Widget build(BuildContext context) {
    final label = switch (bonus) {
      CellBonus.coin => '+${GameConstants.coinBonusValue}\$',
      CellBonus.xp => '+${GameConstants.xpPerBonusCell}',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(bonus.icon, color: bonus.colorDark, size: AppSpacing.iconLg),
        Text(
          label,
          style: TextStyle(
            color: bonus.colorDark,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
