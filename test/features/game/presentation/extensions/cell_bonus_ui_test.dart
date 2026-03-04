import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:tictacbet/core/theme/app_colors.dart';
import 'package:tictacbet/features/game/domain/entities/cell_entity.dart';
import 'package:tictacbet/features/game/presentation/extensions/cell_bonus_ui.dart';

void main() {
  group('CellBonusUI', () {
    group('icon', () {
      test('returns coins icon for coin bonus', () {
        expect(CellBonus.coin.icon, LucideIcons.coins);
      });

      test('returns sparkles icon for xp bonus', () {
        expect(CellBonus.xp.icon, LucideIcons.sparkles);
      });
    });

    group('color', () {
      test('returns coinColor for coin bonus', () {
        expect(CellBonus.coin.color, AppColors.coinColor);
      });

      test('returns xpColor for xp bonus', () {
        expect(CellBonus.xp.color, AppColors.xpColor);
      });
    });

    group('colorDark', () {
      test('returns coinColorDark for coin bonus', () {
        expect(CellBonus.coin.colorDark, AppColors.coinColorDark);
      });

      test('returns xpColorDark for xp bonus', () {
        expect(CellBonus.xp.colorDark, AppColors.xpColorDark);
      });
    });
  });
}
