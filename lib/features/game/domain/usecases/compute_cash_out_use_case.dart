import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../../ai/domain/services/minimax_service.dart';
import '../entities/board_entity.dart';

/// Computes the cash out amount based on the current board position.
///
/// Uses minimax evaluation to assess the human player's position,
/// then maps the score to a payout multiplier.
@injectable
class ComputeCashOutUseCase {
  final MinimaxService _minimaxService;

  ComputeCashOutUseCase(this._minimaxService);

  /// Returns the cash out amount for the given board and bet.
  ///
  /// The amount ranges from `betAmount * 0.1` (losing badly)
  /// to `betAmount * 1.8` (winning position), with a floor of 1.
  int call(BoardEntity board, int betAmount) {
    final movesWithScores = _minimaxService.getMovesWithScores(board);
    if (movesWithScores.isEmpty) return betAmount;

    final bestScore =
        movesWithScores.map((e) => e.score).reduce(max);

    // Normalize from [-10, +10] to [0, 1]
    final normalizedScore = (bestScore + 10) / 20.0;

    // Map to multiplier range
    final multiplier = GameConstants.cashOutMinMultiplier +
        normalizedScore *
            (GameConstants.cashOutMaxMultiplier -
                GameConstants.cashOutMinMultiplier);

    return max(1, (betAmount * multiplier).round());
  }
}
