part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Load wallet from persistence and check daily bonus.
class WalletStarted extends WalletEvent {
  const WalletStarted();
}

/// Deduct bet amount when entering a game.
class WalletBetPlaced extends WalletEvent {
  final int amount;

  const WalletBetPlaced(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Add winnings after game ends (0 for loss, betAmount for draw,
/// winBonusBase + betAmount * winBetMultiplier for win).
class WalletGameSettled extends WalletEvent {
  final int winnings;

  const WalletGameSettled(this.winnings);

  @override
  List<Object?> get props => [winnings];
}
