import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_entity.freezed.dart';

/// Suit of a playing card.
enum CardSuit { heart, spade }

/// Rank of a playing card.
enum CardRank {
  ace(cashBonus: 1),
  ten(cashBonus: 2),
  jack(cashBonus: 3),
  queen(cashBonus: 4),
  king(cashBonus: 5);

  final int cashBonus;
  const CardRank({required this.cashBonus});
}

/// A playing card with a suit and rank.
@freezed
sealed class CardEntity with _$CardEntity {
  const factory CardEntity({
    required CardSuit suit,
    required CardRank rank,
  }) = _CardEntity;
}
