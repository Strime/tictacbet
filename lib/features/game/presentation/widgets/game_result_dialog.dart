import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/config/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';

class GameResultDialog extends StatelessWidget {
  final bool humanWon;
  final bool isDraw;
  final bool isCashOut;
  final int betAmount;
  final AppLocalizations l10n;
  final VoidCallback onPlayAgain;
  final int winnings;
  final double previousProgressFraction;
  final int previousLevel;

  const GameResultDialog({
    super.key,
    required this.humanWon,
    required this.isDraw,
    this.isCashOut = false,
    required this.betAmount,
    required this.l10n,
    required this.onPlayAgain,
    required this.winnings,
    required this.previousProgressFraction,
    required this.previousLevel,
  });

  @override
  Widget build(BuildContext context) {
    final resultText = isCashOut
        ? l10n.game_result_cashOut
        : humanWon
            ? l10n.game_result_win
            : isDraw
                ? l10n.game_result_draw
                : l10n.game_result_loss;

    final resultColor = isCashOut
        ? AppColors.chipGold
        : humanWon
            ? AppColors.success
            : isDraw
                ? AppColors.chipGold
                : AppColors.error;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.dragHandleWidth,
            height: AppSpacing.dragHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSpacing.xxs),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            resultText,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: resultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _WinningsText(
            humanWon: humanWon,
            isDraw: isDraw,
            isCashOut: isCashOut,
            winnings: winnings,
            betAmount: betAmount,
          ),
          const SizedBox(height: AppSpacing.lg),
          _XpSection(
            l10n: l10n,
            previousProgressFraction: previousProgressFraction,
            previousLevel: previousLevel,
          ),
          const SizedBox(height: AppSpacing.xl),
          _DelayedPlayAgainButton(onPlayAgain: onPlayAgain, l10n: l10n),
        ],
      ),
    );
  }
}

class _WinningsText extends StatefulWidget {
  final bool humanWon;
  final bool isDraw;
  final bool isCashOut;
  final int winnings;
  final int betAmount;

  const _WinningsText({
    required this.humanWon,
    required this.isDraw,
    this.isCashOut = false,
    required this.winnings,
    required this.betAmount,
  });

  @override
  State<_WinningsText> createState() => _WinningsTextState();
}

class _WinningsTextState extends State<_WinningsText> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _started = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    if (widget.isDraw && !widget.isCashOut) {
      return AnimatedOpacity(
        opacity: _started ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          0.toCurrency(),
          style: style?.copyWith(color: AppColors.chipGold),
        ),
      );
    }

    final int targetValue;
    final Color color;
    final bool isPositive;

    if (widget.isCashOut) {
      targetValue = widget.winnings;
      isPositive = true;
      color = AppColors.chipGold;
    } else if (widget.humanWon) {
      targetValue = widget.winnings - widget.betAmount;
      isPositive = true;
      color = AppColors.success;
    } else {
      targetValue = widget.betAmount;
      isPositive = false;
      color = AppColors.error;
    }

    return AnimatedOpacity(
      opacity: _started ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: _started ? targetValue : 0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        builder: (context, value, _) {
          final text = isPositive
              ? '+${value.toCurrency()}'
              : '-${value.toCurrency()}';
          return Text(
            text,
            style: style?.copyWith(color: color),
          );
        },
      ),
    );
  }
}

class _XpSection extends StatefulWidget {
  final AppLocalizations l10n;
  final double previousProgressFraction;
  final int previousLevel;

  const _XpSection({
    required this.l10n,
    required this.previousProgressFraction,
    required this.previousLevel,
  });

  @override
  State<_XpSection> createState() => _XpSectionState();
}

class _XpSectionState extends State<_XpSection> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _started = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProgressionBloc, ProgressionState>(
      builder: (context, state) {
        if (state is! ProgressionLoaded) {
          return const SizedBox.shrink();
        }
        final progression = state.progression;
        final xpEarned = state.xpEarned ?? 0;
        final streak = progression.currentWinStreak;
        final multiplier = GameConstants.streakMultiplier(streak);
        final didLevelUp = state.leveledUp;

        return AnimatedOpacity(
          opacity: _started ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: _started ? xpEarned : 0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (context, value, _) {
                  return Text(
                    widget.l10n.game_result_xpEarned(value),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.xpColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              if (streak >= 2) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.flame,
                      size: AppSpacing.iconSm,
                      color: AppColors.chipGold,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      widget.l10n.game_result_winStreak(streak),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.chipGold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      widget.l10n.game_result_streakBonus(
                        multiplier.toStringAsFixed(1),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.xpColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _AnimatedXpBar(
                fromFraction: didLevelUp ? 0.0 : widget.previousProgressFraction,
                toFraction: progression.progressFraction,
                started: _started,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.l10n.profile_levelXp(
                  progression.level,
                  progression.totalXp - progression.xpForCurrentLevel,
                  progression.xpForNextLevel - progression.xpForCurrentLevel,
                ),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (didLevelUp) ...[
                const SizedBox(height: AppSpacing.sm),
                _LevelUpBadge(level: progression.level, l10n: widget.l10n),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedXpBar extends StatelessWidget {
  final double fromFraction;
  final double toFraction;
  final bool started;

  const _AnimatedXpBar({
    required this.fromFraction,
    required this.toFraction,
    required this.started,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: fromFraction,
        end: started ? toFraction : fromFraction,
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: AppSpacing.borderRadiusSm,
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.xpColor),
            minHeight: AppSpacing.xpBarMinHeight,
          ),
        );
      },
    );
  }
}

class _DelayedPlayAgainButton extends StatefulWidget {
  final VoidCallback onPlayAgain;
  final AppLocalizations l10n;

  const _DelayedPlayAgainButton({
    required this.onPlayAgain,
    required this.l10n,
  });

  @override
  State<_DelayedPlayAgainButton> createState() =>
      _DelayedPlayAgainButtonState();
}

class _DelayedPlayAgainButtonState extends State<_DelayedPlayAgainButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _visible ? widget.onPlayAgain : null,
          child: Text(widget.l10n.game_result_playAgain),
        ),
      ),
    );
  }
}

class _LevelUpBadge extends StatelessWidget {
  final int level;
  final AppLocalizations l10n;

  const _LevelUpBadge({required this.level, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          l10n.game_result_levelUp,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.xpColor,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(
              duration: const Duration(milliseconds: 1200),
              color: AppColors.chipGold.withValues(alpha: 0.4),
            ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.xpColor.withValues(alpha: 0.2),
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: AppColors.xpColor.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            l10n.profile_level(level),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.xpColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: const Duration(milliseconds: 200)),
      ],
    );
  }
}
