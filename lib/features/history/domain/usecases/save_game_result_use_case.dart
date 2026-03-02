import 'package:injectable/injectable.dart';

import '../entities/game_result_entity.dart';
import '../repositories/history_repository.dart';

@injectable
class SaveGameResultUseCase {
  final HistoryRepository _repository;

  SaveGameResultUseCase(this._repository);

  Future<void> call(GameResultEntity result) => _repository.saveResult(result);
}
