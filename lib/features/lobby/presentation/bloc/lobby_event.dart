part of 'lobby_bloc.dart';

sealed class LobbyEvent extends Equatable {
  const LobbyEvent();

  @override
  List<Object?> get props => [];
}

class LobbyInitialized extends LobbyEvent {
  final int playerBalance;

  const LobbyInitialized({required this.playerBalance});

  @override
  List<Object?> get props => [playerBalance];
}

class LobbyBetChanged extends LobbyEvent {
  final int amount;

  const LobbyBetChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

class LobbyBetAdded extends LobbyEvent {
  final int chipAmount;

  const LobbyBetAdded(this.chipAmount);

  @override
  List<Object?> get props => [chipAmount];
}

class LobbyBetReset extends LobbyEvent {
  const LobbyBetReset();
}

class LobbyBetMaxed extends LobbyEvent {
  const LobbyBetMaxed();
}
