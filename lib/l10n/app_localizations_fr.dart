// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TicTacBet';

  @override
  String get lobby_title => 'TicTacBet';

  @override
  String get lobby_selectCamp => 'Choisis ton camp';

  @override
  String get lobby_red => 'Rouge';

  @override
  String get lobby_black => 'Noir';

  @override
  String get lobby_placeBet => 'Place ta mise';

  @override
  String get lobby_play => 'Jouer';

  @override
  String get lobby_vsAi => 'VS IA';

  @override
  String get lobby_vsLocal => 'VS Local';

  @override
  String get game_yourTurn => 'A toi de jouer';

  @override
  String get game_aiTurn => 'L\'IA réfléchit...';

  @override
  String get game_redTurn => 'Tour des Rouges';

  @override
  String get game_blackTurn => 'Tour des Noirs';

  @override
  String get game_result_win => 'Victoire !';

  @override
  String get game_result_loss => 'Défaite !';

  @override
  String get game_result_draw => 'Égalité !';

  @override
  String get game_result_redWins => 'Les Rouges gagnent !';

  @override
  String get game_result_blackWins => 'Les Noirs gagnent !';

  @override
  String get game_result_playAgain => 'Rejouer';

  @override
  String get game_result_backToLobby => 'Retour au lobby';

  @override
  String get profile_title => 'Profil';

  @override
  String profile_level(int level) {
    return 'Niveau $level';
  }

  @override
  String profile_balance(int amount) {
    return '$amount\$';
  }

  @override
  String get profile_gamesPlayed => 'Parties jouées';

  @override
  String get profile_wins => 'Victoires';

  @override
  String get profile_losses => 'Défaites';

  @override
  String get profile_winRate => 'Taux de victoire';

  @override
  String get profile_draws => 'Nuls';

  @override
  String get profile_totalEarnings => 'Gains totaux';

  @override
  String get profile_empty => 'Pas encore de stats';

  @override
  String get profile_emptySubtitle =>
      'Jouez votre première partie\npour voir vos stats ici';

  @override
  String get profile_achievements => 'Succès';

  @override
  String get profile_clovers => 'Trèfles';

  @override
  String get achievement_all_in => 'All In';

  @override
  String get achievement_all_in_desc => 'Gagner avec 3 trèfles';

  @override
  String get achievement_comeback => 'Comeback';

  @override
  String get achievement_comeback_desc =>
      'Gagner avec moins de gains de cellules que l\'adversaire';

  @override
  String get achievement_speed_run => 'Speed Run';

  @override
  String get achievement_speed_run_desc => 'Gagner en moins de 30 secondes';

  @override
  String get achievement_high_roller => 'High Roller';

  @override
  String get achievement_high_roller_desc => 'Accumuler 100\$ au total';

  @override
  String get achievement_lucky_bastard => 'Lucky Bastard';

  @override
  String get achievement_lucky_bastard_desc =>
      'Tomber sur 5 trèfles en une session';

  @override
  String get achievement_oops => 'Oops';

  @override
  String get achievement_oops_desc =>
      'Perdre avec un score de cellules parfait';

  @override
  String get achievement_ghost => 'Fantôme';

  @override
  String get achievement_ghost_desc => 'Finir une partie avec 0\$ et 0 XP';

  @override
  String get achievement_hat_trick => 'Hat Trick';

  @override
  String get achievement_hat_trick_desc => 'Gagner 3 parties consécutives';

  @override
  String get achievement_whale => 'Whale';

  @override
  String get achievement_whale_desc => 'Gagner avec une mise de 50\$+';

  @override
  String get lobby_difficulty_easy => 'Facile';

  @override
  String get lobby_difficulty_medium => 'Moyen';

  @override
  String get lobby_difficulty_hard => 'Difficile';

  @override
  String get lobby_difficulty_expert => 'Expert';

  @override
  String get nav_lobby => 'Lobby';

  @override
  String get nav_history => 'Historique';

  @override
  String get nav_profile => 'Profil';

  @override
  String get history_title => 'Historique';

  @override
  String get history_empty => 'Aucune partie';

  @override
  String get history_emptySubtitle =>
      'Jouez votre première partie\npour voir vos résultats ici';

  @override
  String get history_result_win => 'Victoire';

  @override
  String get history_result_draw => 'Nul';

  @override
  String get history_result_loss => 'Défaite';

  @override
  String history_bet(int amount) {
    return 'Mise : \$$amount';
  }

  @override
  String get profile_comingSoon => 'Bientôt disponible';

  @override
  String get common_error_unknown => 'Une erreur inattendue s\'est produite';

  @override
  String get common_error_storage => 'Échec de la sauvegarde';
}
