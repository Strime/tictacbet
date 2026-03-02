part of 'lobby_bloc.dart';

enum AiDifficulty { easy, medium, hard, expert }

sealed class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object?> get props => [];
}

class LobbyInitial extends LobbyState {
  const LobbyInitial();
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

  AiDifficulty get aiDifficulty => switch (aiLevel) {
    >= 1.0 => AiDifficulty.expert,
    >= 0.7 => AiDifficulty.hard,
    >= 0.3 => AiDifficulty.medium,
    _ => AiDifficulty.easy,
  };

  @override
  List<Object?> get props => [selectedSide, betAmount, maxBet];
}
