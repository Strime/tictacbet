import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/ai/domain/services/minimax_service.dart';
import 'package:tictacbet/features/game/domain/entities/card_entity.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';

import '../../../../helpers/board_builder.dart';

void main() {
  late MinimaxService minimax;

  setUp(() {
    minimax = MinimaxService();
  });

  group('MinimaxService', () {
    test('never loses against random moves (100 games)', () {
      final rng = Random(42);

      for (int game = 0; game < 100; game++) {
        var board = buildBoard('.........');

        while (!board.isGameOver) {
          final int move;
          if (board.currentPlayer == PlayerSide.red) {
            // Random player (Red)
            final moves = board.availableMoves;
            move = moves[rng.nextInt(moves.length)];
          } else {
            // Minimax player (Black)
            move = minimax.getBestMove(board);
          }

          final row = move ~/ 3;
          final col = move % 3;
          final card = CardEntity(
            suit: board.currentPlayer.suit,
            rank: CardRank.ace,
          );
          board = board.makeMove(row, col, card);
        }

        expect(
          board.status,
          isNot(GameStatus.redWins),
          reason: 'Minimax (Black) should never lose (game #$game)',
        );
      }
    });

    test('minimax vs minimax always draws (10 games)', () {
      for (int game = 0; game < 10; game++) {
        var board = buildBoard('.........');

        while (!board.isGameOver) {
          final move = minimax.getBestMove(board);
          final row = move ~/ 3;
          final col = move % 3;
          final card = CardEntity(
            suit: board.currentPlayer.suit,
            rank: CardRank.ace,
          );
          board = board.makeMove(row, col, card);
        }

        expect(
          board.status,
          GameStatus.draw,
          reason: 'Minimax vs minimax must always draw (game #$game)',
        );
      }
    });

    test('blocks an imminent opponent win', () {
      // R R . / B . . / . . .
      // Black must block at index 2
      final board = buildBoard(
        'RR.B.....',
        currentPlayer: PlayerSide.black,
      );

      final move = minimax.getBestMove(board);
      expect(move, 2, reason: 'Must block Red from winning top row');
    });

    test('takes the win when available', () {
      // R . .
      // B B .  ← Black can win at index 5
      // R . .
      final board = buildBoard(
        'R..BB.R..',
        currentPlayer: PlayerSide.black,
      );

      final move = minimax.getBestMove(board);
      expect(move, 5, reason: 'Must complete middle row for the win');
    });

    test('getMovesWithScores returns a score for each available move', () {
      final board = buildBoard('R.B......');
      final scores = minimax.getMovesWithScores(board);

      // Board has 7 empty cells → 7 scored moves
      expect(scores.length, 7);

      // All returned moves should be valid
      final validMoves = board.availableMoves;
      for (final (:move, score: _) in scores) {
        expect(validMoves, contains(move));
      }
    });

    test('getMovesWithScores best score matches getBestMove', () {
      final board = buildBoard(
        'RR.B.....',
        currentPlayer: PlayerSide.black,
      );

      final bestMove = minimax.getBestMove(board);
      final scores = minimax.getMovesWithScores(board);

      // Find the move with the highest score
      var topMove = scores.first.move;
      var topScore = scores.first.score;
      for (final (:move, :score) in scores) {
        if (score > topScore) {
          topScore = score;
          topMove = move;
        }
      }

      expect(topMove, bestMove,
          reason: 'Best scored move should match getBestMove result');
    });
  });
}
