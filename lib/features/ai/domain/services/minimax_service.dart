import 'package:injectable/injectable.dart';

import '../../../game/domain/entities/board_entity.dart';
import '../../../game/domain/entities/card_entity.dart';

import '../../../game/domain/entities/game_status.dart';

/// Minimax with alpha-beta pruning for the AI.
/// Since cards are cosmetic, the AI reasons about cell ownership (suit),
/// not card rank. A dummy card is used for simulation.
@lazySingleton
class MinimaxService {
  /// Returns the index of the best move for the current player.
  int getBestMove(BoardEntity board) {
    int bestScore = -1000;
    int bestMove = board.availableMoves.first;

    for (final move in board.availableMoves) {
      final newBoard = _simulateMove(board, move);
      final score = _minimax(
        newBoard,
        depth: 0,
        isMaximizing: false,
        alpha: -1000,
        beta: 1000,
        aiSuit: board.currentPlayer.suit,
      );
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  int _minimax(
    BoardEntity board, {
    required int depth,
    required bool isMaximizing,
    required int alpha,
    required int beta,
    required CardSuit aiSuit,
  }) {
    final status = board.status;

    if (status == GameStatus.redWins) {
      return aiSuit == CardSuit.heart ? 10 - depth : depth - 10;
    }
    if (status == GameStatus.blackWins) {
      return aiSuit == CardSuit.spade ? 10 - depth : depth - 10;
    }
    if (status == GameStatus.draw) return 0;

    int currentAlpha = alpha;
    int currentBeta = beta;

    if (isMaximizing) {
      int best = -1000;
      for (final move in board.availableMoves) {
        final score = _minimax(
          _simulateMove(board, move),
          depth: depth + 1,
          isMaximizing: false,
          alpha: currentAlpha,
          beta: currentBeta,
          aiSuit: aiSuit,
        );
        best = best > score ? best : score;
        currentAlpha = currentAlpha > best ? currentAlpha : best;
        if (currentBeta <= currentAlpha) break;
      }
      return best;
    } else {
      int best = 1000;
      for (final move in board.availableMoves) {
        final score = _minimax(
          _simulateMove(board, move),
          depth: depth + 1,
          isMaximizing: true,
          alpha: currentAlpha,
          beta: currentBeta,
          aiSuit: aiSuit,
        );
        best = best < score ? best : score;
        currentBeta = currentBeta < best ? currentBeta : best;
        if (currentBeta <= currentAlpha) break;
      }
      return best;
    }
  }

  /// Returns minimax scores for all available moves.
  List<({int move, int score})> getMovesWithScores(BoardEntity board) {
    final aiSuit = board.currentPlayer.suit;
    return [
      for (final move in board.availableMoves)
        (
          move: move,
          score: _minimax(
            _simulateMove(board, move),
            depth: 0,
            isMaximizing: false,
            alpha: -1000,
            beta: 1000,
            aiSuit: aiSuit,
          ),
        ),
    ];
  }

  /// Simulates a move with a dummy card (rank irrelevant for win logic).
  BoardEntity _simulateMove(BoardEntity board, int index) {
    final row = index ~/ 3;
    final col = index % 3;
    final dummyCard = CardEntity(
      suit: board.currentPlayer.suit,
      rank: CardRank.ace,
    );
    return board.makeMove(row, col, dummyCard);
  }
}
