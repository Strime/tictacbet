import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class BetAmountDisplay extends StatefulWidget {
  final int betAmount;
  final int remainingBalance;

  const BetAmountDisplay({
    super.key,
    required this.betAmount,
    required this.remainingBalance,
  });

  @override
  State<BetAmountDisplay> createState() => _BetAmountDisplayState();
}

class _BetAmountDisplayState extends State<BetAmountDisplay> {
  int _previousAmount = 1;

  @override
  void didUpdateWidget(BetAmountDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.betAmount != widget.betAmount) {
      _previousAmount = oldWidget.betAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.monetization_on,
              color: AppColors.chipGold,
              size: AppSpacing.iconXl,
            ),
            const SizedBox(width: AppSpacing.sm),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: _previousAmount, end: widget.betAmount),
              duration: const Duration(
                milliseconds: AppSpacing.animationMedium,
              ),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return Text(
                  '\$$value',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.chipGold,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Balance: \$${widget.remainingBalance}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
