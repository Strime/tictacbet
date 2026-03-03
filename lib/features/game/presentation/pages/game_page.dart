import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_status.dart';
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

    return BlocListener<GameBloc, GameState>(
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
                    _StatusBar(
                      game: game,
                      isAiThinking: isAiThinking,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.chipGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
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
                  ],
                );
              },
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

class _StatusBar extends StatelessWidget {
  final GameEntity game;
  final bool isAiThinking;
  final AppLocalizations l10n;

  const _StatusBar({
    required this.game,
    required this.isAiThinking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
        Text(
          statusText,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (isAiThinking)
          const SizedBox(
            width: AppSpacing.iconMd,
            height: AppSpacing.iconMd,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          const SizedBox(width: AppSpacing.iconMd),
      ],
    );
  }
}
