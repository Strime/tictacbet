import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/game_constants.dart';
import 'board_entity.dart';
import 'game_status.dart';
import 'player_side.dart';

part 'game_entity.freezed.dart';

/// Represents a full game session.
@freezed
sealed class GameEntity with _$GameEntity {
  const GameEntity._();

  const factory GameEntity({
    required BoardEntity board,
    required PlayerSide humanSide,
    required double aiLevel,
    required int betAmount,
    required DateTime startedAt,
    DateTime? endedAt,
  }) = _GameEntity;

  GameStatus get status => board.status;
  bool get isGameOver => board.isGameOver;
  int get moveCount => board.moveCount;
  bool get isHumanTurn => board.currentPlayer == humanSide;

  Duration? get duration => endedAt?.difference(startedAt);

  bool get humanWon =>
      (humanSide == PlayerSide.red && status == GameStatus.redWins) ||
      (humanSide == PlayerSide.black && status == GameStatus.blackWins);

  int get winnings {
    if (!isGameOver) return 0;
    if (humanWon) {
      return GameConstants.winBonusBase +
          betAmount * GameConstants.winBetMultiplier;
    }
    if (status == GameStatus.draw) return betAmount;
    return 0;
  }
}
