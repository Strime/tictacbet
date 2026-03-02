import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ProgressionLocalDataSource {
  final SharedPreferences _prefs;

  static const _keyTotalXp = 'progression_total_xp';
  static const _keyCurrentWinStreak = 'progression_current_win_streak';
  static const _keyBestWinStreak = 'progression_best_win_streak';

  ProgressionLocalDataSource(this._prefs);

  int getTotalXp() => _prefs.getInt(_keyTotalXp) ?? 0;

  Future<void> setTotalXp(int value) => _prefs.setInt(_keyTotalXp, value);

  int getCurrentWinStreak() => _prefs.getInt(_keyCurrentWinStreak) ?? 0;

  Future<void> setCurrentWinStreak(int value) =>
      _prefs.setInt(_keyCurrentWinStreak, value);

  int getBestWinStreak() => _prefs.getInt(_keyBestWinStreak) ?? 0;

  Future<void> setBestWinStreak(int value) =>
      _prefs.setInt(_keyBestWinStreak, value);
}
