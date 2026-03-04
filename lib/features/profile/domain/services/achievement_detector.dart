import '../../../history/domain/entities/game_result_entity.dart';
import '../entities/achievement.dart';

Map<AchievementType, bool> detectAchievements(
  List<GameResultEntity> results,
) {
  return {
    AchievementType.speedRun: _hasSpeedRun(results),
    AchievementType.highRoller: _isHighRoller(results),
    AchievementType.hatTrick: _hasHatTrick(results),
    AchievementType.whale: _isWhale(results),
    AchievementType.allIn: false,
    AchievementType.comeback: false,
    AchievementType.oops: false,
    AchievementType.ghost: false,
    AchievementType.goldenParachute: _hasGoldenParachute(results),
    AchievementType.paperHands: _hasPaperHands(results),
  };
}

/// Win a game in under 30 seconds.
bool _hasSpeedRun(List<GameResultEntity> results) {
  return results.any((r) => r.isWin && r.duration.inSeconds < 30);
}

/// Accumulate $100 in positive net earnings.
bool _isHighRoller(List<GameResultEntity> results) {
  final totalPositiveNet = results
      .where((r) => r.netAmount > 0)
      .fold<int>(0, (sum, r) => sum + r.netAmount);
  return totalPositiveNet >= 100;
}

/// Win 3 consecutive games.
bool _hasHatTrick(List<GameResultEntity> results) {
  var consecutiveWins = 0;
  for (final r in results) {
    if (r.isWin) {
      consecutiveWins++;
      if (consecutiveWins >= 3) return true;
    } else {
      consecutiveWins = 0;
    }
  }
  return false;
}

/// Win a game with a $50+ bet.
bool _isWhale(List<GameResultEntity> results) {
  return results.any((r) => r.isWin && r.betAmount >= 50);
}

/// Cash out with a profit (winnings > betAmount).
bool _hasGoldenParachute(List<GameResultEntity> results) {
  return results.any((r) => r.isCashOut && r.winnings > r.betAmount);
}

/// Cash out 3 times total.
bool _hasPaperHands(List<GameResultEntity> results) {
  return results.where((r) => r.isCashOut).length >= 3;
}
