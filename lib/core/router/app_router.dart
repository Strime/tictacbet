import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const lobby = '/';
  static const game = '/game';
  static const profile = '/profile';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.lobby,
  routes: [
    GoRoute(
      path: AppRoutes.lobby,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Lobby — TODO')),
      ),
    ),
    GoRoute(
      path: AppRoutes.game,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Game — TODO')),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Profile — TODO')),
      ),
    ),
  ],
);
