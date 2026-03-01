import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/game_constants.dart';
import '../../../ai/domain/usecases/compute_ai_move_use_case.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/player_side.dart';
import '../../domain/usecases/generate_board_use_case.dart';
import '../../domain/usecases/play_move_use_case.dart';

part 'game_event.dart';
part 'game_state.dart';

@injectable
class GameBloc extends Bloc<GameEvent, GameState> {
  final GenerateBoardUseCase _generateBoard;
  final PlayMoveUseCase _playMove;
  final ComputeAiMoveUseCase _computeAiMove;

  GameBloc(
    this._generateBoard,
    this._playMove,
    this._computeAiMove,
  ) : super(const GameInitial()) {
    on<GameStarted>(_onGameStarted);
    on<CellTapped>(_onCellTapped);
    on<GameReset>(_onGameReset);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    final board = _generateBoard();
    final game = GameEntity(
      board: board,
      humanSide: event.humanSide,
      aiLevel: event.aiLevel,
      betAmount: event.betAmount,
      startedAt: DateTime.now(),
    );
    emit(GameInProgress(game: game));
  }

  Future<void> _onCellTapped(
    CellTapped event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    if (currentState is! GameInProgress || currentState.isAiThinking) return;

    final game = currentState.game;
    if (!game.isHumanTurn) return;

    // Human move
    final newBoard = _playMove(game.board, event.row, event.col);
    if (newBoard == null) return;

    final updatedGame = game.copyWith(board: newBoard);
    final moveIndex = event.row * 3 + event.col;

    if (updatedGame.isGameOver) {
      emit(GameOver(
        game: updatedGame.copyWith(endedAt: DateTime.now()),
        winningLine: updatedGame.board.winningLine,
      ));
      return;
    }

    // Show board after human move, AI thinking
    emit(GameInProgress(
      game: updatedGame,
      isAiThinking: true,
      lastMoveIndex: moveIndex,
    ));

    // AI delay for UX
    await Future.delayed(GameConstants.aiMoveDelay);
    if (isClosed) return;

    // AI move
    final aiMoveIndex = _computeAiMove(updatedGame.board, game.aiLevel);
    final aiRow = aiMoveIndex ~/ 3;
    final aiCol = aiMoveIndex % 3;
    final boardAfterAi = _playMove(updatedGame.board, aiRow, aiCol);

    if (boardAfterAi == null) return;

    final gameAfterAi = updatedGame.copyWith(board: boardAfterAi);

    if (gameAfterAi.isGameOver) {
      emit(GameOver(
        game: gameAfterAi.copyWith(endedAt: DateTime.now()),
        winningLine: gameAfterAi.board.winningLine,
      ));
      return;
    }

    emit(GameInProgress(
      game: gameAfterAi,
      isAiThinking: false,
      lastMoveIndex: aiMoveIndex,
    ));
  }

  void _onGameReset(GameReset event, Emitter<GameState> emit) {
    emit(const GameInitial());
  }
}
