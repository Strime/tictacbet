import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/game_result_entity.dart';
import '../../domain/usecases/load_history_use_case.dart';

part 'history_event.dart';
part 'history_state.dart';

@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final LoadHistoryUseCase _loadHistory;

  HistoryBloc(this._loadHistory) : super(const HistoryInitial()) {
    on<HistoryStarted>(_onStarted);
    on<HistoryRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    HistoryStarted event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      final results = await _loadHistory();
      emit(HistoryLoaded(results: results));
    } catch (_) {
      emit(const HistoryError());
    }
  }

  Future<void> _onRefreshed(
    HistoryRefreshed event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      final results = await _loadHistory();
      emit(HistoryLoaded(results: results));
    } catch (_) {
      // Silently keep current state on refresh failure
    } finally {
      event.completer?.complete();
    }
  }
}
