import 'package:injectable/injectable.dart';

import '../../domain/entities/progression_entity.dart';
import '../../domain/repositories/progression_repository.dart';
import '../datasources/progression_local_data_source.dart';

@LazySingleton(as: ProgressionRepository)
class ProgressionRepositoryImpl implements ProgressionRepository {
  final ProgressionLocalDataSource _localDataSource;

  ProgressionRepositoryImpl(this._localDataSource);

  @override
  Future<ProgressionEntity> loadProgression() async {
    return ProgressionEntity(
      totalXp: _localDataSource.getTotalXp(),
      currentWinStreak: _localDataSource.getCurrentWinStreak(),
      bestWinStreak: _localDataSource.getBestWinStreak(),
    );
  }

  @override
  Future<void> saveProgression(ProgressionEntity progression) async {
    await Future.wait([
      _localDataSource.setTotalXp(progression.totalXp),
      _localDataSource.setCurrentWinStreak(progression.currentWinStreak),
      _localDataSource.setBestWinStreak(progression.bestWinStreak),
    ]);
  }
}
