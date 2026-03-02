import '../entities/progression_entity.dart';

abstract class ProgressionRepository {
  Future<ProgressionEntity> loadProgression();
  Future<void> saveProgression(ProgressionEntity progression);
}
