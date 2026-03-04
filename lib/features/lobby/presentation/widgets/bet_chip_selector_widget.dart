import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

class BetChipSelectorWidget extends StatelessWidget {
  final int currentBet;
  final int maxBet;
  final void Function(int amount, Offset globalCenter) onAdd;
  final VoidCallback onReset;
  final void Function(Offset globalCenter) onMax;

  const BetChipSelectorWidget({
    super.key,
    required this.currentBet,
    required this.maxBet,
    required this.onAdd,
    required this.onReset,
    required this.onMax,
  });

  static const _chipValues = [1, 5, 10, 25];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chip row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _chipValues.map((value) {
            final enabled = currentBet + value <= maxBet;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _ChipButton(
                amount: value,
                enabled: enabled,
                onTap: (center) {
                  HapticFeedback.lightImpact();
                  onAdd(value, center);
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        // Reset + All In row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onReset();
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  LucideIcons.rotateCcw,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _AllInButton(
              enabled: currentBet < maxBet,
              onTap: (center) {
                HapticFeedback.mediumImpact();
                onMax(center);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ChipButton extends StatefulWidget {
  final int amount;
  final bool enabled;
  final ValueChanged<Offset> onTap;

  const _ChipButton({
    required this.amount,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ChipButton> createState() => _ChipButtonState();
}

class _ChipButtonState extends State<_ChipButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppSpacing.animationFast),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _controller.forward().then((_) => _controller.reverse());
    final box = context.findRenderObject() as RenderBox;
    final center = box.localToGlobal(
      Offset(box.size.width / 2, box.size.height / 2),
    );
    widget.onTap(center);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.4,
          duration: const Duration(milliseconds: AppSpacing.animationFast),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(color: AppColors.chipGold, width: 2.5),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: AppColors.chipGold.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '\$${widget.amount}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.chipGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AllInButton extends StatefulWidget {
  final bool enabled;
  final ValueChanged<Offset> onTap;

  const _AllInButton({required this.enabled, required this.onTap});

  @override
  State<_AllInButton> createState() => _AllInButtonState();
}

class _AllInButtonState extends State<_AllInButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppSpacing.animationFast),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;
    _controller.forward().then((_) => _controller.reverse());
    final box = context.findRenderObject() as RenderBox;
    final center = box.localToGlobal(
      Offset(box.size.width / 2, box.size.height / 2),
    );
    widget.onTap(center);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.4,
          duration: const Duration(milliseconds: AppSpacing.animationFast),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.chipGold, AppColors.chipGoldDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppSpacing.borderRadiusSm,
              boxShadow: widget.enabled ? AppShadows.glow : null,
            ),
            child: Text(
              'ALL IN',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
