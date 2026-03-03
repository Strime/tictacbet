import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/achievement.dart';

class AchievementTile extends StatelessWidget {
  final AchievementType type;
  final String name;
  final String description;
  final bool isUnlocked;

  const AchievementTile({
    super.key,
    required this.type,
    required this.name,
    required this.description,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusMd,
        border: isUnlocked
            ? Border.all(color: AppColors.surfaceLight)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.iconXl,
            height: AppSpacing.iconXl,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? type.color.withValues(alpha: 0.15)
                  : AppColors.surfaceLight,
            ),
            child: Icon(
              isUnlocked ? type.icon : LucideIcons.lock,
              size: AppSpacing.iconMd,
              color: isUnlocked
                  ? type.color
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Opacity(
              opacity: isUnlocked ? 1.0 : 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUnlocked)
            Icon(
              LucideIcons.checkCircle2,
              color: type.color,
              size: AppSpacing.iconMd,
            ),
        ],
      ),
    );
  }
}
