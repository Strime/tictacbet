import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
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
        items: [
          _NavItem(
            icon: Icons.casino_outlined,
            selectedIcon: Icons.casino,
            label: l10n.nav_lobby,
          ),
          _NavItem(
            icon: Icons.history_outlined,
            selectedIcon: Icons.history,
            label: l10n.nav_history,
          ),
          _NavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: l10n.nav_profile,
          ),
        ],
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
  final List<_NavItem> items;

  const _NavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.bottomNavHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.surfaceLight, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: _NavDestination(
                item: items[index],
                isSelected: index == selectedIndex,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}

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
