import 'package:flutter/material.dart';
import 'dart:math' as math;

class IslamicPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // A sophisticated yet simple Islamic geometric pattern
    // Based on an 8-fold rosette or star pattern grid

    final Paint linePaint = Paint()
      ..color = const Color(0xFFD4AF37)
          .withValues(alpha: 0.05) // Very subtle gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double radius = size.width * 0.8;

    // Draw central star
    _drawStar(canvas, cx, cy, radius * 0.4, linePaint, 8);
    _drawStar(canvas, cx, cy, radius * 0.7, linePaint, 16);

    // Draw repeating grid (simulated)
    double step = 60.0;
    for (double x = 0; x < size.width + step; x += step) {
      for (double y = 0; y < size.height + step; y += step) {
        if ((x / step).round() % 2 == (y / step).round() % 2) {
          _drawSimpleMotif(canvas, x, y, step * 0.4, linePaint);
        }
      }
    }
  }

  void _drawStar(
    Canvas canvas,
    double cx,
    double cy,
    double r,
    Paint paint,
    int points,
  ) {
    if (points < 3) return;
    // Draw two interlaced polygons? Or just a simple star path.
    // Let's draw a simple parametric star.

    final Path path = Path();
    double angleStep = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      double angle = i * angleStep;
      double currR = (i % 2 == 0) ? r : r * 0.5; // Inner/Outer radius
      double x = cx + currR * math.cos(angle);
      double y = cy + currR * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSimpleMotif(
    Canvas canvas,
    double x,
    double y,
    double r,
    Paint paint,
  ) {
    // A simple octagonal motif
    _drawStar(canvas, x, y, r, paint, 8);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
