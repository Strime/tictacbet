import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/game/domain/entities/game_entity.dart';
import '../../features/game/domain/entities/game_status.dart';
import '../../features/game/presentation/bloc/game_bloc.dart';
import '../../features/progression/presentation/bloc/progression_bloc.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import 'analytics_event.dart';
import 'analytics_service.dart';

/// Routes BLoC state transitions to [AnalyticsService] without modifying BLoCs.
class AnalyticsBlocObserver extends BlocObserver {
  final AnalyticsService _analytics;

  const AnalyticsBlocObserver(this._analytics);

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    if (bloc is GameBloc) {
      _onGameChange(change.currentState, change.nextState);
    } else if (bloc is WalletBloc) {
      _onWalletChange(change.currentState, change.nextState);
    } else if (bloc is ProgressionBloc) {
      _onProgressionChange(change.currentState, change.nextState);
    }
  }

  void _onGameChange(dynamic current, dynamic next) {
    if (current is GameInitial && next is GameInProgress) {
      final game = next.game;
      _analytics.track(GameStartedEvent(
        humanSide: game.humanSide.name,
        aiLevel: game.aiLevel,
        betAmount: game.betAmount,
      ));
      return;
    }

    if (current is! GameOver && next is GameOver) {
      final game = next.game;
      _analytics.track(GameOverEvent(
        outcome: _gameOutcome(game),
        betAmount: game.betAmount,
        winnings: next.isCashOut ? (next.cashOutAmount as int) : game.winnings,
        moveCount: game.moveCount,
        durationSeconds: game.duration?.inSeconds ?? 0,
        isCashOut: next.isCashOut,
      ));
    }
  }

  void _onWalletChange(dynamic current, dynamic next) {
    if (current is WalletInitial &&
        next is WalletLoaded &&
        next.dailyBonusJustClaimed) {
      _analytics.track(DailyBonusClaimedEvent(
        newBalance: next.wallet.balance,
      ));
    }
  }

  void _onProgressionChange(dynamic current, dynamic next) {
    if (next is! ProgressionLoaded || next.xpEarned == null) return;

    _analytics.track(XpEarnedEvent(
      xpEarned: next.xpEarned!,
      totalXp: next.progression.totalXp,
      level: next.progression.level,
      leveledUp: next.leveledUp,
      winStreak: next.progression.currentWinStreak,
    ));

    if (next.leveledUp) {
      _analytics.track(LevelUpEvent(
        newLevel: next.progression.level,
        totalXp: next.progression.totalXp,
      ));
    }
  }

  String _gameOutcome(GameEntity game) {
    return switch (game.status) {
      GameStatus.redWins => game.humanWon ? 'win' : 'loss',
      GameStatus.blackWins => game.humanWon ? 'win' : 'loss',
      GameStatus.draw => 'draw',
      GameStatus.inProgress => 'unknown',
    };
  }
}
