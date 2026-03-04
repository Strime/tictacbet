import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/domain/entities/player_side.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/lobby/presentation/pages/lobby_page.dart';
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../injection.dart';
import '../navigation/scaffold_with_nav_bar.dart';

abstract class AppRoutes {
  static const lobby = '/';
  static const game = '/game';
  static const history = '/history';
  static const profile = '/profile';
  static const onboarding = '/onboarding';
}

class GameParams {
  final PlayerSide humanSide;
  final double aiLevel;
  final int betAmount;

  const GameParams({
    required this.humanSide,
    required this.aiLevel,
    required this.betAmount,
  });
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _lobbyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'lobby');
final _historyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'history');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final _onboardingDataSource = getIt<OnboardingLocalDataSource>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.lobby,
  redirect: (context, state) {
    final isOnboardingRoute = state.matchedLocation == AppRoutes.onboarding;

    if (!_onboardingDataSource.isCompleted() && !isOnboardingRoute) {
      return AppRoutes.onboarding;
    }
    if (_onboardingDataSource.isCompleted() && isOnboardingRoute) {
      return AppRoutes.lobby;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<OnboardingCubit>(),
        child: OnboardingPage(
          onComplete: () => appRouter.go(AppRoutes.lobby),
        ),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _historyNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.history,
              builder: (context, state) => const HistoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _lobbyNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.lobby,
              builder: (context, state) => const LobbyPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.game,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final params = state.extra! as GameParams;
        return GamePage(params: params);
      },
    ),
  ],
);
