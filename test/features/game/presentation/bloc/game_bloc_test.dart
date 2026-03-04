import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/ai/domain/usecases/compute_ai_move_use_case.dart';
import 'package:tictacbet/features/game/domain/entities/board_entity.dart';
import 'package:tictacbet/features/game/domain/entities/game_entity.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/game/domain/usecases/compute_cash_out_use_case.dart';
import 'package:tictacbet/features/game/domain/usecases/generate_board_use_case.dart';
import 'package:tictacbet/features/game/domain/usecases/play_move_use_case.dart';
import 'package:tictacbet/features/game/presentation/bloc/game_bloc.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';
import 'package:tictacbet/features/history/domain/usecases/save_game_result_use_case.dart';

import '../../../../helpers/board_builder.dart';

class MockGenerateBoardUseCase extends Mock implements GenerateBoardUseCase {}

class MockPlayMoveUseCase extends Mock implements PlayMoveUseCase {}

class MockComputeAiMoveUseCase extends Mock implements ComputeAiMoveUseCase {}

class MockSaveGameResultUseCase extends Mock
    implements SaveGameResultUseCase {}

class MockComputeCashOutUseCase extends Mock
    implements ComputeCashOutUseCase {}

void main() {
  late MockGenerateBoardUseCase mockGenerateBoard;
  late MockPlayMoveUseCase mockPlayMove;
  late MockComputeAiMoveUseCase mockComputeAiMove;
  late MockSaveGameResultUseCase mockSaveGameResult;
  late MockComputeCashOutUseCase mockComputeCashOut;

  setUp(() {
    mockGenerateBoard = MockGenerateBoardUseCase();
    mockPlayMove = MockPlayMoveUseCase();
    mockComputeAiMove = MockComputeAiMoveUseCase();
    mockSaveGameResult = MockSaveGameResultUseCase();
    mockComputeCashOut = MockComputeCashOutUseCase();
  });

  setUpAll(() {
    registerFallbackValue(buildBoard('.........'));
    registerFallbackValue(GameResultEntity(
      result: GameStatus.draw,
      humanSide: PlayerSide.red,
      aiLevel: 0.0,
      betAmount: 1,
      winnings: 0,
      playedAt: DateTime(2024),
      duration: Duration.zero,
      moveCount: 0,
    ));
  });

  GameBloc buildBloc() => GameBloc(
        mockGenerateBoard,
        mockPlayMove,
        mockComputeAiMove,
        mockSaveGameResult,
        mockComputeCashOut,
      );

  /// Helper: creates an empty board with a fixed seed for predictable bonuses.
  BoardEntity emptyBoard({PlayerSide currentPlayer = PlayerSide.red}) =>
      buildBoard('.........', currentPlayer: currentPlayer);

  group('GameBloc', () {
    test('initial state is GameInitial', () {
      expect(buildBloc().state, equals(const GameInitial()));
    });

    group('GameStarted', () {
      blocTest<GameBloc, GameState>(
        'emits GameInProgress when human plays first (red)',
        build: () {
          final board = emptyBoard();
          when(() => mockGenerateBoard(random: any(named: 'random')))
              .thenReturn(board);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const GameStarted(
          humanSide: PlayerSide.red,
          aiLevel: 0.0,
          betAmount: 5,
        )),
        expect: () => [
          isA<GameInProgress>()
              .having((s) => s.game.humanSide, 'humanSide', PlayerSide.red)
              .having((s) => s.game.betAmount, 'betAmount', 5)
              .having((s) => s.isAiThinking, 'isAiThinking', false),
        ],
        verify: (_) {
          verifyNever(() => mockComputeAiMove(any(), any()));
        },
      );

      blocTest<GameBloc, GameState>(
        'triggers AI move when human plays second (black)',
        build: () {
          final board = emptyBoard();
          when(() => mockGenerateBoard(random: any(named: 'random')))
              .thenReturn(board);

          final boardAfterAi = buildBoard(
            'R........',
            currentPlayer: PlayerSide.black,
          );
          when(() => mockComputeAiMove(any(), any())).thenReturn(0);
          when(() => mockPlayMove(any(), 0, 0)).thenReturn(boardAfterAi);

          return buildBloc();
        },
        act: (bloc) => bloc.add(const GameStarted(
          humanSide: PlayerSide.black,
          aiLevel: 0.3,
          betAmount: 10,
        )),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          // First: GameInProgress (board generated)
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', false),
          // Second: AI thinking
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', true),
          // Third: AI moved
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', false)
              .having((s) => s.lastMoveIndex, 'lastMoveIndex', 0),
        ],
        verify: (_) {
          verify(() => mockComputeAiMove(any(), 0.3)).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'sets isAllIn flag correctly',
        build: () {
          final board = emptyBoard();
          when(() => mockGenerateBoard(random: any(named: 'random')))
              .thenReturn(board);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const GameStarted(
          humanSide: PlayerSide.red,
          aiLevel: 1.0,
          betAmount: 50,
          isAllIn: true,
        )),
        expect: () => [
          isA<GameInProgress>()
              .having((s) => s.game.isAllIn, 'isAllIn', true)
              .having((s) => s.game.betAmount, 'betAmount', 50),
        ],
      );
    });

    group('CellTapped', () {
      blocTest<GameBloc, GameState>(
        'ignores tap when state is not GameInProgress',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 0)),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'ignores tap when AI is thinking',
        build: () => buildBloc(),
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
          isAiThinking: true,
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 0)),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'ignores tap when not human turn',
        build: () => buildBloc(),
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(currentPlayer: PlayerSide.black),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 0)),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'ignores tap when move is invalid',
        build: () {
          when(() => mockPlayMove(any(), 0, 0)).thenReturn(null);
          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 0)),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'processes human move then AI move',
        build: () {
          // Human plays (0,0) -> red at top-left
          final boardAfterHuman = buildBoard(
            'R........',
            currentPlayer: PlayerSide.black,
          );
          when(() => mockPlayMove(any(), 0, 0)).thenReturn(boardAfterHuman);

          // AI plays index 4 -> center
          when(() => mockComputeAiMove(any(), any())).thenReturn(4);
          final boardAfterAi = buildBoard(
            'R...B....',
            currentPlayer: PlayerSide.red,
          );
          when(() => mockPlayMove(any(), 1, 1)).thenReturn(boardAfterAi);

          when(() => mockComputeCashOut(any(), any())).thenReturn(3);

          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 0)),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          // Human moved, AI thinking
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', true)
              .having((s) => s.lastMoveIndex, 'lastMoveIndex', 0),
          // AI moved
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', false)
              .having((s) => s.lastMoveIndex, 'lastMoveIndex', 4)
              .having((s) => s.cashOutAmount, 'cashOutAmount', 3),
        ],
      );

      blocTest<GameBloc, GameState>(
        'emits GameOver when human wins',
        build: () {
          // Human completes winning line: R R _ -> R R R
          final winningBoard = buildBoard(
            'RRR..B.B.',
            currentPlayer: PlayerSide.black,
          );
          when(() => mockPlayMove(any(), 0, 2)).thenReturn(winningBoard);
          when(() => mockSaveGameResult(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: buildBoard(
              'RR...B.B.',
              currentPlayer: PlayerSide.red,
            ),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 0, col: 2)),
        expect: () => [
          isA<GameOver>()
              .having((s) => s.game.status, 'status', GameStatus.redWins)
              .having(
                  (s) => s.winningLine, 'winningLine', isNotNull)
              .having((s) => s.isCashOut, 'isCashOut', false),
        ],
        verify: (_) {
          verify(() => mockSaveGameResult(any())).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'emits GameOver when AI wins after human move',
        build: () {
          // Human plays at (2,2)
          final boardAfterHuman = buildBoard(
            'BB.RR...R',
            currentPlayer: PlayerSide.black,
          );
          when(() => mockPlayMove(any(), 2, 2)).thenReturn(boardAfterHuman);

          // AI wins by completing top row: B B _ -> B B B
          when(() => mockComputeAiMove(any(), any())).thenReturn(2);
          final winBoard = buildBoard(
            'BBBRR...R',
            currentPlayer: PlayerSide.red,
          );
          when(() => mockPlayMove(any(), 0, 2)).thenReturn(winBoard);
          when(() => mockSaveGameResult(any())).thenAnswer((_) async {});

          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: buildBoard(
              'BB.RR....',
              currentPlayer: PlayerSide.red,
            ),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 2, col: 2)),
        wait: const Duration(milliseconds: 700),
        expect: () => [
          // Human moved, AI thinking
          isA<GameInProgress>()
              .having((s) => s.isAiThinking, 'isAiThinking', true),
          // AI wins
          isA<GameOver>()
              .having(
                  (s) => s.game.status, 'status', GameStatus.blackWins),
        ],
        verify: (_) {
          verify(() => mockSaveGameResult(any())).called(1);
        },
      );

      blocTest<GameBloc, GameState>(
        'emits GameOver on draw after human move fills board',
        build: () {
          // Last move fills the board -> draw
          // Final board: R B R / R R B / B R B (no three-in-a-row)
          final drawBoard = buildBoard(
            'RBRRRBBRB',
            currentPlayer: PlayerSide.black,
          );
          when(() => mockPlayMove(any(), 2, 1)).thenReturn(drawBoard);
          when(() => mockSaveGameResult(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: buildBoard(
              'RBRRRBB.B',
              currentPlayer: PlayerSide.red,
            ),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const CellTapped(row: 2, col: 1)),
        expect: () => [
          isA<GameOver>()
              .having((s) => s.game.status, 'status', GameStatus.draw),
        ],
        verify: (_) {
          verify(() => mockSaveGameResult(any())).called(1);
        },
      );
    });

    group('GameCashedOut', () {
      blocTest<GameBloc, GameState>(
        'ignores when state is not GameInProgress',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const GameCashedOut()),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'ignores when no cashOutAmount available',
        build: () => buildBloc(),
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
          cashOutAmount: null,
        ),
        act: (bloc) => bloc.add(const GameCashedOut()),
        expect: () => [],
      );

      blocTest<GameBloc, GameState>(
        'emits GameOver with cashOutAmount when cashing out',
        build: () {
          when(() => mockSaveGameResult(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => GameInProgress(
          game: GameEntity(
            board: buildBoard(
              'R.B.R....',
              currentPlayer: PlayerSide.black,
            ),
            humanSide: PlayerSide.red,
            aiLevel: 0.3,
            betAmount: 10,
            startedAt: DateTime(2024),
          ),
          cashOutAmount: 8,
        ),
        act: (bloc) => bloc.add(const GameCashedOut()),
        expect: () => [
          isA<GameOver>()
              .having((s) => s.cashOutAmount, 'cashOutAmount', 8)
              .having((s) => s.isCashOut, 'isCashOut', true),
        ],
        verify: (_) {
          verify(() => mockSaveGameResult(any())).called(1);
        },
      );
    });

    group('GameReset', () {
      blocTest<GameBloc, GameState>(
        'emits GameInitial',
        build: () => buildBloc(),
        seed: () => GameInProgress(
          game: GameEntity(
            board: emptyBoard(),
            humanSide: PlayerSide.red,
            aiLevel: 0.0,
            betAmount: 5,
            startedAt: DateTime(2024),
          ),
        ),
        act: (bloc) => bloc.add(const GameReset()),
        expect: () => [const GameInitial()],
      );
    });
  });
}
