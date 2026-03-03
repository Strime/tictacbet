import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/lobby/presentation/widgets/coin_drop_overlay.dart';

void main() {
  group('coinCountForAmount', () {
    test('returns 1 for amount 0', () {
      expect(coinCountForAmount(0), 1);
    });

    test('returns 1 for amount 1', () {
      expect(coinCountForAmount(1), 1);
    });

    test('returns 3 for amount 5', () {
      expect(coinCountForAmount(5), 3);
    });

    test('returns 5 for amount 10', () {
      expect(coinCountForAmount(10), 5);
    });

    test('returns 8 for amount 25', () {
      expect(coinCountForAmount(25), 8);
    });

    test('clamps to 10 for large amounts', () {
      expect(coinCountForAmount(100), 10);
      expect(coinCountForAmount(1000), 10);
    });

    test('never returns less than 1', () {
      expect(coinCountForAmount(-5), 1);
    });
  });
}
