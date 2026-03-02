import 'package:injectable/injectable.dart';

import '../entities/game_result_entity.dart';
import '../repositories/history_repository.dart';

@injectable
class LoadHistoryUseCase {
  final HistoryRepository _repository;

  LoadHistoryUseCase(this._repository);

  Future<List<GameResultEntity>> call() => _repository.loadHistory();
}
