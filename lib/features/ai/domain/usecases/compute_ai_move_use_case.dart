import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../game/domain/entities/board_entity.dart';
import '../services/minimax_service.dart';

/// Computes the AI move based on difficulty level (0.0 to 1.0).
@injectable
class ComputeAiMoveUseCase {
  final MinimaxService _minimaxService;
  final Random _random;

  ComputeAiMoveUseCase(this._minimaxService, {@factoryParam Random? random})
      : _random = random ?? Random();

  /// Returns the cell index for the AI's move.
  int call(BoardEntity board, double aiLevel) {
    if (aiLevel >= 1.0) {
      return _minimaxService.getBestMoveWithBonusAwareness(board);
    }

    // Probability of making the optimal move
    if (_random.nextDouble() < aiLevel) {
      return _minimaxService.getBestMove(board);
    }

    // Random move
    final moves = board.availableMoves;
    return moves[_random.nextInt(moves.length)];
  }
}
