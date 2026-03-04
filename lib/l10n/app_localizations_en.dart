// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TicTacBet';

  @override
  String get lobby_title => 'TicTacBet';

  @override
  String get lobby_selectCamp => 'Pick your side';

  @override
  String get lobby_red => 'Red';

  @override
  String get lobby_black => 'Black';

  @override
  String get lobby_placeBet => 'Place your bet';

  @override
  String get lobby_play => 'Play';

  @override
  String get lobby_vsAi => 'VS AI';

  @override
  String get lobby_vsLocal => 'VS Local';

  @override
  String get game_yourTurn => 'Your turn';

  @override
  String get game_aiTurn => 'AI is thinking...';

  @override
  String get game_redTurn => 'Red\'s turn';

  @override
  String get game_blackTurn => 'Black\'s turn';

  @override
  String get game_result_win => 'You win!';

  @override
  String get game_result_loss => 'You lose!';

  @override
  String get game_result_draw => 'Draw!';

  @override
  String get game_result_redWins => 'Red wins!';

  @override
  String get game_result_blackWins => 'Black wins!';

  @override
  String get game_result_playAgain => 'Play Again';

  @override
  String get game_result_backToLobby => 'Back to Lobby';

  @override
  String get game_result_cashOut => 'Cashed Out';

  @override
  String get game_cashOut => 'Cash Out';

  @override
  String get game_cashOut_confirm_title => 'Cash Out?';

  @override
  String game_cashOut_confirm_body(String amount) {
    return 'You\'ll receive $amount. Are you sure?';
  }

  @override
  String get game_cashOut_confirm_yes => 'Cash Out';

  @override
  String get game_cashOut_confirm_no => 'Keep Playing';

  @override
  String game_pot(int amount) {
    return 'Pot: \$$amount';
  }

  @override
  String get profile_title => 'Profile';

  @override
  String profile_level(int level) {
    return 'Level $level';
  }

  @override
  String profile_balance(int amount) {
    return '\$$amount';
  }

  @override
  String get profile_gamesPlayed => 'Games Played';

  @override
  String get profile_wins => 'Wins';

  @override
  String get profile_losses => 'Losses';

  @override
  String get profile_winRate => 'Win Rate';

  @override
  String get profile_draws => 'Draws';

  @override
  String get profile_cashOuts => 'Cash Outs';

  @override
  String get profile_totalEarnings => 'Total Earnings';

  @override
  String get profile_empty => 'No stats yet';

  @override
  String get profile_emptySubtitle =>
      'Play your first game to\nsee your stats here';

  @override
  String get profile_achievements => 'Achievements';

  @override
  String get achievement_all_in => 'All In';

  @override
  String get achievement_all_in_desc => 'Win a game after an All In';

  @override
  String get achievement_comeback => 'Comeback';

  @override
  String get achievement_comeback_desc =>
      'Win with fewer cell gains than opponent';

  @override
  String get achievement_speed_run => 'Speed Run';

  @override
  String get achievement_speed_run_desc => 'Win in under 30 seconds';

  @override
  String get achievement_high_roller => 'High Roller';

  @override
  String get achievement_high_roller_desc => 'Accumulate \$100 total';

  @override
  String get achievement_oops => 'Oops';

  @override
  String get achievement_oops_desc => 'Lose a game with a perfect cell score';

  @override
  String get achievement_ghost => 'Ghost';

  @override
  String get achievement_ghost_desc => 'Finish a game with \$0 and 0 XP';

  @override
  String get achievement_hat_trick => 'Hat Trick';

  @override
  String get achievement_hat_trick_desc => 'Win 3 consecutive games';

  @override
  String get achievement_whale => 'Whale';

  @override
  String get achievement_whale_desc => 'Win a game with a \$50+ bet';

  @override
  String get achievement_golden_parachute => 'Golden Parachute';

  @override
  String get achievement_golden_parachute_desc => 'Cash out with a profit';

  @override
  String get achievement_paper_hands => 'Paper Hands';

  @override
  String get achievement_paper_hands_desc => 'Cash out 3 times';

  @override
  String get lobby_difficulty_easy => 'Easy';

  @override
  String get lobby_difficulty_medium => 'Medium';

  @override
  String get lobby_difficulty_hard => 'Hard';

  @override
  String get lobby_difficulty_expert => 'Expert';

  @override
  String get nav_lobby => 'Lobby';

  @override
  String get nav_history => 'History';

  @override
  String get nav_profile => 'Profile';

  @override
  String get history_title => 'History';

  @override
  String get history_empty => 'No games yet';

  @override
  String get history_emptySubtitle =>
      'Play your first game to\nsee your results here';

  @override
  String get history_result_win => 'Win';

  @override
  String get history_result_draw => 'Draw';

  @override
  String get history_result_loss => 'Loss';

  @override
  String get history_result_cashOut => 'Cash Out';

  @override
  String history_bet(int amount) {
    return 'Bet: \$$amount';
  }

  @override
  String get profile_comingSoon => 'Coming soon';

  @override
  String get profile_bestStreak => 'Best Streak';

  @override
  String profile_levelXp(int level, int current, int total) {
    return 'Level $level • $current/$total XP';
  }

  @override
  String game_result_xpEarned(int amount) {
    return '+$amount XP';
  }

  @override
  String game_result_winStreak(int count) {
    return '$count win streak';
  }

  @override
  String game_result_streakBonus(String multiplier) {
    return '×$multiplier streak bonus';
  }

  @override
  String get game_result_levelUp => 'Level Up!';

  @override
  String get lobby_potentialWinnings => 'Potential winnings';

  @override
  String lobby_playWithBet(int amount) {
    return 'Play — \$$amount';
  }

  @override
  String get common_error_unknown => 'An unexpected error occurred';

  @override
  String get common_error_storage => 'Failed to save data';

  @override
  String get onboarding_stepBet_title => 'Place your bet';

  @override
  String get onboarding_stepBet_desc =>
      'Tap a chip to place your bet.\nHigher bets mean tougher AI.';

  @override
  String get onboarding_stepPlay_title => 'Launch the game';

  @override
  String get onboarding_stepPlay_desc =>
      'When you\'re ready, hit Play\nto start the match.';

  @override
  String get onboarding_stepCard_title => 'Discover the cards';

  @override
  String get onboarding_stepCard_desc =>
      'Each cell hides a card.\nTap one to reveal it!';

  @override
  String get onboarding_stepAchievements_title => 'Earn achievements';

  @override
  String get onboarding_stepAchievements_desc =>
      'Complete challenges to unlock\nachievements and show off your skills.';

  @override
  String get onboarding_moreToDiscover => '...and more to discover!';

  @override
  String get onboarding_startPlaying => 'Start playing';

  @override
  String get onboarding_bonusCoin => 'Coin';

  @override
  String get onboarding_bonusCoin_desc => 'Cash bonus on capture';

  @override
  String get onboarding_bonusLuck => 'Luck';

  @override
  String get onboarding_bonusLuck_desc => 'Lucky draw bonus';

  @override
  String get onboarding_bonusXp => 'XP';

  @override
  String get onboarding_bonusXp_desc => 'Experience points bonus';

  @override
  String get onboarding_gotIt => 'Got it';
}
