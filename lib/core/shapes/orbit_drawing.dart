import 'dart:math' as math;

import 'package:flutter/material.dart';

void drawDashedEllipse(
  Canvas canvas,
  Offset center,
  double rx,
  double ry,
  double rotation,
  Color color, {
  double strokeWidth = 1.4,
  double dash = 4,
  double gap = 5,
}) {
  canvas.save();
  canvas.translate(center.dx, center.dy);
  canvas.rotate(rotation);

  final path = Path()
    ..addOval(
      Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
    );
  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = color;

  for (final metric in path.computeMetrics()) {
    double d = 0;
    while (d < metric.length) {
      canvas.drawPath(
        metric.extractPath(d, math.min(d + dash, metric.length)),
        paint,
      );
      d += dash + gap;
    }
  }
  canvas.restore();
}

void drawPlanetDisc(
  Canvas canvas,
  Offset p,
  double r,
  Color color,
  Color shadow,
) {
  canvas.drawCircle(p + const Offset(2, 2), r, Paint()..color = shadow);
  canvas.drawCircle(p, r, Paint()..color = color);
  canvas.drawCircle(
    p + Offset(r * 0.3, -r * 0.3),
    r * 0.18,
    Paint()..color = const Color.fromRGBO(255, 255, 255, 0.3),
  );
}

void drawSunDisc(Canvas canvas, Offset c, double r, Color sun, Color shadow) {
  canvas.drawCircle(c + const Offset(2, 2), r, Paint()..color = shadow);
  canvas.drawCircle(c, r, Paint()..color = sun);
  canvas.drawCircle(
    c,
    r * 0.4,
    Paint()..color = const Color.fromRGBO(255, 255, 255, 0.45),
  );
}
