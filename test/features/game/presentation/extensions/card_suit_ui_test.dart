import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/core/theme/app_colors.dart';
import 'package:tictacbet/features/game/domain/entities/card_entity.dart';
import 'package:tictacbet/features/game/presentation/extensions/card_suit_ui.dart';

void main() {
  group('CardSuitUI', () {
    group('color', () {
      test('returns heartRed for heart suit', () {
        expect(CardSuit.heart.color, AppColors.heartRed);
      });

      test('returns spadeBlack for spade suit', () {
        expect(CardSuit.spade.color, AppColors.spadeBlack);
      });
    });

    group('symbol', () {
      test('returns heart symbol for heart suit', () {
        expect(CardSuit.heart.symbol, '♥');
      });

      test('returns spade symbol for spade suit', () {
        expect(CardSuit.spade.symbol, '♠');
      });
    });
  });
}
