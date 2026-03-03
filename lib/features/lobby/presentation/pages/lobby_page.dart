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
import '../widgets/potential_winnings_widget.dart';

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

class _LobbyView extends StatelessWidget {
  const _LobbyView();

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
      child: SafeArea(
        child: BlocBuilder<LobbyBloc, LobbyState>(
          builder: (context, state) {
            if (state is! LobbyReady) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              children: [
                Text(
                  l10n.lobby_title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Camp selection
                CampSelectionWidget(
                  selectedSide: state.selectedSide,
                  onSideChanged: (side) {
                    context.read<LobbyBloc>().add(LobbySideChanged(side));
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Bet amount + chips
                BetAmountDisplay(
                  betAmount: state.betAmount,
                  remainingBalance: state.remainingBalance,
                ),
                const SizedBox(height: AppSpacing.md),
                BetChipSelectorWidget(
                  currentBet: state.betAmount,
                  maxBet: state.maxBet,
                  onAdd: (amount) {
                    context.read<LobbyBloc>().add(LobbyBetAdded(amount));
                  },
                  onReset: () {
                    context.read<LobbyBloc>().add(const LobbyBetReset());
                  },
                  onMax: () {
                    context.read<LobbyBloc>().add(const LobbyBetMaxed());
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Potential winnings + AI difficulty
                PotentialWinningsWidget(
                  potentialWinnings: state.potentialWinnings,
                ),
                const SizedBox(height: AppSpacing.md),
                AiDifficultyGauge(
                  aiLevel: state.aiLevel,
                  label: switch (state.aiDifficulty) {
                    AiDifficulty.easy => l10n.lobby_difficulty_easy,
                    AiDifficulty.medium => l10n.lobby_difficulty_medium,
                    AiDifficulty.hard => l10n.lobby_difficulty_hard,
                    AiDifficulty.expert => l10n.lobby_difficulty_expert,
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Play button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.betAmount > 0
                        ? () {
                            HapticFeedback.mediumImpact();
                            context.read<WalletBloc>().add(
                              WalletBetPlaced(state.betAmount),
                            );
                            context.push(
                              AppRoutes.game,
                              extra: GameParams(
                                humanSide: state.selectedSide,
                                aiLevel: state.aiLevel,
                                betAmount: state.betAmount,
                              ),
                            );
                          }
                        : null,
                    child: Text(l10n.lobby_playWithBet(state.betAmount)),
                  ),
                ),
              ],
            ),
          );
          },
        ),
      ),
    );
  }
}
