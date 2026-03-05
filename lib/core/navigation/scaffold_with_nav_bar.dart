import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../utils/responsive.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isExpanded = Responsive.isExpanded(context);

    void onTap(int index) {
      HapticFeedback.lightImpact();
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    final leftItem = _NavItem(
      icon: LucideIcons.clock,
      label: l10n.nav_history,
    );
    final rightItem = _NavItem(
      icon: LucideIcons.user,
      label: l10n.nav_profile,
    );

    if (isExpanded) {
      return DecoratedBox(
        decoration: AppDecorations.backgroundGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              _TabletNavRail(
                selectedIndex: navigationShell.currentIndex,
                onTap: onTap,
                topItem: leftItem,
                centerLabel: l10n.nav_lobby,
                bottomItem: rightItem,
              ),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: AppDecorations.backgroundGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: navigationShell,
        bottomNavigationBar: _NavBar(
          selectedIndex: navigationShell.currentIndex,
          onTap: onTap,
          leftItem: leftItem,
          centerLabel: l10n.nav_lobby,
          rightItem: rightItem,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tablet navigation rail — vertical bar with casino chip in the center.
// ---------------------------------------------------------------------------
class _TabletNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final _NavItem topItem;
  final String centerLabel;
  final _NavItem bottomItem;

  static const double _railWidth = AppSpacing.navRailWidth;

  const _TabletNavRail({
    required this.selectedIndex,
    required this.onTap,
    required this.topItem,
    required this.centerLabel,
    required this.bottomItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _railWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: AppColors.surfaceLight,
            width: AppSpacing.thinBorderWidth,
          ),
        ),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            _RailDestination(
              item: topItem,
              isSelected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            const Spacer(),
            _CenterNavButton(
              semanticLabel: centerLabel,
              isSelected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            const Spacer(),
            _RailDestination(
              item: bottomItem,
              isSelected: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _RailDestination extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailDestination({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.bottomNavHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: AppSpacing.iconMd,
              color: isSelected ? AppColors.chipGold : AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.label,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? AppColors.chipGold
                        : AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
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
                      width: AppSpacing.chipBorderWidth,
                    ),
                    boxShadow:
                        isSelected ? AppShadows.glow : AppShadows.elevated,
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.dices,
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
                    item.icon,
                    key: const ValueKey('selected'),
                    size: AppSpacing.iconMd,
                    color: AppColors.chipGold,
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
