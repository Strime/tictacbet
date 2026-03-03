import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_status.dart';
import '../../domain/entities/player_side.dart';
import '../bloc/game_bloc.dart';
import '../widgets/board_widget.dart';
import '../widgets/game_result_dialog.dart';

class GamePage extends StatelessWidget {
  final GameParams params;

  const GamePage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameBloc>()
        ..add(GameStarted(
          humanSide: params.humanSide,
          aiLevel: params.aiLevel,
          betAmount: params.betAmount,
        )),
      child: _GameView(params: params),
    );
  }
}

class _GameView extends StatelessWidget {
  final GameParams params;

  const _GameView({required this.params});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameOver) {
            _showGameResult(context, state, l10n);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  if (state is GameInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final GameEntity game;
                  final bool isAiThinking;
                  final int? lastMove;
                  List<int>? winLine;

                  if (state is GameInProgress) {
                    game = state.game;
                    isAiThinking = state.isAiThinking;
                    lastMove = state.lastMoveIndex;
                  } else if (state is GameOver) {
                    game = state.game;
                    isAiThinking = false;
                    lastMove = null;
                    winLine = state.winningLine;
                  } else {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Text(
                          l10n.history_bet(params.betAmount),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.chipGold,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: BoardWidget(
                            board: game.board,
                            enabled: !isAiThinking && !game.isGameOver,
                            lastMoveIndex: lastMove,
                            winningLine: winLine,
                            onCellTap: (row, col) {
                              context.read<GameBloc>().add(
                                    CellTapped(row: row, col: col),
                                  );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _TurnIndicator(
                        game: game,
                        isAiThinking: isAiThinking,
                        l10n: l10n,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showGameResult(
    BuildContext context,
    GameOver state,
    AppLocalizations l10n,
  ) {
    final game = state.game;
    final isWin = game.humanWon;
    final isDraw = game.status == GameStatus.draw;

    // Capture progression state BEFORE dispatching the event
    final progressionState = context.read<ProgressionBloc>().state;
    final double previousProgressFraction;
    final int previousLevel;
    if (progressionState is ProgressionLoaded) {
      previousProgressFraction = progressionState.progression.progressFraction;
      previousLevel = progressionState.progression.level;
    } else {
      previousProgressFraction = 0.0;
      previousLevel = 0;
    }

    context.read<WalletBloc>().add(WalletGameSettled(game.winnings));
    context.read<ProgressionBloc>().add(
          ProgressionGameSettled(isWin: isWin, isDraw: isDraw),
        );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => GameResultDialog(
        humanWon: isWin,
        isDraw: isDraw,
        betAmount: game.betAmount,
        l10n: l10n,
        winnings: game.winnings,
        previousProgressFraction: previousProgressFraction,
        previousLevel: previousLevel,
        onPlayAgain: () {
          Navigator.of(context).pop();
          context.pop();
        },
      ),
    );
  }
}

class _TurnIndicator extends StatelessWidget {
  final GameEntity game;
  final bool isAiThinking;
  final AppLocalizations l10n;

  const _TurnIndicator({
    required this.game,
    required this.isAiThinking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final String statusText;
    if (game.isGameOver) {
      statusText = switch (game.status) {
        GameStatus.redWins => l10n.game_result_redWins,
        GameStatus.blackWins => l10n.game_result_blackWins,
        GameStatus.draw => l10n.game_result_draw,
        _ => '',
      };
    } else if (isAiThinking) {
      statusText = l10n.game_aiTurn;
    } else {
      statusText = l10n.game_yourTurn;
    }

    final currentPlayer = game.board.currentPlayer;
    final dotColor = currentPlayer == PlayerSide.red
        ? AppColors.heartRed
        : AppColors.spadeBlack;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.iconSm,
            height: AppSpacing.iconSm,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            statusText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (isAiThinking) ...[
            const SizedBox(width: AppSpacing.sm),
            const SizedBox(
              width: AppSpacing.iconSm,
              height: AppSpacing.iconSm,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }
}
