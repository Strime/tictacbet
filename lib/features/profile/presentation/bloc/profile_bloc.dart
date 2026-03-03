import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/services/achievement_detector.dart';
import '../../../history/domain/entities/game_result_entity.dart';
import '../../../history/domain/usecases/load_history_use_case.dart';
import '../../../progression/domain/usecases/load_progression_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LoadHistoryUseCase _loadHistory;
  final LoadProgressionUseCase _loadProgression;

  ProfileBloc(this._loadHistory, this._loadProgression)
      : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final results = await _loadHistory();
      if (isClosed) return;
      final stats = await _computeStats(results);
      if (stats != null) emit(stats);
    } catch (e) {
      emit(ProfileError(failure: AppFailure.unknown(debugInfo: e.toString())));
    }
  }

  Future<void> _onRefreshed(
    ProfileRefreshed event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final results = await _loadHistory();
      if (isClosed) return;
      final stats = await _computeStats(results);
      if (stats != null) emit(stats);
    } catch (_) {
      // Silently keep current state on refresh failure
    } finally {
      event.completer?.complete();
    }
  }

  Future<ProfileLoaded?> _computeStats(List<GameResultEntity> results) async {
    final wins = results.where((r) => r.isWin).length;
    final draws = results.where((r) => r.isDraw).length;
    final losses = results.where((r) => r.isLoss).length;
    final cashOuts = results.where((r) => r.isCashOut).length;
    final gamesPlayed = results.length;
    final winRate =
        gamesPlayed > 0 ? (wins / gamesPlayed) * 100 : 0.0;
    final totalEarnings =
        results.fold<int>(0, (sum, r) => sum + r.netAmount);
    final progression = await _loadProgression();
    if (isClosed) return null;

    return ProfileLoaded(
      gamesPlayed: gamesPlayed,
      wins: wins,
      losses: losses,
      draws: draws,
      cashOuts: cashOuts,
      winRate: winRate,
      totalEarnings: totalEarnings,
      achievements: detectAchievements(results),
      bestWinStreak: progression.bestWinStreak,
    );
  }
}
