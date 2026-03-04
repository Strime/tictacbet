import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../domain/entities/progression_entity.dart';
import '../../domain/usecases/load_progression_use_case.dart';
import '../../domain/usecases/save_progression_use_case.dart';

part 'progression_event.dart';
part 'progression_state.dart';

@lazySingleton
class ProgressionBloc extends Bloc<ProgressionEvent, ProgressionState> {
  final LoadProgressionUseCase _loadProgression;
  final SaveProgressionUseCase _saveProgression;

  ProgressionBloc(this._loadProgression, this._saveProgression)
      : super(const ProgressionInitial()) {
    on<ProgressionStarted>(_onStarted);
    on<ProgressionGameSettled>(_onGameSettled);
  }

  Future<void> _onStarted(
    ProgressionStarted event,
    Emitter<ProgressionState> emit,
  ) async {
    try {
      final progression = await _loadProgression();
      if (isClosed) return;
      emit(ProgressionLoaded(progression: progression));
    } catch (_) {
      if (isClosed) return;
      emit(const ProgressionLoaded(progression: ProgressionEntity()));
    }
  }

  Future<void> _onGameSettled(
    ProgressionGameSettled event,
    Emitter<ProgressionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProgressionLoaded) return;

    final old = currentState.progression;
    final oldLevel = old.level;

    // Update streak
    final int newStreak;
    if (event.isWin) {
      newStreak = old.currentWinStreak + 1;
    } else if (event.isCashOut) {
      newStreak = old.currentWinStreak; // preserve streak on cash out
    } else {
      newStreak = 0;
    }

    // Calculate XP earned (multiplier applies to the streak BEFORE this win)
    final int baseXp;
    if (event.isWin) {
      baseXp = GameConstants.xpPerWin;
    } else if (event.isCashOut) {
      baseXp = GameConstants.xpPerCashOut;
    } else if (event.isDraw) {
      baseXp = GameConstants.xpPerDraw;
    } else {
      baseXp = GameConstants.xpPerLoss;
    }

    final multiplier = event.isWin
        ? GameConstants.streakMultiplier(newStreak)
        : 1.0;
    final xpEarned = (baseXp * multiplier).round() + event.bonusXp;

    final updated = old.copyWith(
      totalXp: old.totalXp + xpEarned,
      currentWinStreak: newStreak,
      bestWinStreak:
          newStreak > old.bestWinStreak ? newStreak : old.bestWinStreak,
    );

    emit(ProgressionLoaded(
      progression: updated,
      xpEarned: xpEarned,
      leveledUp: updated.level > oldLevel,
    ));
    try {
      await _saveProgression(updated);
    } catch (_) {
      // Save is best-effort; state is already emitted
    }
  }
}
