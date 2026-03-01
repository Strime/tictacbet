part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// Start a new game with the given parameters.
class GameStarted extends GameEvent {
  final PlayerSide humanSide;
  final double aiLevel;
  final int betAmount;

  const GameStarted({
    required this.humanSide,
    required this.aiLevel,
    required this.betAmount,
  });

  @override
  List<Object?> get props => [humanSide, aiLevel, betAmount];
}

/// Human taps a cell on the board.
class CellTapped extends GameEvent {
  final int row;
  final int col;

  const CellTapped({required this.row, required this.col});

  @override
  List<Object?> get props => [row, col];
}

/// Reset to initial state.
class GameReset extends GameEvent {
  const GameReset();
}
