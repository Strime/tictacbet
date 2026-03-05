import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../progression/presentation/bloc/progression_bloc.dart';
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
                ProfileError(:final failure) => [
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
                ProfileLoaded(isEmpty: true) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.barChart3,
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
      snap: true,
      floating: true, 
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

          return _FlexibleContent(
            t: t,
            availableWidth: constraints.maxWidth,
          );
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
  final double availableWidth;

  const _FlexibleContent({
    required this.t,
    required this.availableWidth,
  });

  static const double _avatarExpanded = _ProfileSliverAppBar._avatarExpanded;
  static const double _avatarCollapsed = _ProfileSliverAppBar._avatarCollapsed;
  static const double _expandedTitleHeight = 28.0;
  static const double _collapsedTitleHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    // Interpolated values
    final avatarSize = lerpDouble(_avatarExpanded, _avatarCollapsed, t)!;
    final borderWidth = lerpDouble(2.0, 1.5, t)!;
    final iconSize = lerpDouble(AppSpacing.iconLg, AppSpacing.iconSm, t)!;
    final balanceOpacity = (1.0 - t * 2.5).clamp(0.0, 1.0);
    final hPadding = Responsive.horizontalPaddingFromWidth(availableWidth);

    // Avatar position: left-aligned below toolbar → top-left in toolbar
    final avatarLeft = lerpDouble(
      hPadding + AppSpacing.sm,
      hPadding,
      t,
    )!;
    final avatarTop = lerpDouble(
      topPadding + AppSpacing.appBarHeight + AppSpacing.sm,
      topPadding + (AppSpacing.appBarHeight - _avatarCollapsed) / 2,
      t,
    )!;

    // Info block: right of avatar, vertically centered
    final infoLeft = hPadding + AppSpacing.sm + _avatarExpanded + AppSpacing.lg;
    final infoTop = topPadding + AppSpacing.appBarHeight + AppSpacing.sm +
        (_avatarExpanded - 48) / 2;

    // Title collapsed position (next to avatar)
    final collapsedTitleLeft =
        hPadding + _avatarCollapsed + AppSpacing.md;
    final collapsedTitleTop =
        topPadding + (AppSpacing.appBarHeight - _collapsedTitleHeight) / 2;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.chipGold.withValues(alpha: 0.15 * t),
            width: AppSpacing.thinBorderWidth,
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Expanded title — top left, fades out
          Positioned(
            left: hPadding,
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

          // Avatar — shrinks and slides up into toolbar
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
                  color: AppColors.onSurface.withValues(alpha: 0.3),
                  width: borderWidth,
                ),
              ),
              child: Icon(
                LucideIcons.user,
                size: iconSize,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Balance + Level XP — right of avatar, fades out early
          if (balanceOpacity > 0)
            Positioned(
              left: infoLeft,
              top: infoTop,
              child: Opacity(
                opacity: balanceOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, walletState) {
                        final balance = walletState is WalletLoaded
                            ? walletState.balance
                            : 0;
                        return Text(
                          l10n.profile_balance(balance),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.chipGold,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<ProgressionBloc, ProgressionState>(
                      builder: (context, progressionState) {
                        if (progressionState is! ProgressionLoaded) {
                          return const SizedBox.shrink();
                        }
                        final p = progressionState.progression;
                        final xpInLevel = p.totalXp - p.xpForCurrentLevel;
                        final xpNeeded =
                            p.xpForNextLevel - p.xpForCurrentLevel;
                        return Text(
                          l10n.profile_levelXp(p.level, xpInLevel, xpNeeded),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.xpColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Level circle — collapsed, right side, fades in
          Positioned(
            right: hPadding,
            top: topPadding +
                (AppSpacing.appBarHeight - _avatarCollapsed) / 2,
            child: Opacity(
              opacity: (t * 2.0 - 1.0).clamp(0.0, 1.0),
              child: BlocBuilder<ProgressionBloc, ProgressionState>(
                builder: (context, progressionState) {
                  final level = progressionState is ProgressionLoaded
                      ? progressionState.level
                      : 0;
                  final progress = progressionState is ProgressionLoaded
                      ? progressionState.progressFraction
                      : 0.0;
                  return _LevelCircle(
                    size: _avatarCollapsed,
                    level: level,
                    progress: progress,
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

// ---------------------------------------------------------------------------
// Circular level indicator
// ---------------------------------------------------------------------------

class _LevelCircle extends StatelessWidget {
  final double size;
  final int level;
  final double progress;

  const _LevelCircle({
    required this.size,
    required this.level,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LevelCirclePainter(
          progress: progress,
          trackColor: AppColors.surfaceLight,
          progressColor: AppColors.xpColor,
          strokeWidth: 3.0,
        ),
        child: Center(
          child: Text(
            '$level',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.xpColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelCirclePainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _LevelCirclePainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, // start from top
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_LevelCirclePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
