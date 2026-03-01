import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_status.dart';
import '../../domain/entities/player_side.dart';

class GameResultDialog extends StatelessWidget {
  final GameEntity game;
  final AppLocalizations l10n;
  final VoidCallback onPlayAgain;

  const GameResultDialog({
    super.key,
    required this.game,
    required this.l10n,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final humanWon =
        (game.humanSide == PlayerSide.red &&
            game.status == GameStatus.redWins) ||
        (game.humanSide == PlayerSide.black &&
            game.status == GameStatus.blackWins);
    final isDraw = game.status == GameStatus.draw;

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
