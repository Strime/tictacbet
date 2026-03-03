import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';

GameResultEntity _make({
  GameStatus result = GameStatus.draw,
  PlayerSide humanSide = PlayerSide.red,
  int betAmount = 10,
  int winnings = 0,
  bool isCashOut = false,
}) =>
    GameResultEntity(
      result: result,
      humanSide: humanSide,
      aiLevel: 0.5,
      betAmount: betAmount,
      winnings: winnings,
      playedAt: DateTime(2026, 3, 1),
      duration: const Duration(minutes: 2),
      moveCount: 7,
      isCashOut: isCashOut,
    );

void main() {
  group('GameResultEntity', () {
    group('isWin', () {
      test('returns true when red human wins as red', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.redWins,
        );

        expect(entity.isWin, isTrue);
      });

      test('returns true when black human wins as black', () {
        final entity = _make(
          humanSide: PlayerSide.black,
          result: GameStatus.blackWins,
        );

        expect(entity.isWin, isTrue);
      });

      test('returns false on draw', () {
        final entity = _make(result: GameStatus.draw);

        expect(entity.isWin, isFalse);
      });

      test('returns false when red human loses (black wins)', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.blackWins,
        );

        expect(entity.isWin, isFalse);
      });
    });

    group('isDraw', () {
      test('returns true on draw', () {
        final entity = _make(result: GameStatus.draw);

        expect(entity.isDraw, isTrue);
      });

      test('returns false on win', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.redWins,
        );

        expect(entity.isDraw, isFalse);
      });
    });

    group('isLoss', () {
      test('returns true when human loses', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.blackWins,
        );

        expect(entity.isLoss, isTrue);
      });

      test('returns false on win', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.redWins,
        );

        expect(entity.isLoss, isFalse);
      });

      test('returns false on draw', () {
        final entity = _make(result: GameStatus.draw);

        expect(entity.isLoss, isFalse);
      });
    });

    group('isCashOut', () {
      test('cash out is not a loss', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.blackWins,
          isCashOut: true,
        );

        expect(entity.isLoss, isFalse);
        expect(entity.isWin, isFalse);
        expect(entity.isDraw, isFalse);
      });

      test('netAmount is winnings - betAmount on cash out', () {
        final entity = _make(
          isCashOut: true,
          betAmount: 20,
          winnings: 15,
        );

        expect(entity.netAmount, equals(-5));
      });
    });

    group('netAmount', () {
      test('returns positive net on win (winnings - bet)', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.redWins,
          betAmount: 10,
          winnings: 25,
        );

        expect(entity.netAmount, equals(15));
      });

      test('returns 0 on draw (winnings == bet)', () {
        final entity = _make(
          result: GameStatus.draw,
          betAmount: 10,
          winnings: 10,
        );

        expect(entity.netAmount, equals(0));
      });

      test('returns negative bet on loss', () {
        final entity = _make(
          humanSide: PlayerSide.red,
          result: GameStatus.blackWins,
          betAmount: 10,
          winnings: 0,
        );

        expect(entity.netAmount, equals(-10));
      });
    });
  });
}
