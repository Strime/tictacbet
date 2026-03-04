import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/achievement.dart';

/// Maps [AchievementType] to user-facing localized texts.
extension AchievementTypeMessage on AchievementType {
  String label(AppLocalizations l10n) => switch (this) {
        AchievementType.speedRun => l10n.achievement_speed_run,
        AchievementType.highRoller => l10n.achievement_high_roller,
        AchievementType.hatTrick => l10n.achievement_hat_trick,
        AchievementType.whale => l10n.achievement_whale,
        AchievementType.allIn => l10n.achievement_all_in,
        AchievementType.comeback => l10n.achievement_comeback,
        AchievementType.oops => l10n.achievement_oops,
        AchievementType.ghost => l10n.achievement_ghost,
        AchievementType.goldenParachute => l10n.achievement_golden_parachute,
        AchievementType.paperHands => l10n.achievement_paper_hands,
        AchievementType.doubleAgent => l10n.achievement_double_agent,
        AchievementType.redMaster => l10n.achievement_red_master,
        AchievementType.blackMaster => l10n.achievement_black_master,
      };

  String description(AppLocalizations l10n) => switch (this) {
        AchievementType.speedRun => l10n.achievement_speed_run_desc,
        AchievementType.highRoller => l10n.achievement_high_roller_desc,
        AchievementType.hatTrick => l10n.achievement_hat_trick_desc,
        AchievementType.whale => l10n.achievement_whale_desc,
        AchievementType.allIn => l10n.achievement_all_in_desc,
        AchievementType.comeback => l10n.achievement_comeback_desc,
        AchievementType.oops => l10n.achievement_oops_desc,
        AchievementType.ghost => l10n.achievement_ghost_desc,
        AchievementType.goldenParachute => l10n.achievement_golden_parachute_desc,
        AchievementType.paperHands => l10n.achievement_paper_hands_desc,
        AchievementType.doubleAgent => l10n.achievement_double_agent_desc,
        AchievementType.redMaster => l10n.achievement_red_master_desc,
        AchievementType.blackMaster => l10n.achievement_black_master_desc,
      };
}
