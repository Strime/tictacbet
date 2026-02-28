import 'dart:math';

import 'package:injectable/injectable.dart';

import '../entities/board_entity.dart';
import '../entities/card_entity.dart';

@injectable
class PlayMoveUseCase {
  final Random _random;

  PlayMoveUseCase({@factoryParam Random? random})
      : _random = random ?? Random();

  /// Places a card for the current player at the given position.
  /// Returns the updated board, or null if the move is invalid.
  BoardEntity? call(BoardEntity board, int row, int col) {
    if (!board.isValidMove(row, col)) return null;

    final card = _generateRandomCard(board.currentPlayer.suit);
    return board.makeMove(row, col, card);
  }

  CardEntity _generateRandomCard(CardSuit suit) {
    final ranks = CardRank.values;
    final rank = ranks[_random.nextInt(ranks.length)];
    return CardEntity(suit: suit, rank: rank);
  }
}
