import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';
import 'package:tictacbet/features/profile/domain/entities/achievement.dart';
import 'package:tictacbet/features/profile/domain/services/achievement_detector.dart';

GameResultEntity _makeResult({
  bool isWin = false,
  bool isDraw = false,
  bool isCashOut = false,
  bool isAllIn = false,
  Duration duration = const Duration(minutes: 2),
  int betAmount = 10,
  int winnings = 0,
  PlayerSide humanSide = PlayerSide.red,
}) {
  final GameStatus result;
  if (isWin) {
    result = humanSide == PlayerSide.red
        ? GameStatus.redWins
        : GameStatus.blackWins;
  } else if (isDraw) {
    result = GameStatus.draw;
  } else {
    result = humanSide == PlayerSide.red
        ? GameStatus.blackWins
        : GameStatus.redWins;
  }

  return GameResultEntity(
    result: result,
    humanSide: humanSide,
    aiLevel: 0.5,
    betAmount: betAmount,
    winnings: winnings,
    playedAt: DateTime(2026, 3, 1),
    duration: duration,
    moveCount: 5,
    isCashOut: isCashOut,
    isAllIn: isAllIn,
  );
}

void main() {
  group('detectAchievements', () {
    test('returns all false for empty results', () {
      final achievements = detectAchievements([]);
      expect(achievements.values.every((v) => !v), isTrue);
    });

    group('Speed Run', () {
      test('true when win with duration < 30s', () {
        final results = [
          _makeResult(
            isWin: true,
            duration: const Duration(seconds: 25),
            winnings: 20,
          ),
        ];
        expect(
          detectAchievements(results)[AchievementType.speedRun],
          isTrue,
        );
      });

      test('false when loss with duration < 30s', () {
        final results = [
          _makeResult(duration: const Duration(seconds: 25)),
        ];
        expect(
          detectAchievements(results)[AchievementType.speedRun],
          isFalse,
        );
      });

      test('false when win with duration >= 30s', () {
        final results = [
          _makeResult(
            isWin: true,
            duration: const Duration(seconds: 30),
            winnings: 20,
          ),
        ];
        expect(
          detectAchievements(results)[AchievementType.speedRun],
          isFalse,
        );
      });
    });

    group('High Roller', () {
      test('true when sum of positive net >= 100', () {
        final results = [
          _makeResult(isWin: true, betAmount: 10, winnings: 60),
          _makeResult(isWin: true, betAmount: 10, winnings: 60),
        ];
        // netAmount = 60-10 = 50 each, total = 100
        expect(
          detectAchievements(results)[AchievementType.highRoller],
          isTrue,
        );
      });

      test('false when sum of positive net < 100', () {
        final results = [
          _makeResult(isWin: true, betAmount: 10, winnings: 50),
        ];
        // netAmount = 40
        expect(
          detectAchievements(results)[AchievementType.highRoller],
          isFalse,
        );
      });

      test('ignores negative net amounts', () {
        final results = [
          _makeResult(isWin: true, betAmount: 10, winnings: 60),
          _makeResult(betAmount: 50, winnings: 0), // loss: -50
          _makeResult(isWin: true, betAmount: 10, winnings: 60),
        ];
        // positive nets: 50 + 50 = 100, losses ignored
        expect(
          detectAchievements(results)[AchievementType.highRoller],
          isTrue,
        );
      });
    });

    group('Hat Trick', () {
      test('true with 3 consecutive wins', () {
        final results = [
          _makeResult(isWin: true, winnings: 20),
          _makeResult(isWin: true, winnings: 20),
          _makeResult(isWin: true, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.hatTrick],
          isTrue,
        );
      });

      test('false with 2 wins then loss then win', () {
        final results = [
          _makeResult(isWin: true, winnings: 20),
          _makeResult(isWin: true, winnings: 20),
          _makeResult(), // loss
          _makeResult(isWin: true, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.hatTrick],
          isFalse,
        );
      });

      test('true when 3 consecutive wins are not at the start', () {
        final results = [
          _makeResult(), // loss
          _makeResult(isWin: true, winnings: 20),
          _makeResult(isWin: true, winnings: 20),
          _makeResult(isWin: true, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.hatTrick],
          isTrue,
        );
      });
    });

    group('Whale', () {
      test('true when win with betAmount >= 50', () {
        final results = [
          _makeResult(isWin: true, betAmount: 50, winnings: 100),
        ];
        expect(
          detectAchievements(results)[AchievementType.whale],
          isTrue,
        );
      });

      test('false when loss with betAmount >= 50', () {
        final results = [
          _makeResult(betAmount: 50),
        ];
        expect(
          detectAchievements(results)[AchievementType.whale],
          isFalse,
        );
      });

      test('false when win with betAmount < 50', () {
        final results = [
          _makeResult(isWin: true, betAmount: 49, winnings: 80),
        ];
        expect(
          detectAchievements(results)[AchievementType.whale],
          isFalse,
        );
      });
    });

    group('Golden Parachute', () {
      test('true when cash out with winnings > betAmount', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 15),
        ];
        expect(
          detectAchievements(results)[AchievementType.goldenParachute],
          isTrue,
        );
      });

      test('false when cash out with winnings == betAmount', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 10),
        ];
        expect(
          detectAchievements(results)[AchievementType.goldenParachute],
          isFalse,
        );
      });

      test('false when cash out with winnings < betAmount', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
        ];
        expect(
          detectAchievements(results)[AchievementType.goldenParachute],
          isFalse,
        );
      });

      test('false when profit but not a cash out', () {
        final results = [
          _makeResult(isWin: true, betAmount: 10, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.goldenParachute],
          isFalse,
        );
      });
    });

    group('Paper Hands', () {
      test('true when cashed out 3 times', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
          _makeResult(isCashOut: true, betAmount: 10, winnings: 15),
          _makeResult(isCashOut: true, betAmount: 20, winnings: 10),
        ];
        expect(
          detectAchievements(results)[AchievementType.paperHands],
          isTrue,
        );
      });

      test('false when cashed out only 2 times', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
          _makeResult(isCashOut: true, betAmount: 10, winnings: 15),
          _makeResult(isWin: true, betAmount: 10, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.paperHands],
          isFalse,
        );
      });

      test('true when more than 3 cash outs', () {
        final results = [
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
          _makeResult(isCashOut: true, betAmount: 10, winnings: 5),
        ];
        expect(
          detectAchievements(results)[AchievementType.paperHands],
          isTrue,
        );
      });

      test('false when no cash outs', () {
        final results = [
          _makeResult(isWin: true, betAmount: 10, winnings: 20),
          _makeResult(betAmount: 10),
        ];
        expect(
          detectAchievements(results)[AchievementType.paperHands],
          isFalse,
        );
      });
    });

    group('Double Agent', () {
      test('true when won as both red and black', () {
        final results = [
          _makeResult(isWin: true, humanSide: PlayerSide.red, winnings: 20),
          _makeResult(isWin: true, humanSide: PlayerSide.black, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.doubleAgent],
          isTrue,
        );
      });

      test('false when only won as red', () {
        final results = [
          _makeResult(isWin: true, humanSide: PlayerSide.red, winnings: 20),
          _makeResult(humanSide: PlayerSide.black),
        ];
        expect(
          detectAchievements(results)[AchievementType.doubleAgent],
          isFalse,
        );
      });

      test('false when no wins at all', () {
        final results = [_makeResult()];
        expect(
          detectAchievements(results)[AchievementType.doubleAgent],
          isFalse,
        );
      });
    });

    group('Red Master', () {
      test('true when 5 wins as red', () {
        final results = List.generate(
          5,
          (_) => _makeResult(isWin: true, humanSide: PlayerSide.red, winnings: 20),
        );
        expect(
          detectAchievements(results)[AchievementType.redMaster],
          isTrue,
        );
      });

      test('false when only 4 wins as red', () {
        final results = List.generate(
          4,
          (_) => _makeResult(isWin: true, humanSide: PlayerSide.red, winnings: 20),
        );
        expect(
          detectAchievements(results)[AchievementType.redMaster],
          isFalse,
        );
      });

      test('does not count black wins', () {
        final results = [
          ...List.generate(4, (_) => _makeResult(isWin: true, humanSide: PlayerSide.red, winnings: 20)),
          _makeResult(isWin: true, humanSide: PlayerSide.black, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.redMaster],
          isFalse,
        );
      });
    });

    group('Black Master', () {
      test('true when 5 wins as black', () {
        final results = List.generate(
          5,
          (_) => _makeResult(isWin: true, humanSide: PlayerSide.black, winnings: 20),
        );
        expect(
          detectAchievements(results)[AchievementType.blackMaster],
          isTrue,
        );
      });

      test('false when only 4 wins as black', () {
        final results = List.generate(
          4,
          (_) => _makeResult(isWin: true, humanSide: PlayerSide.black, winnings: 20),
        );
        expect(
          detectAchievements(results)[AchievementType.blackMaster],
          isFalse,
        );
      });
    });

    group('All In', () {
      test('true when win with isAllIn', () {
        final results = [
          _makeResult(isWin: true, isAllIn: true, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.allIn],
          isTrue,
        );
      });

      test('false when loss with isAllIn', () {
        final results = [
          _makeResult(isAllIn: true),
        ];
        expect(
          detectAchievements(results)[AchievementType.allIn],
          isFalse,
        );
      });

      test('false when win without isAllIn', () {
        final results = [
          _makeResult(isWin: true, winnings: 20),
        ];
        expect(
          detectAchievements(results)[AchievementType.allIn],
          isFalse,
        );
      });
    });
  });
}
