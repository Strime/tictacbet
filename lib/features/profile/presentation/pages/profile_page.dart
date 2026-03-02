import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../wallet/presentation/bloc/wallet_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/achievements_section.dart';
import '../widgets/profile_header_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
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
    if (path == AppRoutes.profile) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        return;
      }
      context.read<ProfileBloc>().add(const ProfileRefreshed());
    }
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();
    context.read<ProfileBloc>().add(ProfileRefreshed(completer: completer));
    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.chipGold,
          edgeOffset: _ProfileSliverAppBar._expandedHeight,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const _ProfileSliverAppBar(),
              ...switch (state) {
                ProfileInitial() || ProfileLoading() => [
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ProfileError() => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          l10n.common_error_unknown,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ProfileLoaded(isEmpty: true) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bar_chart,
                              size: AppSpacing.iconXl,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              l10n.profile_empty,
                              style:
                                  Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.profile_emptySubtitle,
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
                ProfileLoaded() => [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ProfileHeaderCard(state: state)
                              .animate()
                              .fadeIn(),
                          const SizedBox(height: AppSpacing.xl),
                          AchievementsSection(
                                  achievements: state.achievements)
                              .animate()
                              .fadeIn(
                                  delay: const Duration(milliseconds: 100)),
                          const SizedBox(height: AppSpacing.xl),
                        ]),
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

class _ProfileSliverAppBar extends StatelessWidget {
  const _ProfileSliverAppBar();

  static const double _expandedHeight = 140.0;
  static const double _avatarExpanded = 72.0;
  static const double _avatarCollapsed = 32.0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: _expandedHeight,
      toolbarHeight: AppSpacing.appBarHeight,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final maxExtent = _expandedHeight + topPadding;
          final minExtent = AppSpacing.appBarHeight + topPadding;
          final t = ((maxExtent - constraints.maxHeight) /
                  (maxExtent - minExtent))
              .clamp(0.0, 1.0);

          return _FlexibleContent(t: t);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Flexible content — interpolates between expanded and collapsed states
// ---------------------------------------------------------------------------

class _FlexibleContent extends StatelessWidget {
  final double t;

  const _FlexibleContent({required this.t});

  static const double _avatarExpanded = _ProfileSliverAppBar._avatarExpanded;
  static const double _avatarCollapsed = _ProfileSliverAppBar._avatarCollapsed;
  static const double _expandedTitleHeight = 28.0;
  static const double _collapsedTitleHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    // Interpolated values
    final avatarSize = lerpDouble(_avatarExpanded, _avatarCollapsed, t)!;
    final borderWidth = lerpDouble(2.0, 1.5, t)!;
    final iconSize = lerpDouble(AppSpacing.iconLg, AppSpacing.iconSm, t)!;
    final balanceOpacity = (1.0 - t * 2.5).clamp(0.0, 1.0);
    final glowOpacity = (1.0 - t).clamp(0.0, 1.0);

    // Avatar position: center → left
    final avatarLeft = lerpDouble(
      (screenWidth - _avatarExpanded) / 2,
      AppSpacing.lg,
      t,
    )!;
    final avatarTop = lerpDouble(
      topPadding + AppSpacing.xl,
      topPadding + (AppSpacing.appBarHeight - _avatarCollapsed) / 2,
      t,
    )!;

    // Title collapsed position (next to avatar)
    final collapsedTitleLeft =
        AppSpacing.lg + _avatarCollapsed + AppSpacing.md;
    final collapsedTitleTop =
        topPadding + (AppSpacing.appBarHeight - _collapsedTitleHeight) / 2;

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
            top: topPadding + (AppSpacing.appBarHeight - _expandedTitleHeight) / 2,
            child: IgnorePointer(
              ignoring: t > 0.5,
              child: Opacity(
                opacity: (1.0 - t * 2.0).clamp(0.0, 1.0),
                child: Text(
                  l10n.profile_title,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
            ),
          ),

          // Collapsed title — next to avatar, fades in
          Positioned(
            left: collapsedTitleLeft,
            top: collapsedTitleTop,
            child: IgnorePointer(
              ignoring: t < 0.5,
              child: Opacity(
                opacity: (t * 2.0 - 1.0).clamp(0.0, 1.0),
                child: Text(
                  l10n.profile_title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
          ),

          // Avatar — shrinks and moves from center to top-left
          Positioned(
            left: avatarLeft,
            top: avatarTop,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceLight,
                border: Border.all(
                  color: AppColors.chipGold.withValues(alpha: 0.5),
                  width: borderWidth,
                ),
                boxShadow: [
                  if (glowOpacity > 0)
                    BoxShadow(
                      color: AppColors.chipGold
                          .withValues(alpha: 0.12 * glowOpacity),
                      blurRadius: 12 * glowOpacity,
                      spreadRadius: 2 * glowOpacity,
                    ),
                ],
              ),
              child: Icon(
                Icons.person,
                size: iconSize,
                color: AppColors.chipGold,
              ),
            ),
          ),

          // Balance — centered below the avatar, fades out early
          if (balanceOpacity > 0)
            Positioned(
              left: 0,
              right: 0,
              top: topPadding +
                  AppSpacing.xl +
                  _avatarExpanded +
                  AppSpacing.md,
              child: Opacity(
                opacity: balanceOpacity,
                child: BlocBuilder<WalletBloc, WalletState>(
                  builder: (context, walletState) {
                    final balance = walletState is WalletLoaded
                        ? walletState.balance
                        : 0;
                    return Text(
                      l10n.profile_balance(balance),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.chipGold,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
