import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TicTacBet'**
  String get appTitle;

  /// No description provided for @lobby_title.
  ///
  /// In en, this message translates to:
  /// **'TicTacBet'**
  String get lobby_title;

  /// No description provided for @lobby_playingAs.
  ///
  /// In en, this message translates to:
  /// **'Playing as {side}'**
  String lobby_playingAs(String side);

  /// No description provided for @lobby_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get lobby_red;

  /// No description provided for @lobby_black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get lobby_black;

  /// No description provided for @lobby_placeBet.
  ///
  /// In en, this message translates to:
  /// **'Place your bet'**
  String get lobby_placeBet;

  /// No description provided for @lobby_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get lobby_play;

  /// No description provided for @lobby_vsAi.
  ///
  /// In en, this message translates to:
  /// **'VS AI'**
  String get lobby_vsAi;

  /// No description provided for @lobby_vsLocal.
  ///
  /// In en, this message translates to:
  /// **'VS Local'**
  String get lobby_vsLocal;

  /// No description provided for @game_yourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get game_yourTurn;

  /// No description provided for @game_aiTurn.
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get game_aiTurn;

  /// No description provided for @game_redTurn.
  ///
  /// In en, this message translates to:
  /// **'Red\'s turn'**
  String get game_redTurn;

  /// No description provided for @game_blackTurn.
  ///
  /// In en, this message translates to:
  /// **'Black\'s turn'**
  String get game_blackTurn;

  /// No description provided for @game_result_win.
  ///
  /// In en, this message translates to:
  /// **'You win!'**
  String get game_result_win;

  /// No description provided for @game_result_loss.
  ///
  /// In en, this message translates to:
  /// **'You lose!'**
  String get game_result_loss;

  /// No description provided for @game_result_draw.
  ///
  /// In en, this message translates to:
  /// **'Draw!'**
  String get game_result_draw;

  /// No description provided for @game_result_redWins.
  ///
  /// In en, this message translates to:
  /// **'Red wins!'**
  String get game_result_redWins;

  /// No description provided for @game_result_blackWins.
  ///
  /// In en, this message translates to:
  /// **'Black wins!'**
  String get game_result_blackWins;

  /// No description provided for @game_result_playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get game_result_playAgain;

  /// No description provided for @game_result_backToLobby.
  ///
  /// In en, this message translates to:
  /// **'Back to Lobby'**
  String get game_result_backToLobby;

  /// No description provided for @game_result_cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cashed Out'**
  String get game_result_cashOut;

  /// No description provided for @game_cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get game_cashOut;

  /// No description provided for @game_cashOut_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Cash Out?'**
  String get game_cashOut_confirm_title;

  /// No description provided for @game_cashOut_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'You\'ll receive {amount}. Are you sure?'**
  String game_cashOut_confirm_body(String amount);

  /// No description provided for @game_cashOut_confirm_yes.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get game_cashOut_confirm_yes;

  /// No description provided for @game_cashOut_confirm_no.
  ///
  /// In en, this message translates to:
  /// **'Keep Playing'**
  String get game_cashOut_confirm_no;

  /// No description provided for @game_pot.
  ///
  /// In en, this message translates to:
  /// **'Pot: \${amount}'**
  String game_pot(int amount);

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_level.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String profile_level(int level);

  /// No description provided for @profile_balance.
  ///
  /// In en, this message translates to:
  /// **'\${amount}'**
  String profile_balance(int amount);

  /// No description provided for @profile_gamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Games Played'**
  String get profile_gamesPlayed;

  /// No description provided for @profile_wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get profile_wins;

  /// No description provided for @profile_losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get profile_losses;

  /// No description provided for @profile_winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get profile_winRate;

  /// No description provided for @profile_draws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get profile_draws;

  /// No description provided for @profile_cashOuts.
  ///
  /// In en, this message translates to:
  /// **'Cash Outs'**
  String get profile_cashOuts;

  /// No description provided for @profile_totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get profile_totalEarnings;

  /// No description provided for @profile_empty.
  ///
  /// In en, this message translates to:
  /// **'No stats yet'**
  String get profile_empty;

  /// No description provided for @profile_emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play your first game to\nsee your stats here'**
  String get profile_emptySubtitle;

  /// No description provided for @profile_achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get profile_achievements;

  /// No description provided for @achievement_all_in.
  ///
  /// In en, this message translates to:
  /// **'All In'**
  String get achievement_all_in;

  /// No description provided for @achievement_all_in_desc.
  ///
  /// In en, this message translates to:
  /// **'Win a game after an All In'**
  String get achievement_all_in_desc;

  /// No description provided for @achievement_comeback.
  ///
  /// In en, this message translates to:
  /// **'Comeback'**
  String get achievement_comeback;

  /// No description provided for @achievement_comeback_desc.
  ///
  /// In en, this message translates to:
  /// **'Win with fewer cell gains than opponent'**
  String get achievement_comeback_desc;

  /// No description provided for @achievement_speed_run.
  ///
  /// In en, this message translates to:
  /// **'Speed Run'**
  String get achievement_speed_run;

  /// No description provided for @achievement_speed_run_desc.
  ///
  /// In en, this message translates to:
  /// **'Win in under 30 seconds'**
  String get achievement_speed_run_desc;

  /// No description provided for @achievement_high_roller.
  ///
  /// In en, this message translates to:
  /// **'High Roller'**
  String get achievement_high_roller;

  /// No description provided for @achievement_high_roller_desc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate \$100 total'**
  String get achievement_high_roller_desc;

  /// No description provided for @achievement_oops.
  ///
  /// In en, this message translates to:
  /// **'Oops'**
  String get achievement_oops;

  /// No description provided for @achievement_oops_desc.
  ///
  /// In en, this message translates to:
  /// **'Lose a game with a perfect cell score'**
  String get achievement_oops_desc;

  /// No description provided for @achievement_ghost.
  ///
  /// In en, this message translates to:
  /// **'Ghost'**
  String get achievement_ghost;

  /// No description provided for @achievement_ghost_desc.
  ///
  /// In en, this message translates to:
  /// **'Finish a game with \$0 and 0 XP'**
  String get achievement_ghost_desc;

  /// No description provided for @achievement_hat_trick.
  ///
  /// In en, this message translates to:
  /// **'Hat Trick'**
  String get achievement_hat_trick;

  /// No description provided for @achievement_hat_trick_desc.
  ///
  /// In en, this message translates to:
  /// **'Win 3 consecutive games'**
  String get achievement_hat_trick_desc;

  /// No description provided for @achievement_whale.
  ///
  /// In en, this message translates to:
  /// **'Whale'**
  String get achievement_whale;

  /// No description provided for @achievement_whale_desc.
  ///
  /// In en, this message translates to:
  /// **'Win a game with a \$50+ bet'**
  String get achievement_whale_desc;

  /// No description provided for @achievement_golden_parachute.
  ///
  /// In en, this message translates to:
  /// **'Golden Parachute'**
  String get achievement_golden_parachute;

  /// No description provided for @achievement_golden_parachute_desc.
  ///
  /// In en, this message translates to:
  /// **'Cash out with a profit'**
  String get achievement_golden_parachute_desc;

  /// No description provided for @achievement_paper_hands.
  ///
  /// In en, this message translates to:
  /// **'Paper Hands'**
  String get achievement_paper_hands;

  /// No description provided for @achievement_paper_hands_desc.
  ///
  /// In en, this message translates to:
  /// **'Cash out 3 times'**
  String get achievement_paper_hands_desc;

  /// No description provided for @achievement_double_agent.
  ///
  /// In en, this message translates to:
  /// **'Double Agent'**
  String get achievement_double_agent;

  /// No description provided for @achievement_double_agent_desc.
  ///
  /// In en, this message translates to:
  /// **'Win as red and as black'**
  String get achievement_double_agent_desc;

  /// No description provided for @achievement_red_master.
  ///
  /// In en, this message translates to:
  /// **'Red Master'**
  String get achievement_red_master;

  /// No description provided for @achievement_red_master_desc.
  ///
  /// In en, this message translates to:
  /// **'Win 5 games as red'**
  String get achievement_red_master_desc;

  /// No description provided for @achievement_black_master.
  ///
  /// In en, this message translates to:
  /// **'Black Master'**
  String get achievement_black_master;

  /// No description provided for @achievement_black_master_desc.
  ///
  /// In en, this message translates to:
  /// **'Win 5 games as black'**
  String get achievement_black_master_desc;

  /// No description provided for @lobby_difficulty_easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get lobby_difficulty_easy;

  /// No description provided for @lobby_difficulty_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get lobby_difficulty_medium;

  /// No description provided for @lobby_difficulty_hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get lobby_difficulty_hard;

  /// No description provided for @lobby_difficulty_expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get lobby_difficulty_expert;

  /// No description provided for @nav_lobby.
  ///
  /// In en, this message translates to:
  /// **'Lobby'**
  String get nav_lobby;

  /// No description provided for @nav_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get nav_history;

  /// No description provided for @nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_profile;

  /// No description provided for @history_title.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history_title;

  /// No description provided for @history_empty.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get history_empty;

  /// No description provided for @history_emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play your first game to\nsee your results here'**
  String get history_emptySubtitle;

  /// No description provided for @history_result_win.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get history_result_win;

  /// No description provided for @history_result_draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get history_result_draw;

  /// No description provided for @history_result_loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get history_result_loss;

  /// No description provided for @history_result_cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get history_result_cashOut;

  /// No description provided for @history_bet.
  ///
  /// In en, this message translates to:
  /// **'Bet: \${amount}'**
  String history_bet(int amount);

  /// No description provided for @profile_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get profile_comingSoon;

  /// No description provided for @profile_bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get profile_bestStreak;

  /// No description provided for @profile_levelXp.
  ///
  /// In en, this message translates to:
  /// **'Level {level} • {current}/{total} XP'**
  String profile_levelXp(int level, int current, int total);

  /// No description provided for @game_result_xpEarned.
  ///
  /// In en, this message translates to:
  /// **'+{amount} XP'**
  String game_result_xpEarned(int amount);

  /// No description provided for @game_result_winStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} win streak'**
  String game_result_winStreak(int count);

  /// No description provided for @game_result_streakBonus.
  ///
  /// In en, this message translates to:
  /// **'×{multiplier} streak bonus'**
  String game_result_streakBonus(String multiplier);

  /// No description provided for @game_result_levelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get game_result_levelUp;

  /// No description provided for @lobby_potentialWinnings.
  ///
  /// In en, this message translates to:
  /// **'Potential winnings'**
  String get lobby_potentialWinnings;

  /// No description provided for @lobby_playWithBet.
  ///
  /// In en, this message translates to:
  /// **'Play — \${amount}'**
  String lobby_playWithBet(int amount);

  /// No description provided for @common_error_unknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get common_error_unknown;

  /// No description provided for @common_error_storage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save data'**
  String get common_error_storage;

  /// No description provided for @onboarding_stepBet_title.
  ///
  /// In en, this message translates to:
  /// **'Place your bet'**
  String get onboarding_stepBet_title;

  /// No description provided for @onboarding_stepBet_desc.
  ///
  /// In en, this message translates to:
  /// **'Tap a chip to place your bet.\nHigher bets mean tougher AI.'**
  String get onboarding_stepBet_desc;

  /// No description provided for @onboarding_stepPlay_title.
  ///
  /// In en, this message translates to:
  /// **'Launch the game'**
  String get onboarding_stepPlay_title;

  /// No description provided for @onboarding_stepPlay_desc.
  ///
  /// In en, this message translates to:
  /// **'When you\'re ready, hit Play\nto start the match.'**
  String get onboarding_stepPlay_desc;

  /// No description provided for @onboarding_stepCard_title.
  ///
  /// In en, this message translates to:
  /// **'Discover the cards'**
  String get onboarding_stepCard_title;

  /// No description provided for @onboarding_stepCard_desc.
  ///
  /// In en, this message translates to:
  /// **'Each cell hides a card.\nTap one to reveal it!'**
  String get onboarding_stepCard_desc;

  /// No description provided for @onboarding_stepAchievements_title.
  ///
  /// In en, this message translates to:
  /// **'Earn achievements'**
  String get onboarding_stepAchievements_title;

  /// No description provided for @onboarding_stepAchievements_desc.
  ///
  /// In en, this message translates to:
  /// **'Complete challenges to unlock\nachievements and show off your skills.'**
  String get onboarding_stepAchievements_desc;

  /// No description provided for @onboarding_moreToDiscover.
  ///
  /// In en, this message translates to:
  /// **'...and more to discover!'**
  String get onboarding_moreToDiscover;

  /// No description provided for @onboarding_startPlaying.
  ///
  /// In en, this message translates to:
  /// **'Start playing'**
  String get onboarding_startPlaying;

  /// No description provided for @onboarding_bonusCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get onboarding_bonusCoin;

  /// No description provided for @onboarding_bonusCoin_desc.
  ///
  /// In en, this message translates to:
  /// **'Cash bonus on capture'**
  String get onboarding_bonusCoin_desc;

  /// No description provided for @onboarding_bonusLuck.
  ///
  /// In en, this message translates to:
  /// **'Luck'**
  String get onboarding_bonusLuck;

  /// No description provided for @onboarding_bonusLuck_desc.
  ///
  /// In en, this message translates to:
  /// **'Lucky draw bonus'**
  String get onboarding_bonusLuck_desc;

  /// No description provided for @onboarding_bonusXp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get onboarding_bonusXp;

  /// No description provided for @onboarding_bonusXp_desc.
  ///
  /// In en, this message translates to:
  /// **'Experience points bonus'**
  String get onboarding_bonusXp_desc;

  /// No description provided for @onboarding_gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get onboarding_gotIt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
