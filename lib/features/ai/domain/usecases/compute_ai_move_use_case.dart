import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../../game/domain/entities/board_entity.dart';
import '../services/minimax_service.dart';

/// Computes the AI move based on difficulty level (0.0 to 1.0).
///
/// Uses noisy minimax: evaluates all moves via minimax, then adds random noise
/// proportional to (1 - aiLevel). Higher levels play near-optimally,
/// lower levels make realistic mistakes.
@injectable
class ComputeAiMoveUseCase {
  final MinimaxService _minimaxService;
  final Random _random;

  ComputeAiMoveUseCase(this._minimaxService, {@factoryParam Random? random})
      : _random = random ?? Random();

  /// Returns the cell index for the AI's move.
  int call(BoardEntity board, double aiLevel) {
    final movesWithScores = _minimaxService.getMovesWithScores(board);

    // Minimum noise even at level 1.0 to give the player a chance
    final noiseFactor = max(
      GameConstants.aiMinNoise,
      GameConstants.aiNoiseScale * (1.0 - aiLevel),
    );

    int bestMove = movesWithScores.first.move;
    double bestScore = double.negativeInfinity;

    for (final (:move, :score) in movesWithScores) {
      final noise = (_random.nextDouble() * 2 - 1) * noiseFactor;
      final noisedScore = score + noise;
      if (noisedScore > bestScore) {
        bestScore = noisedScore;
        bestMove = move;
      }
    }

    return bestMove;
  }
}
