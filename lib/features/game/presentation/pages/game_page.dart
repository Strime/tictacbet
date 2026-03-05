import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_status.dart';
import '../extensions/player_side_ui.dart';
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
          isAllIn: params.isAllIn,
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
          backgroundColor: AppColors.feltGreen,
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
                  final int? cashOutAmount;
                  List<int>? winLine;

                  if (state is GameInProgress) {
                    game = state.game;
                    isAiThinking = state.isAiThinking;
                    lastMove = state.lastMoveIndex;
                    cashOutAmount = state.cashOutAmount;
                  } else if (state is GameOver) {
                    game = state.game;
                    isAiThinking = false;
                    lastMove = null;
                    cashOutAmount = null;
                    winLine = state.winningLine;
                  } else {
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: Responsive.boardMaxWidth,
                                ),
                                child: BoardWidget(
                                board: game.board,
                                humanSide: game.humanSide,
                                enabled: !isAiThinking && !game.isGameOver,
                                lastMoveIndex: lastMove,
                                winningLine: winLine,
                                betAmount: params.betAmount,
                                onCellTap: (row, col) {
                                  context.read<GameBloc>().add(
                                        CellTapped(row: row, col: col),
                                      );
                                },
                              ),
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
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: IgnorePointer(
                          ignoring: cashOutAmount == null,
                          child: AnimatedOpacity(
                            opacity: cashOutAmount != null ? 1.0 : 0.0,
                            duration: const Duration(
                              milliseconds: AppSpacing.animationFast,
                            ),
                            child: _CashOutButton(
                              amount: cashOutAmount ?? 0,
                              l10n: l10n,
                              onTap: () => _confirmCashOut(
                                context,
                                cashOutAmount ?? 0,
                                l10n,
                              ),
                            ),
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
      ),
    );
  }

  void _confirmCashOut(
    BuildContext context,
    int amount,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.game_cashOut_confirm_title),
        content: Text(l10n.game_cashOut_confirm_body(amount.toCurrency())),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.game_cashOut_confirm_no),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameBloc>().add(const GameCashedOut());
            },
            child: Text(l10n.game_cashOut_confirm_yes),
          ),
        ],
      ),
    );
  }

  void _showGameResult(
    BuildContext context,
    GameOver state,
    AppLocalizations l10n,
  ) {
    final game = state.game;
    final isCashOut = state.isCashOut;
    final isWin = !isCashOut && game.humanWon;
    final isDraw = !isCashOut && game.status == GameStatus.draw;
    final winnings = state.cashOutAmount ?? game.winnings;

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

    context.read<WalletBloc>().add(WalletGameSettled(winnings));
    context.read<ProgressionBloc>().add(
          ProgressionGameSettled(
            isWin: isWin,
            isDraw: isDraw,
            isCashOut: isCashOut,
            bonusXp: game.collectedXpBonus,
          ),
        );

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(
        maxWidth: Responsive.contentMaxWidth,
      ),
      builder: (_) => GameResultDialog(
        humanWon: isWin,
        isDraw: isDraw,
        isCashOut: isCashOut,
        betAmount: game.betAmount,
        l10n: l10n,
        winnings: winnings,
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

class _CashOutButton extends StatelessWidget {
  final int amount;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _CashOutButton({
    required this.amount,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          border: Border.all(
            color: AppColors.chipGold.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.arrowLeft,
              color: AppColors.chipGold,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${l10n.game_cashOut}  ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.chipGold,
                  ),
            ),
            Text(
              amount.toCurrency(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.chipGold,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
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
    final dotColor = currentPlayer.color;

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
            width: AppSpacing.iconXxs,
            height: AppSpacing.iconXxs,
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
