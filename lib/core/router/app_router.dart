import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/domain/entities/player_side.dart';
import '../../features/game/presentation/pages/game_page.dart';
import '../../features/lobby/presentation/pages/lobby_page.dart';

abstract class AppRoutes {
  static const lobby = '/';
  static const game = '/game';
  static const profile = '/profile';
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

final appRouter = GoRouter(
  initialLocation: AppRoutes.lobby,
  routes: [
    GoRoute(
      path: AppRoutes.lobby,
      builder: (context, state) => const LobbyPage(),
    ),
    GoRoute(
      path: AppRoutes.game,
      builder: (context, state) {
        final params = state.extra! as GameParams;
        return GamePage(params: params);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Profile — TODO')),
      ),
    ),
  ],
);
