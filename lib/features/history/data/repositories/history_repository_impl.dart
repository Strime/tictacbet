import 'package:injectable/injectable.dart';

import '../../domain/entities/game_result_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../mappers/game_result_mapper.dart';

@Injectable(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _localDataSource;

  HistoryRepositoryImpl(this._localDataSource);

  @override
  Future<List<GameResultEntity>> loadHistory() async {
    final models = _localDataSource.getHistory();
    return models.map(GameResultMapper.toEntity).toList();
  }

  @override
  Future<void> saveResult(GameResultEntity result) async {
    await _localDataSource.saveResult(GameResultMapper.toModel(result));
  }
}
