import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/core/config/game_constants.dart';
import 'package:tictacbet/features/game/domain/entities/board_entity.dart';
import 'package:tictacbet/features/game/domain/entities/card_entity.dart';
import 'package:tictacbet/features/game/domain/entities/cell_entity.dart';
import 'package:tictacbet/features/game/domain/entities/game_entity.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';

/// Helper to build a board from a list of 9 cell descriptors.
/// Each descriptor is a tuple: (CardSuit? suit, CellBonus? bonus).
BoardEntity _buildBoard(
  List<(CardSuit?, CellBonus?)> descriptors, {
  PlayerSide currentPlayer = PlayerSide.red,
}) {
  final cells = <CellEntity>[];
  for (int i = 0; i < 9; i++) {
    final (suit, bonus) = descriptors[i];
    cells.add(CellEntity(
      row: i ~/ 3,
      col: i % 3,
      bonus: bonus,
      card: suit != null
          ? CardEntity(suit: suit, rank: CardRank.ace)
          : null,
      revealed: suit != null,
    ));
  }
  return BoardEntity(
    cells: cells,
    currentPlayer: currentPlayer,
  );
}

GameEntity _buildGame(
  BoardEntity board, {
  PlayerSide humanSide = PlayerSide.red,
  int betAmount = 10,
}) {
  return GameEntity(
    board: board,
    humanSide: humanSide,
    aiLevel: 0.5,
    betAmount: betAmount,
    startedAt: DateTime(2025, 1, 1),
    endedAt: DateTime(2025, 1, 1, 0, 1),
  );
}

const h = CardSuit.heart; // red
const s = CardSuit.spade; // black

void main() {
  group('GameEntity', () {
    group('winnings', () {
      test('returns 0 when game is not over', () {
        // Board with only one move — game in progress
        final board = _buildBoard([
          (h, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.xp),
          (null, CellBonus.coin), (null, CellBonus.xp), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.xp), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board);

        expect(game.isGameOver, isFalse);
        expect(game.winnings, 0);
      });

      test('returns base + bet*2 on human win without bonuses', () {
        // Red (human) wins top row, no coin bonuses on winning cells
        final board = _buildBoard([
          (h, CellBonus.xp), (h, CellBonus.xp), (h, CellBonus.xp),
          (s, CellBonus.coin), (s, CellBonus.coin), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board, betAmount: 10);

        expect(game.humanWon, isTrue);
        expect(
          game.winnings,
          GameConstants.winBonusBase + 10 * GameConstants.winBetMultiplier,
        );
      });

      test('includes coin bonus from winning line cells only', () {
        // Red wins top row; 2 coin bonuses + 1 xp bonus on winning line
        final board = _buildBoard([
          (h, CellBonus.coin), (h, CellBonus.coin), (h, CellBonus.xp),
          (s, CellBonus.coin), (s, CellBonus.coin), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board, betAmount: 10);

        expect(game.humanWon, isTrue);
        expect(game.collectedCoinBonus, 2 * GameConstants.coinBonusValue);
        expect(
          game.winnings,
          GameConstants.winBonusBase +
              10 * GameConstants.winBetMultiplier +
              2 * GameConstants.coinBonusValue,
        );
      });

      test('returns betAmount on draw (no bonuses)', () {
        // Full board, no winner
        final board = _buildBoard([
          (h, CellBonus.coin), (s, CellBonus.coin), (h, CellBonus.coin),
          (h, CellBonus.coin), (s, CellBonus.coin), (s, CellBonus.coin),
          (s, CellBonus.coin), (h, CellBonus.coin), (s, CellBonus.coin),
        ]);
        final game = _buildGame(board, betAmount: 10);

        expect(game.status.isGameOver, isTrue);
        expect(game.humanWon, isFalse);
        expect(game.winnings, 10);
      });

      test('returns 0 on human loss', () {
        // Black (opponent) wins top row
        final board = _buildBoard([
          (s, CellBonus.coin), (s, CellBonus.coin), (s, CellBonus.coin),
          (h, CellBonus.coin), (h, CellBonus.coin), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board, betAmount: 10);

        expect(game.humanWon, isFalse);
        expect(game.winnings, 0);
      });
    });

    group('collectedCoinBonus', () {
      test('counts only coin bonuses on winning line', () {
        // Red wins first column; cell(0,0)=coin, cell(1,0)=xp, cell(2,0)=coin
        final board = _buildBoard([
          (h, CellBonus.coin), (s, CellBonus.coin), (null, CellBonus.coin),
          (h, CellBonus.xp),  (s, CellBonus.coin), (null, CellBonus.coin),
          (h, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board);

        expect(game.collectedCoinBonus, 2 * GameConstants.coinBonusValue);
      });

      test('returns 0 when human loses', () {
        final board = _buildBoard([
          (s, CellBonus.coin), (s, CellBonus.coin), (s, CellBonus.coin),
          (h, CellBonus.coin), (h, CellBonus.coin), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board);

        expect(game.collectedCoinBonus, 0);
      });

      test('returns 0 on draw', () {
        final board = _buildBoard([
          (h, CellBonus.coin), (s, CellBonus.coin), (h, CellBonus.coin),
          (h, CellBonus.coin), (s, CellBonus.coin), (s, CellBonus.coin),
          (s, CellBonus.coin), (h, CellBonus.coin), (s, CellBonus.coin),
        ]);
        final game = _buildGame(board);

        expect(game.collectedCoinBonus, 0);
      });
    });

    group('collectedXpBonus', () {
      test('counts only xp bonuses on winning line', () {
        // Red wins top row; all 3 cells have xp bonus
        final board = _buildBoard([
          (h, CellBonus.xp), (h, CellBonus.xp), (h, CellBonus.xp),
          (s, CellBonus.coin), (s, CellBonus.coin), (null, CellBonus.coin),
          (null, CellBonus.coin), (null, CellBonus.coin), (null, CellBonus.coin),
        ]);
        final game = _buildGame(board);

        expect(game.collectedXpBonus, 3 * GameConstants.xpPerBonusCell);
      });

      test('returns 0 when no xp bonuses on winning line', () {
        // Red wins top row; all coin bonuses
        final board = _buildBoard([
          (h, CellBonus.coin), (h, CellBonus.coin), (h, CellBonus.coin),
          (s, CellBonus.xp), (s, CellBonus.xp), (null, CellBonus.xp),
          (null, CellBonus.xp), (null, CellBonus.xp), (null, CellBonus.xp),
        ]);
        final game = _buildGame(board);

        expect(game.collectedXpBonus, 0);
      });

      test('returns 0 when human loses', () {
        final board = _buildBoard([
          (s, CellBonus.xp), (s, CellBonus.xp), (s, CellBonus.xp),
          (h, CellBonus.xp), (h, CellBonus.xp), (null, CellBonus.xp),
          (null, CellBonus.xp), (null, CellBonus.xp), (null, CellBonus.xp),
        ]);
        final game = _buildGame(board);

        expect(game.collectedXpBonus, 0);
      });
    });
  });
}
