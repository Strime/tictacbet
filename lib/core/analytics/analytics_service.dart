import 'analytics_event.dart';

/// Backend-agnostic analytics interface.
///
/// Swap the [Injectable] implementation to switch from debug logging
/// to Firebase Analytics, Mixpanel, or any other provider.
abstract interface class AnalyticsService {
  void track(AnalyticsEvent event);
}
