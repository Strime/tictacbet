import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/game_constants.dart';

part 'progression_entity.freezed.dart';

@freezed
sealed class ProgressionEntity with _$ProgressionEntity {
  const ProgressionEntity._();

  const factory ProgressionEntity({
    @Default(0) int totalXp,
    @Default(0) int currentWinStreak,
    @Default(0) int bestWinStreak,
  }) = _ProgressionEntity;

  int get level => GameConstants.levelFromXp(totalXp);

  int get xpForCurrentLevel => GameConstants.xpForLevel(level);

  int get xpForNextLevel => GameConstants.xpForLevel(level + 1);

  double get progressFraction {
    final range = xpForNextLevel - xpForCurrentLevel;
    if (range <= 0) return 0.0;
    return (totalXp - xpForCurrentLevel) / range;
  }
}
