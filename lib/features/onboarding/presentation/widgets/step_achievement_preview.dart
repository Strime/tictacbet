import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/domain/entities/achievement.dart';
import '../../../profile/presentation/extensions/achievement_type_message.dart';
import '../../../profile/presentation/widgets/achievement_tile.dart';

class StepAchievementPreview extends StatelessWidget {
  final VoidCallback onStepCompleted;

  const StepAchievementPreview({
    super.key,
    required this.onStepCompleted,
  });

  static const Duration _staggerDelay = Duration(milliseconds: 200);

  static const _previewAchievements = [
    AchievementType.speedRun, 
    AchievementType.hatTrick, 
    AchievementType.highRoller, 
    AchievementType.goldenParachute,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _previewAchievements.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xxs,
                      ),
                      child: AchievementTile(
                        type: _previewAchievements[i],
                        name: _previewAchievements[i].label(l10n),
                        description: _previewAchievements[i].description(l10n),
                        isUnlocked: false,
                      ),
                    )
                        .animate()
                        .fadeIn(
                          delay: _staggerDelay * i,
                          duration: const Duration(
                              milliseconds: AppSpacing.animationMedium),
                        )
                        .slideX(
                          begin: 0.15,
                          end: 0,
                          delay: _staggerDelay * i,
                          duration: const Duration(
                              milliseconds: AppSpacing.animationMedium),
                          curve: Curves.easeOut,
                        ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.trophy,
                          size: AppSpacing.iconSm,
                          color: AppColors.chipGold,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          l10n.onboarding_moreToDiscover,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.chipGold,
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: _staggerDelay * _previewAchievements.length,
                        duration: const Duration(
                            milliseconds: AppSpacing.animationMedium),
                      )
                      .slideX(
                        begin: 0.15,
                        end: 0,
                        delay: _staggerDelay * _previewAchievements.length,
                        duration: const Duration(
                            milliseconds: AppSpacing.animationMedium),
                        curve: Curves.easeOut,
                      ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: ElevatedButton(
            onPressed: onStepCompleted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.feltGreen,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              shape: const StadiumBorder(),
              elevation: AppSpacing.elevationMedium,
            ),
            child: Text(
              l10n.onboarding_startPlaying,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
              .animate()
              .fadeIn(
                delay: _staggerDelay * (_previewAchievements.length + 1),
                duration: const Duration(
                    milliseconds: AppSpacing.animationMedium),
              )
              .slideY(
                begin: 0.2,
                end: 0,
                delay: _staggerDelay * (_previewAchievements.length + 1),
                duration: const Duration(
                    milliseconds: AppSpacing.animationMedium),
                curve: Curves.easeOut,
              ),
        ),
      ],
    );
  }
}

