import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cell_entity.dart';

extension CellBonusUI on CellBonus {
  IconData get icon => switch (this) {
    CellBonus.coin => LucideIcons.coins,
    CellBonus.xp => LucideIcons.sparkles,
  };

  Color get color => switch (this) {
    CellBonus.coin => AppColors.coinColor,
    CellBonus.xp => AppColors.xpColor,
  };

  Color get colorDark => switch (this) {
    CellBonus.coin => AppColors.coinColorDark,
    CellBonus.xp => AppColors.xpColorDark,
  };
}
