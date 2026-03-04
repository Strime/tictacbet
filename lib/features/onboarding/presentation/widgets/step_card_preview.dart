import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../game/domain/entities/board_entity.dart';
import '../../../game/domain/entities/card_entity.dart';
import '../../../game/domain/entities/cell_entity.dart';
import '../../../game/presentation/widgets/board_widget.dart';
import '../../../game/presentation/widgets/cell_widget.dart';

class StepCardPreview extends StatefulWidget {
  final VoidCallback onStepCompleted;

  const StepCardPreview({
    super.key,
    required this.onStepCompleted,
  });

  @override
  State<StepCardPreview> createState() => _StepCardPreviewState();
}

class _StepCardPreviewState extends State<StepCardPreview> {
  static const Duration _staggerDelay = Duration(milliseconds: 200);

  static const _bonusEntries = [
    (CellBonus.coin, LucideIcons.coins, AppColors.coinColor),
    (CellBonus.clover, LucideIcons.clover, AppColors.cloverColor),
    (CellBonus.xp, LucideIcons.sparkles, AppColors.xpColor),
  ];

  static List<(CellBonus, IconData, Color, String, String)> _bonusDescriptions(
      AppLocalizations l10n) => [
    (_bonusEntries[0].$1, _bonusEntries[0].$2, _bonusEntries[0].$3, l10n.onboarding_bonusCoin, l10n.onboarding_bonusCoin_desc),
    (_bonusEntries[1].$1, _bonusEntries[1].$2, _bonusEntries[1].$3, l10n.onboarding_bonusLuck, l10n.onboarding_bonusLuck_desc),
    (_bonusEntries[2].$1, _bonusEntries[2].$2, _bonusEntries[2].$3, l10n.onboarding_bonusXp, l10n.onboarding_bonusXp_desc),
  ];

  late BoardEntity _board;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _board = BoardEntity.generate(random: Random(42));
  }

  void _onCellTap(int row, int col) {
    if (_completed) return;

    final index = row * 3 + col;
    final cell = _board.cellAtIndex(index);
    if (cell.isNotEmpty) return;

    const card = CardEntity(suit: CardSuit.heart, rank: CardRank.king);
    setState(() {
      _board = _board.makeMove(row, col, card);
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: AppSpacing.animationSlow),
      child: _completed ? _buildBonusCards(context) : _buildBoard(),
    );
  }

  Widget _buildBoard() {
    return Center(
      key: const ValueKey('board'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: SizedBox(
          width: double.infinity,
          child: BoardWidget(
            board: _board,
            enabled: !_completed,
            onCellTap: _onCellTap,
          ),
        ),
      ),
    );
  }

  Widget _buildBonusCards(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bonuses = _bonusDescriptions(l10n);

    return Column(
      key: const ValueKey('bonus_cards'),
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < bonuses.length; i++)
                    _BonusCardRow(
                          bonus: bonuses[i].$1,
                          icon: bonuses[i].$2,
                          color: bonuses[i].$3,
                          label: bonuses[i].$4,
                          description: bonuses[i].$5,
                          cardSize: AppSpacing.boardCellSize,
                        )
                        .animate()
                        .fadeIn(
                          delay: _staggerDelay * i,
                          duration: const Duration(
                            milliseconds: AppSpacing.animationMedium,
                          ),
                        )
                        .slideX(
                          begin: 0.15,
                          end: 0,
                          delay: _staggerDelay * i,
                          duration: const Duration(
                            milliseconds: AppSpacing.animationMedium,
                          ),
                          curve: Curves.easeOut,
                        ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: ElevatedButton(
                onPressed: widget.onStepCompleted,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.feltGreen,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                  shape: const StadiumBorder(),
                  elevation: AppSpacing.elevationMedium,
                ),
                child: Text(
                  l10n.onboarding_gotIt,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
              .animate()
              .fadeIn(
                delay: _staggerDelay * bonuses.length,
                duration: const Duration(
                  milliseconds: AppSpacing.animationMedium,
                ),
              )
              .slideY(
                begin: 0.2,
                end: 0,
                delay: _staggerDelay * bonuses.length,
                duration: const Duration(
                  milliseconds: AppSpacing.animationMedium,
                ),
                curve: Curves.easeOut,
              ),
        ),
      ],
    );
  }
}

class _BonusCardRow extends StatelessWidget {
  final CellBonus bonus;
  final IconData icon;
  final Color color;
  final String label;
  final String description;
  final double cardSize;

  const _BonusCardRow({
    required this.bonus,
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    required this.cardSize,
  });

  @override
  Widget build(BuildContext context) {
    final cell = CellEntity(
      row: 0,
      col: 0,
      bonus: bonus,
      card: const CardEntity(suit: CardSuit.heart, rank: CardRank.king),
      revealed: true,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          SizedBox(
            width: cardSize,
            height: cardSize / AppSpacing.cardAspectRatio,
            child: CellWidget(cell: cell, enabled: false),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: AppSpacing.iconSm),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
