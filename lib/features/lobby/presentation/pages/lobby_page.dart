import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
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
      create: (_) => getIt<LobbyBloc>(),
      child: const _LobbyView(),
    );
  }
}

class _LobbyView extends StatelessWidget {
  const _LobbyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: BlocBuilder<LobbyBloc, LobbyState>(
        builder: (context, state) {
          if (state is! LobbyReady) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.lobby_title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.chipGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Camp selection
                Text(
                  l10n.lobby_selectCamp,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                CampSelectionWidget(
                  selectedSide: state.selectedSide,
                  onSideChanged: (side) {
                    context.read<LobbyBloc>().add(LobbySideChanged(side));
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Bet amount display
                Text(
                  l10n.lobby_placeBet,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                BetAmountDisplay(
                  betAmount: state.betAmount,
                  remainingBalance: state.remainingBalance,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Chip selector
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
                const SizedBox(height: AppSpacing.xl),

                // Potential winnings
                PotentialWinningsWidget(
                  potentialWinnings: state.potentialWinnings,
                ),
                const SizedBox(height: AppSpacing.lg),

                // AI difficulty gauge
                AiDifficultyGauge(
                  aiLevel: state.aiLevel,
                  label: state.aiDifficultyLabel,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Play button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.push(
                        AppRoutes.game,
                        extra: GameParams(
                          humanSide: state.selectedSide,
                          aiLevel: state.aiLevel,
                          betAmount: state.betAmount,
                        ),
                      );
                    },
                    child: Text('${l10n.lobby_play} — \$${state.betAmount}'),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(
                      delay: 2.seconds,
                      duration: 1.5.seconds,
                      color: AppColors.chipGold.withValues(alpha: 0.15),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
