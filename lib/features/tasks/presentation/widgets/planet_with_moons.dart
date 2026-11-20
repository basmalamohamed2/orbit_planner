import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/shapes/orbit_drawing.dart';
import 'package:orbit_planner/core/shapes/star_path.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';

const _planetRadius = 0.2;
const _moonRingRadius = 0.38;
const _moonRingTilt = 0.08;
const _moonRadius = 0.035;
const _maxMoons = 8;

class PlanetWithMoons extends StatefulWidget {
  const PlanetWithMoons({super.key, required this.task, required this.size});

  final Task task;
  final double size;

  @override
  State<PlanetWithMoons> createState() => _PlanetWithMoonsState();
}

class _PlanetWithMoonsState extends State<PlanetWithMoons>
    with SingleTickerProviderStateMixin {
  // لفة كاملة للأقمار = 60 ثانية
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 60),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.orbit;
    final task = widget.task;
    final categoryColor = task.category.color(colors);

    return SizedBox.square(
      dimension: widget.size,
      child: Semantics(
        label: '${task.title}, ${task.notes.length} notes orbiting as moons',
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: CustomPaint(
                painter: _BodyPainter(
                  colors: colors,
                  categoryColor: categoryColor,
                  completed: task.isCompleted,
                ),
              ),
            ),
            RepaintBoundary(
              child: CustomPaint(
                painter: _MoonsPainter(
                  colors: colors,
                  categoryColor: categoryColor,
                  moonCount: math.min(task.notes.length, _maxMoons),
                  animation: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.colors,
    required this.categoryColor,
    required this.completed,
  });

  final OrbitColors colors;
  final Color categoryColor;
  final bool completed;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);
    final ringColor = Color.lerp(colors.outline, colors.muted, 0.35)!;

    final rx = s * _moonRingRadius;
    drawDashedEllipse(canvas, c, rx, rx * 0.96, _moonRingTilt, ringColor);

    if (completed) {
      final star = starPath(c, s * _planetRadius * 1.35);
      canvas.drawPath(
        star.shift(const Offset(2, 2)),
        Paint()..color = colors.shadow,
      );
      canvas.drawPath(star, Paint()..color = colors.star);
    } else {
      drawPlanetDisc(
        canvas,
        c,
        s * _planetRadius,
        categoryColor,
        colors.shadow,
      );
    }
  }

  @override
  bool shouldRepaint(_BodyPainter old) {
    return old.colors != colors ||
        old.categoryColor != categoryColor ||
        old.completed != completed;
  }
}

class _MoonsPainter extends CustomPainter {
  _MoonsPainter({
    required this.colors,
    required this.categoryColor,
    required this.moonCount,
    required this.animation,
  }) : super(repaint: animation);

  final OrbitColors colors;
  final Color categoryColor;
  final int moonCount;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    if (moonCount == 0) return;

    final s = size.width;
    final c = Offset(s / 2, s / 2);
    final rx = s * _moonRingRadius;
    final ry = rx * 0.96;
    final moonColor = Color.lerp(categoryColor, const Color(0xFFFFFFFF), 0.45)!;

    for (var i = 0; i < moonCount; i++) {
      final angle =
          0.6 + i * 2 * math.pi / moonCount + animation.value * 2 * math.pi;
      final x = rx * math.cos(angle);
      final y = ry * math.sin(angle);
      final pos =
          c +
          Offset(
            x * math.cos(_moonRingTilt) - y * math.sin(_moonRingTilt),
            x * math.sin(_moonRingTilt) + y * math.cos(_moonRingTilt),
          );
      drawPlanetDisc(canvas, pos, s * _moonRadius, moonColor, colors.shadow);
    }
  }

  @override
  bool shouldRepaint(_MoonsPainter old) {
    return old.colors != colors ||
        old.categoryColor != categoryColor ||
        old.moonCount != moonCount;
  }
}
