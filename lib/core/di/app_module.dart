import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  @Named('historyBox')
  Future<Box<Map>> get historyBox => Hive.openBox<Map>('game_history');
}
