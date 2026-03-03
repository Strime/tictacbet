import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/game_result_entity.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_list_item.dart';
import '../widgets/stats_row.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryBloc>()..add(const HistoryStarted()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    appRouter.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    appRouter.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    final path = appRouter.routeInformationProvider.value.uri.path;
    if (path == AppRoutes.history) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        return;
      }
      context.read<HistoryBloc>().add(const HistoryRefreshed());
    }
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    context.read<HistoryBloc>().add(HistoryRefreshed(completer: completer));
    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final results =
            state is HistoryLoaded ? state.results : <GameResultEntity>[];
        final wins = results.where((r) => r.isWin).length;
        final losses = results.where((r) => r.isLoss).length;
        final draws = results.where((r) => r.isDraw).length;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.chipGold,
          edgeOffset: _HistorySliverAppBar._expandedHeight,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _HistorySliverAppBar(
                wins: wins,
                losses: losses,
                draws: draws,
                hasStats: state is HistoryLoaded && !state.isEmpty,
              ),
              ...switch (state) {
                HistoryInitial() || HistoryLoading() => [
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                HistoryError(:final failure) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          failure.toLocalizedMessage(l10n),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ),
                    ),
                  ],
                HistoryLoaded(isEmpty: true) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.clock,
                              size: AppSpacing.iconXl,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.history_empty,
                              style:
                                  Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.history_emptySubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                HistoryLoaded(:final results) => [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      sliver: SliverList.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (_, index) => HistoryListItem(
                          result: results[index],
                        ).animate().fadeIn(
                              delay: Duration(milliseconds: index * 50),
                            ),
                      ),
                    ),
                  ],
              },
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SliverAppBar
// ---------------------------------------------------------------------------

class _HistorySliverAppBar extends StatelessWidget {
  const _HistorySliverAppBar({
    required this.wins,
    required this.losses,
    required this.draws,
    required this.hasStats,
  });

  final int wins;
  final int losses;
  final int draws;
  final bool hasStats;

  static const double _expandedHeight = 160.0;
  static const double _expandedTitleHeight = 28.0;
  static const double _collapsedTitleHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: hasStats ? _expandedHeight : AppSpacing.appBarHeight,
      toolbarHeight: AppSpacing.appBarHeight,
      pinned: true,
      snap: true,
      floating: true, 
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: hasStats
          ? LayoutBuilder(
              builder: (context, constraints) {
                final maxExtent = _expandedHeight + topPadding;
                final minExtent = AppSpacing.appBarHeight + topPadding;
                final t = ((maxExtent - constraints.maxHeight) /
                        (maxExtent - minExtent))
                    .clamp(0.0, 1.0);

                return _FlexibleContent(
                  t: t,
                  wins: wins,
                  losses: losses,
                  draws: draws,
                );
              },
            )
          : _StaticTitle(),
    );
  }
}

// ---------------------------------------------------------------------------
// Static title — used when no stats to show (loading, error, empty)
// ---------------------------------------------------------------------------

class _StaticTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(top: topPadding),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Text(
          l10n.history_title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Flexible content — interpolates between expanded and collapsed states
// ---------------------------------------------------------------------------

class _FlexibleContent extends StatelessWidget {
  final double t;
  final int wins;
  final int losses;
  final int draws;

  const _FlexibleContent({
    required this.t,
    required this.wins,
    required this.losses,
    required this.draws,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    final statsOpacity = (1.0 - t * 2.0).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.chipGold.withValues(alpha: 0.15 * t),
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Expanded title — top left, fades out
          Positioned(
            left: AppSpacing.lg,
            top: topPadding +
                (AppSpacing.appBarHeight -
                        _HistorySliverAppBar._expandedTitleHeight) /
                    2,
            child: IgnorePointer(
              ignoring: t > 0.5,
              child: Opacity(
                opacity: (1.0 - t * 2.0).clamp(0.0, 1.0),
                child: Text(
                  l10n.history_title,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
            ),
          ),

          // Collapsed title + compact stats — fades in
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: topPadding +
                (AppSpacing.appBarHeight -
                        _HistorySliverAppBar._collapsedTitleHeight) /
                    2,
            child: IgnorePointer(
              ignoring: t < 0.5,
              child: Opacity(
                opacity: (t * 2.0 - 1.0).clamp(0.0, 1.0),
                child: Row(
                  children: [
                    Text(
                      l10n.history_title,
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Text(
                      '$wins',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '$losses',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '$draws',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.chipGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // StatsRow — below the title, fades out on scroll
          if (statsOpacity > 0)
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: topPadding + AppSpacing.appBarHeight + AppSpacing.sm,
              child: Opacity(
                opacity: statsOpacity,
                child: StatsRow(
                  wins: wins,
                  losses: losses,
                  draws: draws,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
