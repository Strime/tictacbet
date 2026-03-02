import '../entities/game_result_entity.dart';

abstract class HistoryRepository {
  Future<List<GameResultEntity>> loadHistory();
  Future<void> saveResult(GameResultEntity result);
}
