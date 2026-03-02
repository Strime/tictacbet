import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../models/game_result_model.dart';

@injectable
class HistoryLocalDataSource {
  final Box<Map> _box;

  static const _maxEntries = 50;

  HistoryLocalDataSource(@Named('historyBox') this._box);

  List<GameResultModel> getHistory() {
    return _box.values
        .map((e) => GameResultModel.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> saveResult(GameResultModel model) async {
    await _box.add(model.toJson());

    if (_box.length > _maxEntries) {
      final keysToDelete =
          _box.keys.take(_box.length - _maxEntries).toList();
      await _box.deleteAll(keysToDelete);
    }
  }
}
