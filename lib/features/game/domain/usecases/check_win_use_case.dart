import 'package:injectable/injectable.dart';

import '../entities/board_entity.dart';
import '../entities/game_status.dart';

@injectable
class CheckWinUseCase {
  GameStatus call(BoardEntity board) => board.status;
}
