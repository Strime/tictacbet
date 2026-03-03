import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/ai/domain/services/minimax_service.dart';
import 'package:tictacbet/features/ai/domain/usecases/compute_ai_move_use_case.dart';
import 'package:tictacbet/features/game/domain/entities/card_entity.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';

import '../../../../helpers/board_builder.dart';

void main() {
  late MinimaxService minimaxService;

  setUp(() {
    minimaxService = MinimaxService();
  });

  group('ComputeAiMoveUseCase - noisy minimax', () {
    test('level 1.0 wins or draws >95% against random (100 games)', () {
      int aiWinsOrDraws = 0;
      const totalGames = 100;

      for (int game = 0; game < totalGames; game++) {
        final rng = Random(game);
        final useCase = ComputeAiMoveUseCase(minimaxService, random: rng);
        var board = buildBoard('.........');

        while (!board.isGameOver) {
          final int move;
          if (board.currentPlayer == PlayerSide.red) {
            // Random opponent
            final moves = board.availableMoves;
            move = moves[rng.nextInt(moves.length)];
          } else {
            // AI at level 1.0
            move = useCase(board, 1.0);
          }

          final row = move ~/ 3;
          final col = move % 3;
          final card = CardEntity(
            suit: board.currentPlayer.suit,
            rank: CardRank.ace,
          );
          board = board.makeMove(row, col, card);
        }

        if (board.status != GameStatus.redWins) {
          aiWinsOrDraws++;
        }
      }

      expect(
        aiWinsOrDraws,
        greaterThan(totalGames * 0.95),
        reason:
            'AI at level 1.0 should win or draw >95% of games ($aiWinsOrDraws/$totalGames)',
      );
    });

    test('level 1.0 noise causes move variation on close-scored positions', () {
      // After one move, many responses score similarly — noise should vary
      // the pick across different RNG seeds.
      final board = buildBoard(
        'R........',
        currentPlayer: PlayerSide.black,
      );

      final chosenMoves = <int>{};
      for (int i = 0; i < 50; i++) {
        final useCase =
            ComputeAiMoveUseCase(minimaxService, random: Random(i));
        chosenMoves.add(useCase(board, 1.0));
      }

      // Residual noise (aiMinNoise = 3.0) should cause at least 2 different
      // moves to be selected, proving noise is effective at level 1.0.
      expect(
        chosenMoves.length,
        greaterThan(1),
        reason:
            'At level 1.0, residual noise should cause move variation '
            'across seeds (got ${chosenMoves.length} distinct moves)',
      );
    });

    test('level 0.0 always returns a valid move', () {
      for (int i = 0; i < 50; i++) {
        final useCase =
            ComputeAiMoveUseCase(minimaxService, random: Random(i));
        final board = buildBoard('RB.R.B...');

        final move = useCase(board, 0.0);
        expect(
          board.availableMoves,
          contains(move),
          reason: 'Move $move must be a valid cell (trial $i)',
        );
      }
    });

    test('intermediate level plays better than random', () {
      // At level 0.5, AI should win more than pure random would (~30%)
      int aiWins = 0;
      const totalGames = 200;

      for (int game = 0; game < totalGames; game++) {
        final rng = Random(game);
        final useCase = ComputeAiMoveUseCase(minimaxService, random: rng);
        var board = buildBoard('.........');

        while (!board.isGameOver) {
          final int move;
          if (board.currentPlayer == PlayerSide.red) {
            final moves = board.availableMoves;
            move = moves[rng.nextInt(moves.length)];
          } else {
            move = useCase(board, 0.5);
          }

          final row = move ~/ 3;
          final col = move % 3;
          final card = CardEntity(
            suit: board.currentPlayer.suit,
            rank: CardRank.ace,
          );
          board = board.makeMove(row, col, card);
        }

        if (board.status == GameStatus.blackWins) {
          aiWins++;
        }
      }

      // Random vs random: second player wins ~30%. AI at 0.5 should do better.
      expect(
        aiWins,
        greaterThan(totalGames * 0.4),
        reason:
            'AI at level 0.5 should win >40% against random ($aiWins/$totalGames)',
      );
    });

    test('returned move is always a valid (empty) cell at any level', () {
      final levels = [0.0, 0.3, 0.5, 0.7, 1.0];

      for (final level in levels) {
        for (int i = 0; i < 20; i++) {
          final useCase =
              ComputeAiMoveUseCase(minimaxService, random: Random(i));
          final board = buildBoard('RB.R.B...');

          final move = useCase(board, level);
          expect(
            board.availableMoves,
            contains(move),
            reason: 'Move $move invalid at level $level (trial $i)',
          );
        }
      }
    });
  });
}
