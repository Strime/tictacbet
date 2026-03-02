import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';
import 'package:tictacbet/features/profile/domain/entities/achievement.dart';
import 'package:tictacbet/features/profile/domain/services/achievement_detector.dart';

GameResultEntity _makeResult({
  bool isWin = false,
  bool isDraw = false,
  Duration duration = const Duration(minutes: 2),
  int betAmount = 10,
  int winnings = 0,
}) {
  final humanSide = PlayerSide.red;
  final GameStatus result;
  if (isWin) {
    result = GameStatus.redWins;
  } else if (isDraw) {
    result = GameStatus.draw;
  } else {
    result = GameStatus.blackWins;
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

    test('non-detectable achievements are always false', () {
      final results = [
        _makeResult(isWin: true, betAmount: 50, winnings: 200),
        _makeResult(isWin: true, winnings: 20),
        _makeResult(isWin: true, winnings: 20),
      ];
      final achievements = detectAchievements(results);
      expect(achievements[AchievementType.allIn], isFalse);
      expect(achievements[AchievementType.comeback], isFalse);
      expect(achievements[AchievementType.luckyBastard], isFalse);
      expect(achievements[AchievementType.oops], isFalse);
      expect(achievements[AchievementType.ghost], isFalse);
    });
  });
}
