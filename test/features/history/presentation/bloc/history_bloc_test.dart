import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';
import 'package:tictacbet/features/history/domain/usecases/load_history_use_case.dart';
import 'package:tictacbet/features/history/presentation/bloc/history_bloc.dart';

class MockLoadHistoryUseCase extends Mock implements LoadHistoryUseCase {}

void main() {
  late MockLoadHistoryUseCase mockLoadHistory;

  setUp(() {
    mockLoadHistory = MockLoadHistoryUseCase();
  });

  HistoryBloc buildBloc() => HistoryBloc(mockLoadHistory);

  final results = [
    GameResultEntity(
      result: GameStatus.redWins,
      humanSide: PlayerSide.red,
      aiLevel: 0.5,
      betAmount: 10,
      winnings: 20,
      playedAt: DateTime(2026, 3, 1),
      duration: const Duration(minutes: 2),
      moveCount: 7,
    ),
    GameResultEntity(
      result: GameStatus.draw,
      humanSide: PlayerSide.black,
      aiLevel: 0.8,
      betAmount: 5,
      winnings: 5,
      playedAt: DateTime(2026, 3, 2),
      duration: const Duration(minutes: 3),
      moveCount: 9,
    ),
  ];

  group('HistoryBloc', () {
    test('initial state is HistoryInitial', () {
      expect(buildBloc().state, equals(const HistoryInitial()));
    });

    group('HistoryStarted', () {
      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] on success',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => results);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const HistoryStarted()),
        expect: () => [
          const HistoryLoading(),
          HistoryLoaded(results: results),
        ],
        verify: (_) {
          verify(() => mockLoadHistory()).called(1);
        },
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryLoaded] with empty list',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => []);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const HistoryStarted()),
        expect: () => [
          const HistoryLoading(),
          const HistoryLoaded(results: []),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoading, HistoryError] on failure',
        build: () {
          when(() => mockLoadHistory()).thenThrow(Exception('db error'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const HistoryStarted()),
        expect: () => [
          const HistoryLoading(),
          const HistoryError(),
        ],
      );
    });

    group('HistoryRefreshed', () {
      blocTest<HistoryBloc, HistoryState>(
        'emits [HistoryLoaded] without HistoryLoading on success',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => results);
          return buildBloc();
        },
        seed: () => const HistoryLoaded(results: []),
        act: (bloc) => bloc.add(const HistoryRefreshed()),
        expect: () => [
          HistoryLoaded(results: results),
        ],
      );

      blocTest<HistoryBloc, HistoryState>(
        'emits nothing on failure (keeps current state)',
        build: () {
          when(() => mockLoadHistory()).thenThrow(Exception('db error'));
          return buildBloc();
        },
        seed: () => const HistoryLoaded(results: []),
        act: (bloc) => bloc.add(const HistoryRefreshed()),
        expect: () => [],
      );

      test('completes the completer on success', () async {
        when(() => mockLoadHistory()).thenAnswer((_) async => results);
        final bloc = buildBloc();
        final completer = Completer<void>();

        bloc.add(HistoryRefreshed(completer: completer));
        await completer.future;

        expect(completer.isCompleted, isTrue);
        await bloc.close();
      });

      test('completes the completer on failure', () async {
        when(() => mockLoadHistory()).thenThrow(Exception('db error'));
        final bloc = buildBloc();
        final completer = Completer<void>();

        bloc.add(HistoryRefreshed(completer: completer));
        await completer.future;

        expect(completer.isCompleted, isTrue);
        await bloc.close();
      });

      blocTest<HistoryBloc, HistoryState>(
        'works without completer (null)',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => results);
          return buildBloc();
        },
        seed: () => const HistoryLoaded(results: []),
        act: (bloc) => bloc.add(const HistoryRefreshed()),
        expect: () => [
          HistoryLoaded(results: results),
        ],
      );
    });
  });
}
