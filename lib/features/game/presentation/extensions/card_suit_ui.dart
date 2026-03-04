import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/card_entity.dart';

extension CardSuitUI on CardSuit {
  Color get color => switch (this) {
    CardSuit.heart => AppColors.heartRed,
    CardSuit.spade => AppColors.spadeBlack,
  };

  String get symbol => switch (this) {
    CardSuit.heart => '♥',
    CardSuit.spade => '♠',
  };
}
