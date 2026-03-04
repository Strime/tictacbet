import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../game/domain/entities/player_side.dart';
import '../../../game/presentation/extensions/player_side_ui.dart';

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
        for (final side in PlayerSide.values) ...[
          if (side != PlayerSide.values.first) const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: _CampCard(
              side: side,
              isSelected: selectedSide == side,
              onTap: () => onSideChanged(side),
            ),
          ),
        ],
      ],
    );
  }
}

class _CampCard extends StatelessWidget {
  final PlayerSide side;
  final bool isSelected;
  final VoidCallback onTap;

  const _CampCard({
    required this.side,
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
                      side.color.withValues(alpha: 0.2),
                      side.color.withValues(alpha: 0.05),
                    ],
                  )
                : null,
            color: isSelected ? null : AppColors.surface,
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: isSelected ? side.color : AppColors.surfaceLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(side.icon, size: AppSpacing.iconXl, color: side.color),
              const SizedBox(height: AppSpacing.sm),
              Text(
                side.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: side.color,
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
