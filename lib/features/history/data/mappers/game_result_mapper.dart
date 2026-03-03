import '../../../game/domain/entities/game_status.dart';
import '../../../game/domain/entities/player_side.dart';
import '../../domain/entities/game_result_entity.dart';
import '../models/game_result_model.dart';

class GameResultMapper {
  GameResultMapper._();

  static GameResultEntity toEntity(GameResultModel model) => GameResultEntity(
        result: GameStatus.values.firstWhere(
          (s) => s.name == model.result,
          orElse: () => GameStatus.draw,
        ),
        humanSide: PlayerSide.values.firstWhere(
          (s) => s.name == model.humanSide,
          orElse: () => PlayerSide.red,
        ),
        aiLevel: model.aiLevel,
        betAmount: model.betAmount,
        winnings: model.winnings,
        playedAt: DateTime.parse(model.playedAt),
        duration: Duration(seconds: model.durationSeconds),
        moveCount: model.moveCount,
        isCashOut: model.isCashOut,
      );

  static GameResultModel toModel(GameResultEntity entity) => GameResultModel(
        result: entity.result.name,
        humanSide: entity.humanSide.name,
        aiLevel: entity.aiLevel,
        betAmount: entity.betAmount,
        winnings: entity.winnings,
        playedAt: entity.playedAt.toIso8601String(),
        durationSeconds: entity.duration.inSeconds,
        moveCount: entity.moveCount,
        isCashOut: entity.isCashOut,
      );
}
