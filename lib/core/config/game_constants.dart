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

  // --- Bonus distribution probabilities ---
  static const double cloverProbability = 0.15; // 15% chance per cell
  static const double xpBonusProbability = 0.25; // 25% chance per cell
  // Remaining ~60% = coin bonus

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
