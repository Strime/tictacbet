import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/game/domain/entities/game_status.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/history/domain/entities/game_result_entity.dart';
import 'package:tictacbet/core/error/failure.dart';
import 'package:tictacbet/features/history/domain/usecases/load_history_use_case.dart';
import 'package:tictacbet/features/progression/domain/entities/progression_entity.dart';
import 'package:tictacbet/features/progression/domain/usecases/load_progression_use_case.dart';
import 'package:tictacbet/features/profile/domain/entities/achievement.dart';
import 'package:tictacbet/features/profile/presentation/bloc/profile_bloc.dart';

class MockLoadHistoryUseCase extends Mock implements LoadHistoryUseCase {}

class MockLoadProgressionUseCase extends Mock
    implements LoadProgressionUseCase {}

const _emptyAchievements = {
  AchievementType.speedRun: false,
  AchievementType.highRoller: false,
  AchievementType.hatTrick: false,
  AchievementType.whale: false,
  AchievementType.allIn: false,
  AchievementType.comeback: false,
  AchievementType.oops: false,
  AchievementType.ghost: false,
  AchievementType.goldenParachute: false,
  AchievementType.paperHands: false,
};

void main() {
  late MockLoadHistoryUseCase mockLoadHistory;
  late MockLoadProgressionUseCase mockLoadProgression;

  setUp(() {
    mockLoadHistory = MockLoadHistoryUseCase();
    mockLoadProgression = MockLoadProgressionUseCase();
    when(() => mockLoadProgression())
        .thenAnswer((_) async => const ProgressionEntity());
  });

  ProfileBloc buildBloc() =>
      ProfileBloc(mockLoadHistory, mockLoadProgression);

  // 1 win (red wins, human red) → net: 25-10 = +15
  // 1 draw → net: 5-5 = 0
  // 1 loss (red wins, human black) → net: -15
  final results = [
    GameResultEntity(
      result: GameStatus.redWins,
      humanSide: PlayerSide.red,
      aiLevel: 0.5,
      betAmount: 10,
      winnings: 25,
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
    GameResultEntity(
      result: GameStatus.redWins,
      humanSide: PlayerSide.black,
      aiLevel: 0.3,
      betAmount: 15,
      winnings: 0,
      playedAt: DateTime(2026, 3, 3),
      duration: const Duration(minutes: 1),
      moveCount: 5,
    ),
  ];

  group('ProfileBloc', () {
    test('initial state is ProfileInitial', () {
      expect(buildBloc().state, equals(const ProfileInitial()));
    });

    group('ProfileStarted', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileLoaded] with correct stats',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => results);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileStarted()),
        expect: () => [
          const ProfileLoading(),
          isA<ProfileLoaded>()
              .having((s) => s.gamesPlayed, 'gamesPlayed', 3)
              .having((s) => s.wins, 'wins', 1)
              .having((s) => s.losses, 'losses', 1)
              .having((s) => s.draws, 'draws', 1)
              .having((s) => s.winRate, 'winRate', closeTo(33.3, 0.1))
              .having((s) => s.totalEarnings, 'totalEarnings', 0)
              .having((s) => s.achievements, 'achievements', isA<Map>()),
        ],
        verify: (_) {
          verify(() => mockLoadHistory()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileLoaded] with empty stats when no games',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => []);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileStarted()),
        expect: () => [
          const ProfileLoading(),
          const ProfileLoaded(
            gamesPlayed: 0,
            wins: 0,
            losses: 0,
            draws: 0,
            winRate: 0.0,
            totalEarnings: 0,
            achievements: _emptyAchievements,
          bestWinStreak: 0,
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoading, ProfileError] on failure',
        build: () {
          when(() => mockLoadHistory()).thenThrow(Exception('db error'));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileStarted()),
        expect: () => [
          const ProfileLoading(),
          ProfileError(failure: AppFailure.unknown(debugInfo: Exception('db error').toString())),
        ],
      );
    });

    group('ProfileRefreshed', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits [ProfileLoaded] without ProfileLoading on success',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => results);
          return buildBloc();
        },
        seed: () => const ProfileLoaded(
          gamesPlayed: 0,
          wins: 0,
          losses: 0,
          draws: 0,
          winRate: 0,
          totalEarnings: 0,
          achievements: _emptyAchievements,
          bestWinStreak: 0,
        ),
        act: (bloc) => bloc.add(const ProfileRefreshed()),
        expect: () => [isA<ProfileLoaded>()],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits nothing on failure (keeps current state)',
        build: () {
          when(() => mockLoadHistory()).thenThrow(Exception('db error'));
          return buildBloc();
        },
        seed: () => const ProfileLoaded(
          gamesPlayed: 0,
          wins: 0,
          losses: 0,
          draws: 0,
          winRate: 0,
          totalEarnings: 0,
          achievements: _emptyAchievements,
          bestWinStreak: 0,
        ),
        act: (bloc) => bloc.add(const ProfileRefreshed()),
        expect: () => [],
      );

      test('completes the completer on success', () async {
        when(() => mockLoadHistory()).thenAnswer((_) async => results);
        final bloc = buildBloc();
        final completer = Completer<void>();

        bloc.add(ProfileRefreshed(completer: completer));
        await completer.future;

        expect(completer.isCompleted, isTrue);
        await bloc.close();
      });

      test('completes the completer on failure', () async {
        when(() => mockLoadHistory()).thenThrow(Exception('db error'));
        final bloc = buildBloc();
        final completer = Completer<void>();

        bloc.add(ProfileRefreshed(completer: completer));
        await completer.future;

        expect(completer.isCompleted, isTrue);
        await bloc.close();
      });
    });

    group('achievement detection', () {
      blocTest<ProfileBloc, ProfileState>(
        'detects Speed Run when a fast win exists',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => [
                GameResultEntity(
                  result: GameStatus.redWins,
                  humanSide: PlayerSide.red,
                  aiLevel: 0.5,
                  betAmount: 10,
                  winnings: 25,
                  playedAt: DateTime(2026, 3, 1),
                  duration: const Duration(seconds: 25),
                  moveCount: 5,
                ),
              ]);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileStarted()),
        expect: () => [
          const ProfileLoading(),
          isA<ProfileLoaded>().having(
            (s) => s.achievements[AchievementType.speedRun],
            'speedRun',
            true,
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'detects Whale when win with high bet',
        build: () {
          when(() => mockLoadHistory()).thenAnswer((_) async => [
                GameResultEntity(
                  result: GameStatus.redWins,
                  humanSide: PlayerSide.red,
                  aiLevel: 1.0,
                  betAmount: 50,
                  winnings: 105,
                  playedAt: DateTime(2026, 3, 1),
                  duration: const Duration(minutes: 2),
                  moveCount: 7,
                ),
              ]);
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ProfileStarted()),
        expect: () => [
          const ProfileLoading(),
          isA<ProfileLoaded>().having(
            (s) => s.achievements[AchievementType.whale],
            'whale',
            true,
          ),
        ],
      );
    });
  });
}
