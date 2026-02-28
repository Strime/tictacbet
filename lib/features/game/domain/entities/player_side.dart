import 'card_entity.dart';

/// The two player camps.
enum PlayerSide {
  red(suit: CardSuit.heart, label: 'Red'),
  black(suit: CardSuit.spade, label: 'Black');

  final CardSuit suit;
  final String label;
  const PlayerSide({required this.suit, required this.label});

  PlayerSide get opponent =>
      this == PlayerSide.red ? PlayerSide.black : PlayerSide.red;
}
