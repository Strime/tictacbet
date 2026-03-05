import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

enum AchievementType {
  speedRun(icon: LucideIcons.timer, color: AppColors.info, detectable: true),
  highRoller(icon: LucideIcons.trendingUp, color: AppColors.chipGold, detectable: true),
  hatTrick(icon: LucideIcons.hash, color: AppColors.xpColor, detectable: true),
  whale(icon: LucideIcons.sailboat, color: AppColors.info, detectable: true),
  allIn(icon: LucideIcons.dices, color: AppColors.heartRed, detectable: true),
  goldenParachute(icon: LucideIcons.umbrella, color: AppColors.chipGold, detectable: true),
  paperHands(icon: LucideIcons.handMetal, color: AppColors.warning, detectable: true),
  doubleAgent(icon: LucideIcons.repeat, color: AppColors.info, detectable: true),
  redMaster(icon: LucideIcons.heart, color: AppColors.heartRed, detectable: true),
  blackMaster(icon: LucideIcons.spade, color: AppColors.spadeBlack, detectable: true);

  final IconData icon;
  final Color color;
  final bool detectable;

  const AchievementType({required this.icon, required this.color, required this.detectable});
}
