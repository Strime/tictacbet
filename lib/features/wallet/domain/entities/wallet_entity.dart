import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';

@freezed
sealed class WalletEntity with _$WalletEntity {
  const WalletEntity._();

  @Assert('balance >= 0', 'Wallet balance must not be negative')
  const factory WalletEntity({
    required int balance,
    DateTime? lastBonusDate,
  }) = _WalletEntity;

  bool get canClaimDailyBonus {
    if (lastBonusDate == null) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastClaim = DateTime(
      lastBonusDate!.year,
      lastBonusDate!.month,
      lastBonusDate!.day,
    );
    return today.isAfter(lastClaim);
  }

  bool canPlaceBet(int amount) => balance >= amount;
}
