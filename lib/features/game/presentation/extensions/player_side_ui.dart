import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/player_side.dart';

extension PlayerSideUI on PlayerSide {
  IconData get icon => switch (this) {
    PlayerSide.red => LucideIcons.heart,
    PlayerSide.black => LucideIcons.spade,
  };

  Color get color => switch (this) {
    PlayerSide.red => AppColors.heartRed,
    PlayerSide.black => AppColors.spadeBlack,
  };
}
