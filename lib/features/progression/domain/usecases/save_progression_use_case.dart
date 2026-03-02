import 'package:injectable/injectable.dart';

import '../entities/progression_entity.dart';
import '../repositories/progression_repository.dart';

@injectable
class SaveProgressionUseCase {
  final ProgressionRepository _repository;

  SaveProgressionUseCase(this._repository);

  Future<void> call(ProgressionEntity progression) =>
      _repository.saveProgression(progression);
}
