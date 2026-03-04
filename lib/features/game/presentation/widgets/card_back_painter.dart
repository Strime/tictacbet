import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class CardBackPainter extends CustomPainter {
  const CardBackPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawBorders(canvas, size);
    _drawPatterns(canvas, size);
    _drawMedallion(canvas, size);
    _drawCornerAccents(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = const RadialGradient(
        radius: 0.8,
        colors: [AppColors.feltGreen, AppColors.feltGreenDark],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bgPaint);
  }

  void _drawBorders(Canvas canvas, Size size) {
    // Single inner frame
    const frameInset = AppSpacing.sm;
    final frameRect = Rect.fromLTWH(
      frameInset,
      frameInset,
      size.width - frameInset * 2,
      size.height - frameInset * 2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(AppSpacing.xxs)),
      Paint()
        ..color = AppColors.chipGold.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawPatterns(Canvas canvas, Size size) {
    const patternInset = AppSpacing.sm + AppSpacing.xs;

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          patternInset,
          patternInset,
          size.width - patternInset * 2,
          size.height - patternInset * 2,
        ),
        const Radius.circular(AppSpacing.xxs),
      ),
    );

    // Coarse diamond lattice
    final coarsePaint = Paint()
      ..color = AppColors.feltGreenLight.withValues(alpha: 0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const coarseSpacing = AppSpacing.lg;
    for (var i = -size.height; i < size.width + size.height; i += coarseSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), coarsePaint);
      canvas.drawLine(Offset(i + size.height, 0), Offset(i, size.height), coarsePaint);
    }

    // Fine crosshatch overlay
    final finePaint = Paint()
      ..color = AppColors.feltGreen.withValues(alpha: 0.35)
      ..strokeWidth = AppSpacing.thinBorderWidth
      ..style = PaintingStyle.stroke;

    const fineSpacing = AppSpacing.sm;
    for (var i = -size.height; i < size.width + size.height; i += fineSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), finePaint);
      canvas.drawLine(Offset(i + size.height, 0), Offset(i, size.height), finePaint);
    }

    canvas.restore();
  }

  void _drawMedallion(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer diamond
    const outerSize = AppSpacing.xl;
    final outerDiamond = Path()
      ..moveTo(cx, cy - outerSize)
      ..lineTo(cx + outerSize, cy)
      ..lineTo(cx, cy + outerSize)
      ..lineTo(cx - outerSize, cy)
      ..close();

    canvas.drawPath(
      outerDiamond,
      Paint()..color = AppColors.feltGreenDark.withValues(alpha: 0.6),
    );
    canvas.drawPath(
      outerDiamond,
      Paint()
        ..color = AppColors.chipGold.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Inner diamond
    const innerSize = AppSpacing.lg;
    final innerDiamond = Path()
      ..moveTo(cx, cy - innerSize)
      ..lineTo(cx + innerSize, cy)
      ..lineTo(cx, cy + innerSize)
      ..lineTo(cx - innerSize, cy)
      ..close();

    canvas.drawPath(
      innerDiamond,
      Paint()
        ..color = AppColors.chipGold.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSpacing.thinBorderWidth,
    );

    // Center pip
    const pipSize = AppSpacing.xs;
    final centerPip = Path()
      ..moveTo(cx, cy - pipSize)
      ..lineTo(cx + pipSize, cy)
      ..lineTo(cx, cy + pipSize)
      ..lineTo(cx - pipSize, cy)
      ..close();

    canvas.drawPath(
      centerPip,
      Paint()..color = AppColors.chipGold.withValues(alpha: 0.35),
    );
  }

  void _drawCornerAccents(Canvas canvas, Size size) {
    const cornerInset = AppSpacing.sm + AppSpacing.xs;
    const cornerSize = AppSpacing.xs;

    final cornerPaint = Paint()
      ..color = AppColors.chipGold.withValues(alpha: 0.3);

    final corners = [
      Offset(cornerInset, cornerInset),
      Offset(size.width - cornerInset, cornerInset),
      Offset(cornerInset, size.height - cornerInset),
      Offset(size.width - cornerInset, size.height - cornerInset),
    ];

    for (final offset in corners) {
      final pip = Path()
        ..moveTo(offset.dx, offset.dy - cornerSize)
        ..lineTo(offset.dx + cornerSize, offset.dy)
        ..lineTo(offset.dx, offset.dy + cornerSize)
        ..lineTo(offset.dx - cornerSize, offset.dy)
        ..close();
      canvas.drawPath(pip, cornerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
