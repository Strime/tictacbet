import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tictacbet/core/theme/app_colors.dart';
import 'package:tictacbet/features/game/domain/entities/player_side.dart';
import 'package:tictacbet/features/game/presentation/extensions/player_side_ui.dart';

void main() {
  group('PlayerSideUI', () {
    group('icon', () {
      test('returns heart icon for red side', () {
        expect(PlayerSide.red.icon, LucideIcons.heart);
      });

      test('returns spade icon for black side', () {
        expect(PlayerSide.black.icon, LucideIcons.spade);
      });
    });

    group('color', () {
      test('returns heartRed for red side', () {
        expect(PlayerSide.red.color, AppColors.heartRed);
      });

      test('returns spadeBlack for black side', () {
        expect(PlayerSide.black.color, AppColors.spadeBlack);
      });
    });
  });
}
