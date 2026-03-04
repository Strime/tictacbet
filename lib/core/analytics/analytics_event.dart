/// Typed analytics events for TicTacBet.
///
/// All [properties] values are primitives (String, int, double, bool),
/// ready for any analytics backend (Firebase, Mixpanel, etc.).
sealed class AnalyticsEvent {
  const AnalyticsEvent();

  String get name;
  Map<String, Object> get properties;
}

// -- Game --

final class GameStartedEvent extends AnalyticsEvent {
  final String humanSide;
  final double aiLevel;
  final int betAmount;

  const GameStartedEvent({
    required this.humanSide,
    required this.aiLevel,
    required this.betAmount,
  });

  @override
  String get name => 'game_started';

  @override
  Map<String, Object> get properties => {
        'human_side': humanSide,
        'ai_level': aiLevel,
        'bet_amount': betAmount,
      };
}

final class GameOverEvent extends AnalyticsEvent {
  final String outcome;
  final int betAmount;
  final int winnings;
  final int moveCount;
  final int durationSeconds;
  final bool isCashOut;

  const GameOverEvent({
    required this.outcome,
    required this.betAmount,
    required this.winnings,
    required this.moveCount,
    required this.durationSeconds,
    required this.isCashOut,
  });

  @override
  String get name => 'game_over';

  @override
  Map<String, Object> get properties => {
        'outcome': outcome,
        'bet_amount': betAmount,
        'winnings': winnings,
        'move_count': moveCount,
        'duration_seconds': durationSeconds,
        'is_cash_out': isCashOut,
      };
}

// -- Wallet --

final class DailyBonusClaimedEvent extends AnalyticsEvent {
  final int newBalance;

  const DailyBonusClaimedEvent({required this.newBalance});

  @override
  String get name => 'daily_bonus_claimed';

  @override
  Map<String, Object> get properties => {
        'new_balance': newBalance,
      };
}

// -- Progression --

final class XpEarnedEvent extends AnalyticsEvent {
  final int xpEarned;
  final int totalXp;
  final int level;
  final bool leveledUp;
  final int winStreak;

  const XpEarnedEvent({
    required this.xpEarned,
    required this.totalXp,
    required this.level,
    required this.leveledUp,
    required this.winStreak,
  });

  @override
  String get name => 'xp_earned';

  @override
  Map<String, Object> get properties => {
        'xp_earned': xpEarned,
        'total_xp': totalXp,
        'level': level,
        'leveled_up': leveledUp,
        'win_streak': winStreak,
      };
}

final class LevelUpEvent extends AnalyticsEvent {
  final int newLevel;
  final int totalXp;

  const LevelUpEvent({required this.newLevel, required this.totalXp});

  @override
  String get name => 'level_up';

  @override
  Map<String, Object> get properties => {
        'new_level': newLevel,
        'total_xp': totalXp,
      };
}
