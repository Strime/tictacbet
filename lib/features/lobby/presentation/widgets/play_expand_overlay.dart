import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../game/presentation/widgets/card_back_painter.dart';

/// Shows an overlay that:
/// 1. Expands from [fromRect] to full screen (phase 1)
/// 2. Builds a 3x3 board of card backs with staggered reveal (phase 2)
/// 3. Fades out to reveal the real GamePage underneath (phase 3)
///
/// [onExpanded] is called at the start of phase 2 (push GamePage behind).
/// [onComplete] is called when the full animation finishes (remove overlay).
OverlayEntry showPlayExpandOverlay({
  required BuildContext context,
  required Rect fromRect,
  required int betAmount,
  required VoidCallback onExpanded,
  required VoidCallback onComplete,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _PlayExpandAnimation(
      fromRect: fromRect,
      betAmount: betAmount,
      onExpanded: onExpanded,
      onComplete: onComplete,
    ),
  );

  overlay.insert(entry);
  return entry;
}

class _PlayExpandAnimation extends StatefulWidget {
  final Rect fromRect;
  final int betAmount;
  final VoidCallback onExpanded;
  final VoidCallback onComplete;

  const _PlayExpandAnimation({
    required this.fromRect,
    required this.betAmount,
    required this.onExpanded,
    required this.onComplete,
  });

  @override
  State<_PlayExpandAnimation> createState() => _PlayExpandAnimationState();
}

class _PlayExpandAnimationState extends State<_PlayExpandAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _didCallExpanded = false;

  // Phase boundaries (normalized 0–1)
  static const _expandEnd = 0.33; // ~400ms
  static const _boardEnd = 0.87; // ~650ms for board build
  // 0.87–1.0 = fade out (~150ms)

  static const _totalDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..addListener(_checkExpanded)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      })
      ..forward();
  }

  void _checkExpanded() {
    if (!_didCallExpanded && _controller.value >= _expandEnd) {
      _didCallExpanded = true;
      widget.onExpanded();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final fullRect = Offset.zero & screen;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final v = _controller.value;

        // Phase 1: Expand bar → full screen
        final expandT =
            Curves.easeInCubic.transform((v / _expandEnd).clamp(0.0, 1.0));
        final rect = Rect.lerp(widget.fromRect, fullRect, expandT)!;
        final radius = lerpDouble(AppSpacing.radiusLg, 0.0, expandT)!;

        // Phase 3: Fade out
        final fadeT = ((v - _boardEnd) / (1.0 - _boardEnd)).clamp(0.0, 1.0);
        final opacity = lerpDouble(1.0, 0.0, Curves.easeIn.transform(fadeT))!;

        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: Opacity(
            opacity: opacity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.feltGreen,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: v >= _expandEnd
                  ? _BoardPreview(
                      progress:
                          ((v - _expandEnd) / (_boardEnd - _expandEnd))
                              .clamp(0.0, 1.0),
                      betAmount: widget.betAmount,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}

/// Renders a 3x3 grid of card backs appearing one by one.
class _BoardPreview extends StatelessWidget {
  final double progress;
  final int betAmount;

  const _BoardPreview({required this.progress, required this.betAmount});

  static const _cellCount = 9;
  static const _staggerFraction = 1.0 / (_cellCount + 2);

  @override
  Widget build(BuildContext context) {
    // Bet badge appears early in the board-build phase
    final betOpacity = Curves.easeOut.transform(progress.clamp(0.0, 0.3) / 0.3);
    final betScale = lerpDouble(0.7, 1.0, betOpacity)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Animated bet badge
            Opacity(
              opacity: betOpacity,
              child: Transform.scale(
                scale: betScale,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.history_bet(betAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.chipGold,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: AppSpacing.cardAspectRatio,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.8),
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(
                        color: AppColors.chipGold.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: AppSpacing.cardAspectRatio,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                        ),
                        itemCount: _cellCount,
                        itemBuilder: (_, index) {
                          final cellStart = index * _staggerFraction;
                          final cellProgress =
                              ((progress - cellStart) / (2 * _staggerFraction))
                                  .clamp(0.0, 1.0);

                          return _AnimatedCell(progress: cellProgress);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Invisible placeholder matching GamePage's bottom widgets
            const SizedBox(height: AppSpacing.lg),
            // Mirror _TurnIndicator exact structure (invisible)
            Opacity(
              opacity: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusRound),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: AppSpacing.iconSm,
                      height: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      ' ',
                      style:
                          Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCell extends StatelessWidget {
  final double progress;

  const _AnimatedCell({required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final scale = lerpDouble(0.8, 1.0, Curves.easeOut.transform(progress))!;

    return Opacity(
      opacity: progress,
      child: Transform.scale(
        scale: scale,
        child: Container(
          decoration: AppDecorations.cellHidden,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            child: const CustomPaint(
              painter: CardBackPainter(),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }
}
