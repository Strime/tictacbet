import 'package:flutter/material.dart';

import '../../../../core/config/game_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../lobby/presentation/widgets/bet_amount_display.dart';
import '../../../lobby/presentation/widgets/floating_bet_bar.dart';

class StepPlayPreview extends StatelessWidget {
  final int betAmount;
  final int maxBet;
  final VoidCallback onStepCompleted;

  const StepPlayPreview({
    super.key,
    required this.betAmount,
    required this.maxBet,
    required this.onStepCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final potentialWinnings =
        GameConstants.winBonusBase + betAmount * GameConstants.winBetMultiplier;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BetAmountDisplay(
          betAmount: betAmount,
          remainingBalance: maxBet - betAmount,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: FloatingBetBar(
            betAmount: betAmount,
            potentialWinnings: potentialWinnings,
            canPlay: true,
            onPlay: onStepCompleted,
          ),
        ),
      ],
    );
  }
}
