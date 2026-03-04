import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/achievement.dart';
import '../extensions/achievement_type_message.dart';
import 'achievement_tile.dart';

class AchievementsSection extends StatelessWidget {
  final Map<AchievementType, bool> achievements;

  const AchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final sorted = AchievementType.values.toList()
      ..sort((a, b) {
        final aUnlocked = achievements[a] ?? false;
        final bUnlocked = achievements[b] ?? false;
        if (aUnlocked != bUnlocked) return aUnlocked ? -1 : 1;
        return a.index.compareTo(b.index);
      });

    final unlockedCount = achievements.values.where((v) => v).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.profile_achievements,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '$unlockedCount/${AchievementType.values.length}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...sorted.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isUnlocked = achievements[type] ?? false;
          final name = type.label(l10n);
          final description = type.description(l10n);

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < sorted.length - 1 ? AppSpacing.sm : 0,
            ),
            child: AchievementTile(
              type: type,
              name: name,
              description: description,
              isUnlocked: isUnlocked,
            ).animate().fadeIn(
                  delay: Duration(milliseconds: index * 50),
                ),
          );
        }),
      ],
    );
  }

}
