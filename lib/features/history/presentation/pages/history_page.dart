import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/history_bloc.dart';
import '../widgets/history_list_item.dart';

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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Text(
              l10n.history_title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) => switch (state) {
                HistoryInitial() || HistoryLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                HistoryError() => _ErrorContent(
                    message: l10n.common_error_unknown,
                    onRefresh: _onRefresh,
                  ),
                HistoryLoaded(isEmpty: true) => _EmptyContent(
                    l10n: l10n,
                    onRefresh: _onRefresh,
                  ),
                HistoryLoaded(:final results) => RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.chipGold,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final AppLocalizations l10n;
  final Future<void> Function() onRefresh;

  const _EmptyContent({required this.l10n, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.chipGold,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.history,
                    size: AppSpacing.iconXl,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.history_empty,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.history_emptySubtitle,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;

  const _ErrorContent({required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.chipGold,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
