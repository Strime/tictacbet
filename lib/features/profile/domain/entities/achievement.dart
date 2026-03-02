import 'package:flutter/material.dart';

enum AchievementType {
  speedRun(icon: Icons.timer, detectable: true),
  highRoller(icon: Icons.trending_up, detectable: true),
  hatTrick(icon: Icons.looks_3, detectable: true),
  whale(icon: Icons.sailing, detectable: true),
  allIn(icon: Icons.casino, detectable: false),
  comeback(icon: Icons.replay, detectable: false),
  luckyBastard(icon: Icons.eco, detectable: false),
  oops(icon: Icons.sentiment_dissatisfied, detectable: false),
  ghost(icon: Icons.visibility_off, detectable: false);

  final IconData icon;
  final bool detectable;

  const AchievementType({required this.icon, required this.detectable});
}
