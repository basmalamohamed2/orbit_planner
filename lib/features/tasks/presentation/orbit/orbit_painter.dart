import 'package:flutter/material.dart';
import 'package:orbit_planner/core/shapes/orbit_drawing.dart';
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
