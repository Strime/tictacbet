import 'package:flutter_test/flutter_test.dart';
import 'package:tictacbet/features/wallet/domain/entities/wallet_entity.dart';

void main() {
  group('WalletEntity', () {
    group('canClaimDailyBonus', () {
      test('returns true when lastBonusDate is null (first launch)', () {
        const wallet = WalletEntity(balance: 10, lastBonusDate: null);

        expect(wallet.canClaimDailyBonus, isTrue);
      });

      test('returns true when lastBonusDate is yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        final wallet = WalletEntity(balance: 10, lastBonusDate: yesterday);

        expect(wallet.canClaimDailyBonus, isTrue);
      });

      test('returns false when lastBonusDate is today', () {
        final today = DateTime.now();
        final wallet = WalletEntity(balance: 10, lastBonusDate: today);

        expect(wallet.canClaimDailyBonus, isFalse);
      });

      test('returns true when lastBonusDate is several days ago', () {
        final daysAgo = DateTime.now().subtract(const Duration(days: 5));
        final wallet = WalletEntity(balance: 10, lastBonusDate: daysAgo);

        expect(wallet.canClaimDailyBonus, isTrue);
      });
    });

    group('canPlaceBet', () {
      test('returns true when balance is greater than amount', () {
        const wallet = WalletEntity(balance: 20);

        expect(wallet.canPlaceBet(10), isTrue);
      });

      test('returns true when balance equals amount', () {
        const wallet = WalletEntity(balance: 10);

        expect(wallet.canPlaceBet(10), isTrue);
      });

      test('returns false when balance is less than amount', () {
        const wallet = WalletEntity(balance: 5);

        expect(wallet.canPlaceBet(10), isFalse);
      });

      test('returns false when balance is zero', () {
        const wallet = WalletEntity(balance: 0);

        expect(wallet.canPlaceBet(1), isFalse);
      });
    });
  });
}
