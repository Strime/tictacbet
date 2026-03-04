part of 'onboarding_cubit.dart';

enum OnboardingStep { bet, play, card, achievements }

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInProgress extends OnboardingState {
  final OnboardingStep step;
  final int betAmount;

  const OnboardingInProgress({
    this.step = OnboardingStep.bet,
    this.betAmount = 0,
  });

  @override
  List<Object?> get props => [step, betAmount];
}

class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
