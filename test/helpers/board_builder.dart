import 'package:tictacbet/features/game/domain/entities/board_entity.dart';
import 'package:tictacbet/features/game/domain/entities/card_entity.dart';
import 'package:tictacbet/features/game/domain/entities/cell_entity.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';

/// Builds a board from a 9-char string for concise test setup.
///
/// Characters:
/// - 'R' = Red (heart) card placed
/// - 'B' = Black (spade) card placed
/// - '.' = empty cell
///
/// Example: 'RRR......' = Red wins top row.
BoardEntity buildBoard(
  String layout, {
  PlayerSide currentPlayer = PlayerSide.red,
  CellBonus? Function(int index)? bonusAt,
}) {
  assert(layout.length == 9, 'Layout must be exactly 9 characters');

  final cells = <CellEntity>[];
  int moveCount = 0;

  for (int i = 0; i < 9; i++) {
    final row = i ~/ 3;
    final col = i % 3;
    final char = layout[i];
    final bonus = bonusAt?.call(i);

    CardEntity? card;
    if (char == 'R') {
      card = const CardEntity(suit: CardSuit.heart, rank: CardRank.ace);
      moveCount++;
    } else if (char == 'B') {
      card = const CardEntity(suit: CardSuit.spade, rank: CardRank.ace);
      moveCount++;
    }

    cells.add(CellEntity(
      row: row,
      col: col,
      bonus: bonus,
      card: card,
      revealed: card != null,
    ));
  }

  return BoardEntity(
    cells: cells,
    currentPlayer: currentPlayer,
    moveCount: moveCount,
  );
}
