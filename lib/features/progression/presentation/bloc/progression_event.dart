part of 'progression_bloc.dart';

sealed class ProgressionEvent extends Equatable {
  const ProgressionEvent();

  @override
  List<Object?> get props => [];
}

/// Load progression data from persistence.
class ProgressionStarted extends ProgressionEvent {
  const ProgressionStarted();
}

/// Update XP and streak after a game ends.
class ProgressionGameSettled extends ProgressionEvent {
  final bool isWin;
  final bool isDraw;

  const ProgressionGameSettled({required this.isWin, required this.isDraw});

  @override
  List<Object?> get props => [isWin, isDraw];
}
