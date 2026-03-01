import 'package:flutter/material.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CampCard(
          side: PlayerSide.red,
          icon: Icons.favorite,
          color: AppColors.heartRed,
          isSelected: selectedSide == PlayerSide.red,
          onTap: () => onSideChanged(PlayerSide.red),
        ),
        const SizedBox(width: AppSpacing.xl),
        _CampCard(
          side: PlayerSide.black,
          icon: Icons.spa,
          color: AppColors.spadeBlackLight,
          isSelected: selectedSide == PlayerSide.black,
          onTap: () => onSideChanged(PlayerSide.black),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: AppSpacing.animationMedium),
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: isSelected ? color : AppColors.surfaceLight,
            width: isSelected ? 3 : 1,
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
    );
  }
}
