part of 'history_bloc.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<GameResultEntity> results;

  const HistoryLoaded({required this.results});

  bool get isEmpty => results.isEmpty;

  @override
  List<Object?> get props => [results];
}

class HistoryError extends HistoryState {
  final AppFailure failure;

  const HistoryError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
