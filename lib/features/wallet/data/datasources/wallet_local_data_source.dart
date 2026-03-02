import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/game_constants.dart';

@injectable
class WalletLocalDataSource {
  final SharedPreferences _prefs;

  static const _keyBalance = 'wallet_balance';
  static const _keyLastBonusDate = 'wallet_last_bonus_date';

  WalletLocalDataSource(this._prefs);

  int getBalance() {
    return _prefs.getInt(_keyBalance) ?? GameConstants.initialBalance;
  }

  Future<void> setBalance(int balance) async {
    await _prefs.setInt(_keyBalance, balance);
  }

  DateTime? getLastBonusDate() {
    final dateStr = _prefs.getString(_keyLastBonusDate);
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }

  Future<void> setLastBonusDate(DateTime date) async {
    await _prefs.setString(_keyLastBonusDate, date.toIso8601String());
  }
}
