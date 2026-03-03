import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Returns the number of coins to show for a given chip [amount].
/// Scales as sqrt(amount) * 1.5, clamped to [1, 10].
@visibleForTesting
int coinCountForAmount(int amount) =>
    amount <= 1 ? 1 : (sqrt(amount) * 1.5).round().clamp(1, 10);

/// Inserts fire-and-forget coin-drop overlays that animate from [from] to [to]
/// along parabolic arcs. The number of coins scales with [amount].
void showCoinDrop({
  required BuildContext context,
  required Offset from,
  required Offset to,
  int amount = 1,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final coinCount = coinCountForAmount(amount);
  final rng = Random();

  for (var i = 0; i < coinCount; i++) {
    late final OverlayEntry entry;
    final delay = Duration(milliseconds: i * 40);
    final arcJitter = (rng.nextDouble() - 0.5) * 30;
    final xJitter = (rng.nextDouble() - 0.5) * 16;

    entry = OverlayEntry(
      builder: (_) => _CoinDropAnimation(
        from: from,
        to: to,
        delay: delay,
        arcJitter: arcJitter,
        xJitter: xJitter,
        onComplete: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }
}

class _CoinDropAnimation extends StatefulWidget {
  final Offset from;
  final Offset to;
  final Duration delay;
  final double arcJitter;
  final double xJitter;
  final VoidCallback onComplete;

  const _CoinDropAnimation({
    required this.from,
    required this.to,
    this.delay = Duration.zero,
    this.arcJitter = 0,
    this.xJitter = 0,
    required this.onComplete,
  });

  @override
  State<_CoinDropAnimation> createState() => _CoinDropAnimationState();
}

class _CoinDropAnimationState extends State<_CoinDropAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _duration = Duration(milliseconds: 450);
  static const _coinSize = 28.0;
  static const _arcHeight = -60.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = Curves.easeOut.transform(_controller.value);

        // X: linear interpolation + jitter
        final x = lerpDouble(widget.from.dx, widget.to.dx + widget.xJitter, t)!;

        // Y: linear + parabolic arc (upward bump before falling) + jitter
        final linearY = lerpDouble(widget.from.dy, widget.to.dy, t)!;
        final arcOffset = (_arcHeight + widget.arcJitter) * 4 * t * (1 - t);
        final y = linearY + arcOffset;

        // Scale: shrink as it approaches target
        final scale = lerpDouble(1.0, 0.5, t)!;

        // Opacity: fade out in the last 20%
        final opacity = t > 0.8 ? lerpDouble(1.0, 0.0, (t - 0.8) / 0.2)! : 1.0;

        final halfCoin = _coinSize * scale / 2;

        return Positioned(
          left: x - halfCoin,
          top: y - halfCoin,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: const _Coin(),
            ),
          ),
        );
      },
    );
  }
}

class _Coin extends StatelessWidget {
  static const _size = 28.0;

  const _Coin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.chipGold,
        boxShadow: [
          BoxShadow(
            color: AppColors.chipGold.withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '\$',
          style: TextStyle(
            color: AppColors.surface,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
