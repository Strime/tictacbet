import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/core/config/game_constants.dart';
import 'package:tictacbet/features/progression/domain/entities/progression_entity.dart';
import 'package:tictacbet/features/progression/domain/usecases/load_progression_use_case.dart';
import 'package:tictacbet/features/progression/domain/usecases/save_progression_use_case.dart';
import 'package:tictacbet/features/progression/presentation/bloc/progression_bloc.dart';

class MockLoadProgressionUseCase extends Mock
    implements LoadProgressionUseCase {}

class MockSaveProgressionUseCase extends Mock
    implements SaveProgressionUseCase {}

void main() {
  late MockLoadProgressionUseCase mockLoad;
  late MockSaveProgressionUseCase mockSave;

  setUp(() {
    mockLoad = MockLoadProgressionUseCase();
    mockSave = MockSaveProgressionUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const ProgressionEntity());
  });

  ProgressionBloc buildBloc() => ProgressionBloc(mockLoad, mockSave);

  group('ProgressionBloc', () {
    test('initial state is ProgressionInitial', () {
      expect(buildBloc().state, equals(const ProgressionInitial()));
    });

    group('ProgressionGameSettled', () {
      const baseProgression = ProgressionEntity(totalXp: 100);

      blocTest<ProgressionBloc, ProgressionState>(
        'adds base XP on win (no bonusXp)',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(progression: baseProgression),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: true,
          isDraw: false,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.totalXp,
            'totalXp',
            100 + GameConstants.xpPerWin, // no streak multiplier at streak=1
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'adds bonusXp on top of base XP on win',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(progression: baseProgression),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: true,
          isDraw: false,
          bonusXp: 40, // 2 xp cells
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.totalXp,
            'totalXp',
            100 + GameConstants.xpPerWin + 40,
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'adds bonusXp on loss',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(progression: baseProgression),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: false,
          isDraw: false,
          bonusXp: 20,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.totalXp,
            'totalXp',
            100 + GameConstants.xpPerLoss + 20,
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'adds base XP on draw without bonusXp',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(progression: baseProgression),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: false,
          isDraw: true,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.totalXp,
            'totalXp',
            100 + GameConstants.xpPerDraw,
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'bonusXp defaults to 0',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(progression: baseProgression),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: false,
          isDraw: false,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.totalXp,
            'totalXp',
            100 + GameConstants.xpPerLoss,
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'resets streak on loss',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(
          progression: ProgressionEntity(totalXp: 100, currentWinStreak: 3),
        ),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: false,
          isDraw: false,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.currentWinStreak,
            'currentWinStreak',
            0,
          ),
        ],
      );

      blocTest<ProgressionBloc, ProgressionState>(
        'preserves streak on cash out',
        build: () {
          when(() => mockSave(any())).thenAnswer((_) async {});
          return buildBloc();
        },
        seed: () => const ProgressionLoaded(
          progression: ProgressionEntity(totalXp: 100, currentWinStreak: 3),
        ),
        act: (bloc) => bloc.add(const ProgressionGameSettled(
          isWin: false,
          isDraw: false,
          isCashOut: true,
        )),
        expect: () => [
          isA<ProgressionLoaded>().having(
            (s) => s.progression.currentWinStreak,
            'currentWinStreak',
            3,
          ),
        ],
      );
    });
  });
}
