import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../bloc/lobby_bloc.dart';
import '../widgets/ai_difficulty_gauge.dart';
import '../widgets/bet_amount_display.dart';
import '../widgets/bet_chip_selector_widget.dart';
import '../widgets/camp_selection_widget.dart';
import '../widgets/coin_drop_overlay.dart';
import '../widgets/floating_bet_bar.dart';
import '../widgets/play_expand_overlay.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final lobbyBloc = getIt<LobbyBloc>();
        final walletState = context.read<WalletBloc>().state;
        if (walletState is WalletLoaded) {
          lobbyBloc.add(LobbyInitialized(playerBalance: walletState.balance));
        }
        return lobbyBloc;
      },
      child: const _LobbyView(),
    );
  }
}

class _LobbyView extends StatefulWidget {
  const _LobbyView();

  @override
  State<_LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<_LobbyView> {
  final _barKey = GlobalKey();
  OverlayEntry? _expandOverlay;

  @override
  void dispose() {
    _expandOverlay?.remove();
    super.dispose();
  }

  void _onChipAdded(int amount, Offset chipCenter) {
    context.read<LobbyBloc>().add(LobbyBetAdded(amount));

    final barBox = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (barBox == null) return;
    final barCenter = barBox.localToGlobal(
      Offset(barBox.size.width / 2, barBox.size.height / 2),
    );

    showCoinDrop(context: context, from: chipCenter, to: barCenter, amount: amount);
  }

  void _onPlay(LobbyReady state) {
    HapticFeedback.mediumImpact();

    context.read<WalletBloc>().add(WalletBetPlaced(state.betAmount));

    final barBox = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (barBox == null) return;
    final barTopLeft = barBox.localToGlobal(Offset.zero);
    final barRect = barTopLeft & barBox.size;

    _expandOverlay = showPlayExpandOverlay(
      context: context,
      fromRect: barRect,
      betAmount: state.betAmount,
      onExpanded: () {
        context.push(
          AppRoutes.game,
          extra: GameParams(
            humanSide: state.selectedSide,
            aiLevel: state.aiLevel,
            betAmount: state.betAmount,
          ),
        );
      },
      onComplete: () {
        _expandOverlay?.remove();
        _expandOverlay = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<WalletBloc, WalletState>(
      listener: (context, walletState) {
        if (walletState is WalletLoaded) {
          context.read<LobbyBloc>().add(
                LobbyInitialized(playerBalance: walletState.balance),
              );
        }
      },
      child: BlocBuilder<LobbyBloc, LobbyState>(
        builder: (context, state) {
          if (state is! LobbyReady) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.lobby_title,
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Camp selection
                      CampSelectionWidget(
                        selectedSide: state.selectedSide,
                        onSideChanged: (side) {
                          context
                              .read<LobbyBloc>()
                              .add(LobbySideChanged(side));
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Bet amount + chips
                      BetAmountDisplay(
                        remainingBalance: state.remainingBalance,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      BetChipSelectorWidget(
                        currentBet: state.betAmount,
                        maxBet: state.maxBet,
                        onAdd: _onChipAdded,
                        onReset: () {
                          context
                              .read<LobbyBloc>()
                              .add(const LobbyBetReset());
                        },
                        onMax: (center) {
                          final remaining = state.remainingBalance;
                          context
                              .read<LobbyBloc>()
                              .add(const LobbyBetMaxed());

                          if (remaining > 0) {
                            final barBox = _barKey.currentContext
                                ?.findRenderObject() as RenderBox?;
                            if (barBox == null) return;
                            final barCenter = barBox.localToGlobal(
                              Offset(
                                barBox.size.width / 2,
                                barBox.size.height / 2,
                              ),
                            );
                            showCoinDrop(
                              context: context,
                              from: center,
                              to: barCenter,
                              amount: remaining,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // AI difficulty
                      AiDifficultyGauge(
                        aiLevel: state.aiLevel,
                        label: switch (state.aiDifficulty) {
                          AiDifficulty.easy => l10n.lobby_difficulty_easy,
                          AiDifficulty.medium => l10n.lobby_difficulty_medium,
                          AiDifficulty.hard => l10n.lobby_difficulty_hard,
                          AiDifficulty.expert => l10n.lobby_difficulty_expert,
                        },
                      ),

                      // Bottom clearance for floating bar
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Floating bet bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: FloatingBetBar(
                    key: _barKey,
                    betAmount: state.betAmount,
                    canPlay: state.betAmount > 0,
                    onPlay: () => _onPlay(state),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
