part of 'lobby_bloc.dart';

sealed class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object?> get props => [];
}

class LobbyReady extends LobbyState {
  final PlayerSide selectedSide;
  final int betAmount;
  final int maxBet;

  const LobbyReady({
    this.selectedSide = PlayerSide.red,
    this.betAmount = 1,
    required this.maxBet,
  });

  double get aiLevel => GameConstants.aiLevelForBet(betAmount);

  int get potentialWinnings =>
      GameConstants.winBonusBase + betAmount * GameConstants.winBetMultiplier;

  int get remainingBalance => maxBet - betAmount;

  String get aiDifficultyLabel => switch (aiLevel) {
    >= 1.0 => 'Expert',
    >= 0.7 => 'Hard',
    >= 0.3 => 'Medium',
    _ => 'Easy',
  };

  @override
  List<Object?> get props => [selectedSide, betAmount, maxBet];
}
