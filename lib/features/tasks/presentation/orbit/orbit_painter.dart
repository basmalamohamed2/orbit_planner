import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/shapes/orbit_drawing.dart';
import 'package:orbit_planner/core/shapes/star_path.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_layout.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';

class OrbitRingsPainter extends CustomPainter {
  OrbitRingsPainter({required this.colors});

  final OrbitColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);
    final ringColor = Color.lerp(colors.outline, colors.muted, 0.35)!;

    for (var r = 0; r < OrbitLayout.ringCount; r++) {
      final rx = OrbitLayout.ringRadii[r] * s;
      drawDashedEllipse(
        canvas,
        center,
        rx,
        rx * OrbitLayout.ellipseRatio,
        OrbitLayout.ringTilts[r],
        ringColor,
      );
    }
    drawSunDisc(
      canvas,
      center,
      OrbitLayout.sunRadius * s,
      colors.sun,
      colors.shadow,
    );
  }

  @override
  bool shouldRepaint(OrbitRingsPainter old) => old.colors != colors;
}

class OrbitPlanetsPainter extends CustomPainter {
  OrbitPlanetsPainter({
    required this.planets,
    required this.colors,
    required this.animation,
    required this.selectedId,
  }) : super(repaint: animation);

  final List<OrbitPlanet> planets;
  final OrbitColors colors;
  final Animation<double> animation;
  final String? selectedId;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final t = animation.value;

    for (final planet in planets) {
      final pos = OrbitLayout.positionOf(planet, t, s);
      final r = OrbitLayout.planetRadius(planet.task.priority) * s;

      drawPlanetDisc(
        canvas,
        pos,
        r,
        planet.task.category.color(colors),
        colors.shadow,
      );

      if (planet.task.id == selectedId) {
        canvas.drawCircle(
          pos,
          r + 6,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = colors.shadow,
        );
      }
    }
  }

  @override
  bool shouldRepaint(OrbitPlanetsPainter old) {
    return old.planets != planets ||
        old.colors != colors ||
        old.selectedId != selectedId;
  }
}

class OrbitCelebration {
  const OrbitCelebration({
    required this.position,
    required this.radius,
    required this.color,
  });

  final Offset position;
  final double radius;
  final Color color;
}

class OrbitCelebrationPainter extends CustomPainter {
  OrbitCelebrationPainter({
    required this.celebration,
    required this.colors,
    required this.animation,
  }) : super(repaint: animation);

  final OrbitCelebration? celebration;
  final OrbitColors colors;
  final Animation<double> animation;

  static double _unit(double v) => v.clamp(0.0, 1.0).toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    final c = celebration;
    final t = animation.value;
    if (c == null || t <= 0 || t >= 1) return;

    final pos = c.position + Offset(0, -18 * Curves.easeOut.transform(t));

    final shrink = Curves.easeIn.transform(_unit(t / 0.5));
    if (shrink < 1) {
      drawPlanetDisc(
        canvas,
        pos,
        c.radius * (1 - shrink),
        c.color,
        colors.shadow,
      );
    }

    final popT = _unit((t - 0.3) / 0.7);
    final starScale = Curves.easeOutBack.transform(popT);
    final fade = 1 - Curves.easeIn.transform(_unit((t - 0.7) / 0.3));
    final alpha = (255 * fade).round();

    final star = starPath(
      pos,
      c.radius * 1.6 * starScale,
      rotation: (1 - popT) * 0.8,
    );
    canvas.drawPath(
      star.shift(const Offset(2, 2)),
      Paint()..color = colors.shadow.withAlpha(alpha),
    );
    canvas.drawPath(star, Paint()..color = colors.star.withAlpha(alpha));

    final burstT = _unit((t - 0.35) / 0.65);
    final dot = Paint()
      ..color = colors.star.withAlpha((200 * (1 - burstT)).round());
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + 0.2;
      final distance =
          c.radius * (1.4 + 1.8 * Curves.easeOut.transform(burstT));
      canvas.drawCircle(
        pos + Offset(math.cos(angle), math.sin(angle)) * distance,
        2.2,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(OrbitCelebrationPainter old) {
    return old.celebration != celebration || old.colors != colors;
  }
}
