import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Simple responsive utilities — two buckets: compact (phone) / expanded (tablet).
class Responsive {
  Responsive._();

  /// Screens wider than this are considered "expanded" (tablet).
  static const double compactMaxWidth = 600.0;

  /// Maximum content width on expanded screens.
  static const double contentMaxWidth = 560.0;

  /// Maximum board width — tighter than content for visual balance.
  static const double boardMaxWidth = 480.0;

  /// Whether the current screen is in expanded (tablet) mode.
  static bool isExpanded(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= compactMaxWidth;

  /// Returns symmetric horizontal padding that centers content to
  /// [contentMaxWidth] within the given [width].
  ///
  /// On compact screens returns [base]. On expanded screens returns enough
  /// padding to constrain content to [contentMaxWidth].
  ///
  /// Takes an explicit [width] rather than reading from [MediaQuery] so it
  /// works correctly inside [LayoutBuilder] callbacks where the available
  /// width differs from the screen width (e.g. when a [NavigationRail] is
  /// present).
  static double horizontalPaddingFromWidth(
    double width, {
    double base = AppSpacing.lg,
  }) {
    if (width <= compactMaxWidth) return base;
    return math.max(base, (width - contentMaxWidth) / 2);
  }
}

/// Constrains its [child] to [Responsive.contentMaxWidth] centered on tablets.
///
/// On compact screens the child is returned unchanged.
class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = Responsive.contentMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isExpanded(context)) return child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
