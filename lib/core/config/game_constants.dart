/// Central configuration for all game balance values.
class GameConstants {
  GameConstants._();

  // --- Bonus values ---
  static const int coinBonusValue = 1; // $1 per coin cell
  static const int winBonusBase = 5; // $5 base win bonus
  static const int winBetMultiplier = 2; // winner gets bet * 2

  // --- Card cash bonus (optional variant) ---
  static const Map<String, int> cardCashBonus = {
    'ace': 1,
    'ten': 2,
    'jack': 3,
    'queen': 4,
    'king': 5,
  };

  // --- Bet ranges → AI level mapping ---
  static const List<BetAiMapping> betAiMappings = [
    BetAiMapping(minBet: 1, maxBet: 5, aiLevel: 0.0),
    BetAiMapping(minBet: 6, maxBet: 20, aiLevel: 0.3),
    BetAiMapping(minBet: 21, maxBet: 50, aiLevel: 0.7),
    BetAiMapping(minBet: 51, maxBet: 999999, aiLevel: 1.0),
  ];

  /// Returns the AI level for a given bet amount.
  static double aiLevelForBet(int betAmount) {
    for (final mapping in betAiMappings) {
      if (betAmount >= mapping.minBet && betAmount <= mapping.maxBet) {
        return mapping.aiLevel;
      }
    }
    return 1.0;
  }

  // --- XP ---
  static const int xpPerBonusCell = 20; // XP reward per XP bonus cell
  static const int xpPerWin = 100;
  static const int xpPerDraw = 50;
  static const int xpPerLoss = 10;
  static const int levelBaseXp = 200; // Level N = levelBaseXp * N^2

  /// Total XP required to reach a given level.
  static int xpForLevel(int level) => levelBaseXp * level * level;

  /// Calculates level from total XP.
  static int levelFromXp(int totalXp) {
    int level = 0;
    while (xpForLevel(level + 1) <= totalXp) {
      level++;
    }
    return level;
  }

  // --- Win streak ---
  static const double streakMultiplierStep = 0.2;
  static const int streakMaxCount = 10;

  /// Returns the XP multiplier for the given win streak.
  static double streakMultiplier(int streak) {
    if (streak <= 1) return 1.0;
    final effective = streak.clamp(0, streakMaxCount);
    return 1.0 + (effective - 1) * streakMultiplierStep;
  }

  // --- Bonus distribution probabilities ---
  static const double xpBonusProbability = 0.4; // 40% chance per cell
  // Remaining ~60% = coin bonus

  // --- Cash out ---
  static const double cashOutMinMultiplier = 0.1;
  static const double cashOutMaxMultiplier = 1.8;
  static const int cashOutMinMoveCount = 2;
  static const int xpPerCashOut = 10;

  // --- AI noise ---
  static const double aiNoiseScale = 20.0; // Max noise amplitude at level 0.0
  static const double aiMinNoise = 3.0; // Residual noise even at level 1.0

  // --- Timing ---
  static const Duration aiMoveDelay = Duration(milliseconds: 600);
  static const Duration speedWinThreshold = Duration(seconds: 30);
  static const Duration cardFlipDuration = Duration(milliseconds: 400);

  // --- Initial player balance ---
  static const int initialBalance = 10;

  // --- Daily bonus ---
  static const int dailyBonusAmount = 10;
}

class BetAiMapping {
  final int minBet;
  final int maxBet;
  final double aiLevel;

  const BetAiMapping({
    required this.minBet,
    required this.maxBet,
    required this.aiLevel,
  });
}
