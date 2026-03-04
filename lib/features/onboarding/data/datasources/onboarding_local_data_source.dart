import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class OnboardingLocalDataSource {
  final SharedPreferences _prefs;

  static const _keyCompleted = 'onboarding_completed';

  OnboardingLocalDataSource(this._prefs);

  bool isCompleted() {
    return _prefs.getBool(_keyCompleted) ?? false;
  }

  Future<void> setCompleted(bool completed) async {
    await _prefs.setBool(_keyCompleted, completed);
  }
}
