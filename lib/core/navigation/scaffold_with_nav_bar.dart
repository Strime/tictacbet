import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _NavBar(
        selectedIndex: navigationShell.currentIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        leftItem: _NavItem(
          icon: Icons.history_outlined,
          selectedIcon: Icons.history,
          label: l10n.nav_history,
        ),
        centerLabel: l10n.nav_lobby,
        rightItem: _NavItem(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          label: l10n.nav_profile,
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final _NavItem leftItem;
  final String centerLabel;
  final _NavItem rightItem;

  const _NavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.leftItem,
    required this.centerLabel,
    required this.rightItem,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final barHeight = AppSpacing.bottomNavHeight + bottomPadding;

    return SizedBox(
      height: barHeight + AppSpacing.navFabOverhang,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Notched bar background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: CustomPaint(
              painter: _NotchedBarPainter(
                notchRadius:
                    AppSpacing.navFabSize / 2 + AppSpacing.navNotchMargin,
                backgroundColor: AppColors.surface,
                borderColor: AppColors.surfaceLight,
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: _NavDestination(
                        item: leftItem,
                        isSelected: selectedIndex == 0,
                        onTap: () => onTap(0),
                      ),
                    ),
                    SizedBox(
                      width: (AppSpacing.navFabSize / 2 +
                              AppSpacing.navNotchMargin) *
                          2,
                    ),
                    Expanded(
                      child: _NavDestination(
                        item: rightItem,
                        isSelected: selectedIndex == 2,
                        onTap: () => onTap(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Center casino chip button
          Positioned(
            bottom: bottomPadding +
                (AppSpacing.bottomNavHeight - AppSpacing.navFabSize) / 2,
            left: 0,
            right: 0,
            child: Center(
              child: _CenterNavButton(
                semanticLabel: centerLabel,
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notched bar painter — draws the surface background with a semicircular
// cutout at the top-center for the casino chip to sit in.
// ---------------------------------------------------------------------------
class _NotchedBarPainter extends CustomPainter {
  final double notchRadius;
  final Color backgroundColor;
  final Color borderColor;

  const _NotchedBarPainter({
    required this.notchRadius,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;

    // Bar path with notch cutout
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(center - notchRadius, 0)
      ..arcTo(
        Rect.fromCircle(center: Offset(center, 0), radius: notchRadius),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Fill
    canvas.drawPath(
      path,
      Paint()..color = backgroundColor,
    );

    // Border line following the notch curve
    final borderPath = Path()
      ..moveTo(0, 0)
      ..lineTo(center - notchRadius, 0)
      ..arcTo(
        Rect.fromCircle(center: Offset(center, 0), radius: notchRadius),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(size.width, 0);

    canvas.drawPath(
      borderPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_NotchedBarPainter oldDelegate) =>
      notchRadius != oldDelegate.notchRadius ||
      backgroundColor != oldDelegate.backgroundColor ||
      borderColor != oldDelegate.borderColor;
}

// ---------------------------------------------------------------------------
// Casino chip center button — gold ring with notch marks, feltGreen gradient,
// pulsing glow when selected, scale bounce on selection change.
// ---------------------------------------------------------------------------
class _CenterNavButton extends StatelessWidget {
  final String semanticLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterNavButton({
    required this.semanticLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.08 : 1.0,
          duration: const Duration(milliseconds: AppSpacing.animationMedium),
          curve: Curves.elasticOut,
          child: SizedBox(
            width: AppSpacing.navFabSize + AppSpacing.sm,
            height: AppSpacing.navFabSize + AppSpacing.sm,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulsing glow behind the chip when selected
                if (isSelected)
                  Container(
                    width: AppSpacing.navFabSize + AppSpacing.sm,
                    height: AppSpacing.navFabSize + AppSpacing.sm,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.chipGold.withValues(alpha: 0.35),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),

                // Chip body with gold ring + notch marks
                Container(
                  width: AppSpacing.navFabSize,
                  height: AppSpacing.navFabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.feltGreenLight,
                        AppColors.feltGreen,
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.chipGold,
                      width: 3.0,
                    ),
                    boxShadow:
                        isSelected ? AppShadows.glow : AppShadows.elevated,
                  ),
                  child: Center(
                    child: Icon(
                      isSelected ? Icons.casino : Icons.casino_outlined,
                      size: AppSpacing.iconLg,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Standard nav destination (History / Profile side items).
// ---------------------------------------------------------------------------
class _NavDestination extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavDestination({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: AppSpacing.animationMedium),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: isSelected
                ? Icon(
                    item.selectedIcon,
                    key: const ValueKey('selected'),
                    size: AppSpacing.iconMd,
                    color: AppColors.chipGold,
                  )
                    .animate(
                      onPlay: (c) => c.repeat(reverse: true),
                    )
                    .shimmer(
                      delay: 1.seconds,
                      duration: 2.seconds,
                      color: AppColors.chipGold.withValues(alpha: 0.3),
                    )
                : Icon(
                    item.icon,
                    key: const ValueKey('unselected'),
                    size: AppSpacing.iconMd,
                    color: AppColors.textSecondary,
                  ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: AppSpacing.animationMedium),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.chipGold : AppColors.textSecondary,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
