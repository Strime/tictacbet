import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/game_constants.dart';
import 'card_entity.dart';
import 'cell_entity.dart';
import 'game_status.dart';
import 'player_side.dart';

part 'board_entity.freezed.dart';

/// The 3x3 game board with hidden bonuses and placed cards.
@freezed
sealed class BoardEntity with _$BoardEntity {
  const BoardEntity._();

  const factory BoardEntity({
    required List<CellEntity> cells,
    required PlayerSide currentPlayer,
    @Default(0) int moveCount,
  }) = _BoardEntity;

  /// Creates a new board with randomized bonus distribution.
  factory BoardEntity.generate({Random? random}) {
    final rng = random ?? Random();
    final cells = <CellEntity>[];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final roll = rng.nextDouble();
        CellBonus? bonus;
        if (roll < GameConstants.cloverProbability) {
          bonus = CellBonus.clover;
        } else if (roll < GameConstants.cloverProbability +
            GameConstants.xpBonusProbability) {
          bonus = CellBonus.xp;
        } else {
          bonus = CellBonus.coin;
        }

        cells.add(CellEntity(row: row, col: col, bonus: bonus));
      }
    }

    return BoardEntity(cells: cells, currentPlayer: PlayerSide.red);
  }

  /// Returns cell at given position.
  CellEntity cellAt(int row, int col) => cells[row * 3 + col];

  /// Returns cell at flat index.
  CellEntity cellAtIndex(int index) => cells[index];

  /// Checks if a move at the given position is valid.
  bool isValidMove(int row, int col) {
    if (row < 0 || row >= 3 || col < 0 || col >= 3) return false;
    return cells[row * 3 + col].isEmpty;
  }

  /// Returns all valid move indices.
  List<int> get availableMoves => [
    for (int i = 0; i < 9; i++)
      if (cells[i].isEmpty) i,
  ];

  /// Applies a move: places a random card for the current player on the cell.
  BoardEntity makeMove(int row, int col, CardEntity card) {
    assert(isValidMove(row, col), 'Invalid move at ($row, $col)');
    final index = row * 3 + col;
    final newCells = List<CellEntity>.of(cells);
    newCells[index] = cells[index].copyWith(card: card, revealed: true);
    return copyWith(
      cells: newCells,
      currentPlayer: currentPlayer.opponent,
      moveCount: moveCount + 1,
    );
  }

  /// All possible winning patterns (rows, columns, diagonals).
  static const _winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6], // diagonals
  ];

  /// Returns the winning pattern and suit, or null if no winner.
  (List<int> pattern, CardSuit suit)? _findWinningPattern() {
    for (final pattern in _winPatterns) {
      final a = cells[pattern[0]].card?.suit;
      if (a != null &&
          a == cells[pattern[1]].card?.suit &&
          a == cells[pattern[2]].card?.suit) {
        return (pattern, a);
      }
    }
    return null;
  }

  /// Check the game status.
  GameStatus get status {
    final winner = _findWinningPattern();
    if (winner != null) {
      return winner.$2 == CardSuit.heart
          ? GameStatus.redWins
          : GameStatus.blackWins;
    }
    if (cells.every((c) => c.isNotEmpty)) return GameStatus.draw;
    return GameStatus.inProgress;
  }

  /// Returns the winning line cell indices, or null if no winner.
  List<int>? get winningLine => _findWinningPattern()?.$1;

  bool get isGameOver => status.isGameOver;
}
