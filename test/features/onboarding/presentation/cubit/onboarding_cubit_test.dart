import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictacbet/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:tictacbet/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late MockOnboardingLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOnboardingLocalDataSource();
  });

  OnboardingCubit buildCubit() => OnboardingCubit(mockDataSource);

  group('OnboardingCubit', () {
    test('initial state is OnboardingInProgress with step bet', () {
      expect(
        buildCubit().state,
        equals(const OnboardingInProgress(step: OnboardingStep.bet)),
      );
    });

    group('advanceFromBet', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingInProgress with step play and betAmount',
        build: buildCubit,
        act: (cubit) => cubit.advanceFromBet(50),
        expect: () => [
          const OnboardingInProgress(step: OnboardingStep.play, betAmount: 50),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'does nothing when not on bet step',
        build: buildCubit,
        seed: () =>
            const OnboardingInProgress(step: OnboardingStep.card),
        act: (cubit) => cubit.advanceFromBet(50),
        expect: () => [],
      );
    });

    group('advanceFromPlay', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingInProgress with step card and preserves betAmount',
        build: buildCubit,
        seed: () =>
            const OnboardingInProgress(step: OnboardingStep.play, betAmount: 30),
        act: (cubit) => cubit.advanceFromPlay(),
        expect: () => [
          const OnboardingInProgress(
              step: OnboardingStep.card, betAmount: 30),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'does nothing when not on play step',
        build: buildCubit,
        act: (cubit) => cubit.advanceFromPlay(),
        expect: () => [],
      );
    });

    group('advanceFromCard', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'emits OnboardingInProgress with step achievements',
        build: buildCubit,
        seed: () =>
            const OnboardingInProgress(step: OnboardingStep.card, betAmount: 20),
        act: (cubit) => cubit.advanceFromCard(),
        expect: () => [
          const OnboardingInProgress(
              step: OnboardingStep.achievements, betAmount: 20),
        ],
      );

      blocTest<OnboardingCubit, OnboardingState>(
        'does nothing when not on card step',
        build: buildCubit,
        seed: () =>
            const OnboardingInProgress(step: OnboardingStep.bet),
        act: (cubit) => cubit.advanceFromCard(),
        expect: () => [],
      );
    });

    group('complete', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'calls setCompleted and emits OnboardingCompleted',
        build: () {
          when(() => mockDataSource.setCompleted(true))
              .thenAnswer((_) async {});
          return buildCubit();
        },
        act: (cubit) => cubit.complete(),
        expect: () => [const OnboardingCompleted()],
        verify: (_) {
          verify(() => mockDataSource.setCompleted(true)).called(1);
        },
      );
    });
  });
}
