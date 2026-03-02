part of 'progression_bloc.dart';

sealed class ProgressionState extends Equatable {
  const ProgressionState();

  @override
  List<Object?> get props => [];
}

class ProgressionInitial extends ProgressionState {
  const ProgressionInitial();
}

class ProgressionLoaded extends ProgressionState {
  final ProgressionEntity progression;
  final int? xpEarned;
  final bool leveledUp;

  const ProgressionLoaded({
    required this.progression,
    this.xpEarned,
    this.leveledUp = false,
  });

  int get level => progression.level;
  double get progressFraction => progression.progressFraction;

  @override
  List<Object?> get props => [progression, xpEarned, leveledUp];
}
