import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

enum AchievementType {
  speedRun(icon: LucideIcons.timer, color: AppColors.info, detectable: true),
  highRoller(icon: LucideIcons.trendingUp, color: AppColors.chipGold, detectable: true),
  hatTrick(icon: LucideIcons.hash, color: AppColors.xpColor, detectable: true),
  whale(icon: LucideIcons.sailboat, color: AppColors.info, detectable: true),
  allIn(icon: LucideIcons.dices, color: AppColors.heartRed, detectable: false),
  comeback(icon: LucideIcons.rotateCcw, color: AppColors.success, detectable: false),
  luckyBastard(icon: LucideIcons.clover, color: AppColors.cloverColor, detectable: false),
  oops(icon: LucideIcons.frown, color: AppColors.warning, detectable: false),
  ghost(icon: LucideIcons.eyeOff, color: AppColors.textSecondary, detectable: false),
  goldenParachute(icon: LucideIcons.umbrella, color: AppColors.chipGold, detectable: true),
  paperHands(icon: LucideIcons.handMetal, color: AppColors.warning, detectable: true);

  final IconData icon;
  final Color color;
  final bool detectable;

  const AchievementType({required this.icon, required this.color, required this.detectable});
}
