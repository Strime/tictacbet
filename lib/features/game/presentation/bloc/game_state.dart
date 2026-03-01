part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameInProgress extends GameState {
  final GameEntity game;
  final bool isAiThinking;
  final int? lastMoveIndex;

  const GameInProgress({
    required this.game,
    this.isAiThinking = false,
    this.lastMoveIndex,
  });

  @override
  List<Object?> get props => [game, isAiThinking, lastMoveIndex];
}

class GameOver extends GameState {
  final GameEntity game;
  final List<int>? winningLine;

  const GameOver({required this.game, this.winningLine});

  @override
  List<Object?> get props => [game, winningLine];
}
