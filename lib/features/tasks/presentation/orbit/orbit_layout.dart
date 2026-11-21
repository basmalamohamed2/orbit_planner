import 'dart:math' as math;
import 'dart:ui';

import 'package:orbit_planner/core/shapes/ellipse.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

class OrbitPlanet {
  const OrbitPlanet({
    required this.task,
    required this.ring,
    required this.baseAngle,
  });

  final Task task;
  final int ring;
  final double baseAngle;
}

class OrbitLayout {
  OrbitLayout._();

  static const ringCount = 3;

  static const ringRadii = [0.19, 0.31, 0.43];

  static const ringTilts = [-0.06, 0.10, -0.04];

  static const ringOffsets = [0.5, 2.3, 4.2];

  static const ringSpins = [4, 3, 2];

  static const ellipseRatio = 0.96;

  static const sunRadius = 0.075;

  static double planetRadius(TaskPriority priority) => switch (priority) {
    TaskPriority.low => 0.028,
    TaskPriority.medium => 0.036,
    TaskPriority.high => 0.046,
  };

  static int ringFor(int daysUntilDue) {
    if (daysUntilDue <= 3) return 0;
    if (daysUntilDue <= 7) return 1;
    return 2;
  }

  static List<OrbitPlanet> build(List<Task> activeTasks, DateTime now) {
    final byRing = List.generate(ringCount, (_) => <Task>[]);
    for (final task in activeTasks) {
      byRing[ringFor(task.daysUntilDue(now))].add(task);
    }

    final planets = <OrbitPlanet>[];
    for (var r = 0; r < ringCount; r++) {
      final tasks = byRing[r]..sort((a, b) => a.id.compareTo(b.id));
      for (var i = 0; i < tasks.length; i++) {
        planets.add(
          OrbitPlanet(
            task: tasks[i],
            ring: r,
            baseAngle: ringOffsets[r] + i * 2 * math.pi / tasks.length,
          ),
        );
      }
    }
    return planets;
  }

  static Offset positionOf(OrbitPlanet planet, double t, double size) {
    final center = Offset(size / 2, size / 2);
    final rx = ringRadii[planet.ring] * size;
    final ry = rx * ellipseRatio;
    final angle = planet.baseAngle + t * 2 * math.pi * ringSpins[planet.ring];
    return pointOnEllipse(center, rx, ry, ringTilts[planet.ring], angle);
  }

  static OrbitPlanet? hitTest(
    List<OrbitPlanet> planets,
    Offset point,
    double t,
    double size,
  ) {
    OrbitPlanet? best;
    var bestDistance = double.infinity;

    for (final planet in planets) {
      final distance = (positionOf(planet, t, size) - point).distance;
      final reach = math.max(
        planetRadius(planet.task.priority) * size + 8,
        22.0,
      );
      if (distance <= reach && distance < bestDistance) {
        best = planet;
        bestDistance = distance;
      }
    }
    return best;
  }
}
