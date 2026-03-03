import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../game/domain/entities/player_side.dart';

class CampSelectionWidget extends StatelessWidget {
  final PlayerSide selectedSide;
  final ValueChanged<PlayerSide> onSideChanged;

  const CampSelectionWidget({
    super.key,
    required this.selectedSide,
    required this.onSideChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CampCard(
            side: PlayerSide.red,
            icon: LucideIcons.heart,
            color: AppColors.heartRed,
            isSelected: selectedSide == PlayerSide.red,
            onTap: () => onSideChanged(PlayerSide.red),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _CampCard(
            side: PlayerSide.black,
            icon: LucideIcons.spade,
            color: AppColors.spadeBlackLight,
            isSelected: selectedSide == PlayerSide.black,
            onTap: () => onSideChanged(PlayerSide.black),
          ),
        ),
      ],
    );
  }
}

class _CampCard extends StatelessWidget {
  final PlayerSide side;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CampCard({
    required this.side,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.03 : 1.0,
        duration: const Duration(milliseconds: AppSpacing.animationMedium),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppSpacing.animationMedium),
          height: AppSpacing.campCardHeight,
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withValues(alpha: 0.2),
                      color.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: isSelected ? color : AppColors.surfaceLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSpacing.iconXl, color: color),
              const SizedBox(height: AppSpacing.sm),
              Text(
                side.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
