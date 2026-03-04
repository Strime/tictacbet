import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/onboarding_local_data_source.dart';

part 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingLocalDataSource _dataSource;

  static const int maxBet = 100;

  OnboardingCubit(this._dataSource)
      : super(const OnboardingInProgress());

  void advanceFromBet(int betAmount) {
    final current = state;
    if (current is OnboardingInProgress &&
        current.step == OnboardingStep.bet) {
      emit(OnboardingInProgress(
          step: OnboardingStep.play, betAmount: betAmount));
    }
  }

  void advanceFromPlay() {
    final current = state;
    if (current is OnboardingInProgress &&
        current.step == OnboardingStep.play) {
      emit(OnboardingInProgress(
          step: OnboardingStep.card, betAmount: current.betAmount));
    }
  }

  void advanceFromCard() {
    final current = state;
    if (current is OnboardingInProgress &&
        current.step == OnboardingStep.card) {
      emit(OnboardingInProgress(
          step: OnboardingStep.achievements, betAmount: current.betAmount));
    }
  }

  Future<void> complete() async {
    await _dataSource.setCompleted(true);
    emit(const OnboardingCompleted());
  }
}
