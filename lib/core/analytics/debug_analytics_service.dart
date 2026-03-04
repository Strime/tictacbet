import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';

import 'analytics_event.dart';
import 'analytics_service.dart';

/// Logs analytics events to the Dart DevTools console.
///
/// Swap the [LazySingleton] annotation to a production implementation
/// (e.g. FirebaseAnalyticsService) when ready — no other files change.
@LazySingleton(as: AnalyticsService)
class DebugAnalyticsService implements AnalyticsService {
  @override
  void track(AnalyticsEvent event) {
    developer.log(
      '[${event.name}] ${event.properties}',
      name: 'Analytics',
    );
  }
}
