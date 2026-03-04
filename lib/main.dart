import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/analytics/analytics_bloc_observer.dart';
import 'core/analytics/analytics_service.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  Bloc.observer = AnalyticsBlocObserver(getIt<AnalyticsService>());
  runApp(const App());
}
