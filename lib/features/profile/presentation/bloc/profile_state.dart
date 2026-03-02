part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int draws;
  final double winRate;
  final int totalEarnings;
  final Map<AchievementType, bool> achievements;

  const ProfileLoaded({
    required this.gamesPlayed,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.winRate,
    required this.totalEarnings,
    required this.achievements,
  });

  bool get isEmpty => gamesPlayed == 0;

  int get unlockedCount => achievements.values.where((v) => v).length;

  @override
  List<Object?> get props => [
        gamesPlayed,
        wins,
        losses,
        draws,
        winRate,
        totalEarnings,
        achievements,
      ];
}

class ProfileError extends ProfileState {
  const ProfileError();
}
