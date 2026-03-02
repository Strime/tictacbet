import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../game/domain/entities/game_status.dart';
import '../../../game/domain/entities/player_side.dart';

part 'game_result_entity.freezed.dart';

@freezed
sealed class GameResultEntity with _$GameResultEntity {
  const GameResultEntity._();

  const factory GameResultEntity({
    required GameStatus result,
    required PlayerSide humanSide,
    required double aiLevel,
    required int betAmount,
    required int winnings,
    required DateTime playedAt,
    required Duration duration,
    required int moveCount,
  }) = _GameResultEntity;

  bool get isWin =>
      (humanSide == PlayerSide.red && result == GameStatus.redWins) ||
      (humanSide == PlayerSide.black && result == GameStatus.blackWins);

  bool get isDraw => result == GameStatus.draw;
  bool get isLoss => !isWin && !isDraw;

  int get netAmount => isLoss ? -betAmount : winnings - betAmount;
}
