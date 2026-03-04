import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_step_indicator.dart';
import '../widgets/step_bet_preview.dart';
import '../widgets/step_card_preview.dart';
import '../widgets/step_achievement_preview.dart';
import '../widgets/step_play_preview.dart';

class OnboardingPage extends StatelessWidget {
  final VoidCallback onComplete;

  const OnboardingPage({super.key, required this.onComplete});

  static String _titleFor(OnboardingStep step, AppLocalizations l10n) =>
      switch (step) {
        OnboardingStep.bet => l10n.onboarding_stepBet_title,
        OnboardingStep.play => l10n.onboarding_stepPlay_title,
        OnboardingStep.card => l10n.onboarding_stepCard_title,
        OnboardingStep.achievements => l10n.onboarding_stepAchievements_title,
      };

  static String _descriptionFor(OnboardingStep step, AppLocalizations l10n) =>
      switch (step) {
        OnboardingStep.bet => l10n.onboarding_stepBet_desc,
        OnboardingStep.play => l10n.onboarding_stepPlay_desc,
        OnboardingStep.card => l10n.onboarding_stepCard_desc,
        OnboardingStep.achievements => l10n.onboarding_stepAchievements_desc,
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          onComplete();
        }
      },
      child: DecoratedBox(
        decoration: AppDecorations.backgroundGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                final step = switch (state) {
                  OnboardingInProgress(:final step) => step,
                  _ => OnboardingStep.achievements,
                };
                final betAmount = switch (state) {
                  OnboardingInProgress(:final betAmount) => betAmount,
                  _ => 0,
                };
                final l10n = AppLocalizations.of(context)!;
                return Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Stepper
                    OnboardingStepIndicator(
                      currentStep: step.index,
                      totalSteps: OnboardingStep.values.length,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Title
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: AppSpacing.animationMedium,
                      ),
                      transitionBuilder: _slideTransition,
                      child: Text(
                        _titleFor(step, l10n),
                        key: ValueKey('step_$step'),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.chipGold,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Preview area
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: AppSpacing.animationSlow,
                        ),
                        child: _buildStepPreview(context, step, betAmount),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Description
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: AppSpacing.animationMedium,
                      ),
                      transitionBuilder: _slideTransition,
                      child: Text(
                        _descriptionFor(step, l10n),
                        key: ValueKey('desc_$step'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepPreview(
      BuildContext context, OnboardingStep step, int betAmount) {
    final cubit = context.read<OnboardingCubit>();

    return switch (step) {
      OnboardingStep.bet => StepBetPreview(
          key: const ValueKey(OnboardingStep.bet),
          maxBet: OnboardingCubit.maxBet,
          onStepCompleted: cubit.advanceFromBet,
        ),
      OnboardingStep.play => StepPlayPreview(
          key: const ValueKey(OnboardingStep.play),
          betAmount: betAmount,
          maxBet: OnboardingCubit.maxBet,
          onStepCompleted: cubit.advanceFromPlay,
        ),
      OnboardingStep.card => StepCardPreview(
          key: const ValueKey(OnboardingStep.card),
          onStepCompleted: cubit.advanceFromCard,
        ),
      OnboardingStep.achievements => StepAchievementPreview(
          key: const ValueKey(OnboardingStep.achievements),
          onStepCompleted: cubit.complete,
        ),
    };
  }

  static Widget _slideTransition(
      Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        ),
        child: child,
      ),
    );
  }
}
