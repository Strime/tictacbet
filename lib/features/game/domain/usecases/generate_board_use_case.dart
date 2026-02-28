import 'dart:math';

import 'package:injectable/injectable.dart';

import '../entities/board_entity.dart';

@injectable
class GenerateBoardUseCase {
  BoardEntity call({Random? random}) => BoardEntity.generate(random: random);
}
