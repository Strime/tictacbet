import 'package:injectable/injectable.dart';

import '../entities/progression_entity.dart';
import '../repositories/progression_repository.dart';

@injectable
class LoadProgressionUseCase {
  final ProgressionRepository _repository;

  LoadProgressionUseCase(this._repository);

  Future<ProgressionEntity> call() => _repository.loadProgression();
}
