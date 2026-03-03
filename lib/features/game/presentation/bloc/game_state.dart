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
  final int? cashOutAmount;

  const GameInProgress({
    required this.game,
    this.isAiThinking = false,
    this.lastMoveIndex,
    this.cashOutAmount,
  });

  @override
  List<Object?> get props => [game, isAiThinking, lastMoveIndex, cashOutAmount];
}

class GameOver extends GameState {
  final GameEntity game;
  final List<int>? winningLine;
  final int? cashOutAmount;

  const GameOver({required this.game, this.winningLine, this.cashOutAmount});

  bool get isCashOut => cashOutAmount != null;

  @override
  List<Object?> get props => [game, winningLine, cashOutAmount];
}
