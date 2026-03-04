import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../lobby/presentation/widgets/bet_amount_display.dart';
import '../../../lobby/presentation/widgets/bet_chip_selector_widget.dart';

class StepBetPreview extends StatefulWidget {
  final int maxBet;
  final void Function(int betAmount) onStepCompleted;

  const StepBetPreview({
    super.key,
    required this.maxBet,
    required this.onStepCompleted,
  });

  @override
  State<StepBetPreview> createState() => _StepBetPreviewState();
}

class _StepBetPreviewState extends State<StepBetPreview> {
  int _betAmount = 0;
  bool _completed = false;

  void _completeStep() {
    if (_completed) return;
    _completed = true;
    Future.delayed(
      const Duration(milliseconds: AppSpacing.animationMedium),
      () {
        if (mounted) widget.onStepCompleted(_betAmount);
      },
    );
  }

  void _onChipAdded(int amount, Offset _) {
    setState(
        () => _betAmount = (_betAmount + amount).clamp(0, widget.maxBet));
    if (_betAmount > 0) _completeStep();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BetAmountDisplay(
          betAmount: _betAmount,
          remainingBalance: widget.maxBet - _betAmount,
        ),
        const SizedBox(height: AppSpacing.xl),
        BetChipSelectorWidget(
          currentBet: _betAmount,
          maxBet: widget.maxBet,
          onAdd: _onChipAdded,
          onReset: () => setState(() => _betAmount = 0),
          onMax: () {
            setState(() => _betAmount = widget.maxBet);
            _completeStep();
          },
        ),
      ],
    );
  }
}
