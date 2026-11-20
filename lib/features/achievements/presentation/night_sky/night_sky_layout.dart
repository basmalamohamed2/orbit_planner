import 'dart:math' as math;
import 'dart:ui';

import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

class SkyStar {
  const SkyStar({
    required this.task,
    required this.center,
    required this.radius,
    required this.rotation,
    required this.phase,
  });

  final Task task;
  final Offset center;
  final double radius;
  final double rotation;
  final double phase;
}

class NightSkyLayout {
  NightSkyLayout._();

  static const _minColumns = 3;
  static const _targetCellWidth = 110.0;
  static const _minRows = 2;

  static int columnsFor(double width) =>
      math.max(_minColumns, (width / _targetCellWidth).floor());

  static double _cellHeight(double width) => width / columnsFor(width) * 0.9;

  static double heightFor(int count, double width) {
    final rows = math.max(_minRows, (count / columnsFor(width)).ceil());
    return rows * _cellHeight(width);
  }

  static List<SkyStar> build(List<Task> stars, double width) {
    final cols = columnsFor(width);
    final cellW = width / cols;
    final cellH = _cellHeight(width);

    return [
      for (var i = 0; i < stars.length; i++)
        _place(stars[i], i, cols, cellW, cellH),
    ];
  }

  static SkyStar _place(
    Task task,
    int index,
    int cols,
    double cellW,
    double cellH,
  ) {
    final seed = _scramble(task.id);
    double part(int divisor) => ((seed ~/ divisor) % 1000) / 1000;

    final center = Offset(
      (index % cols + 0.5) * cellW + (part(1) - 0.5) * cellW * 0.5,
      (index ~/ cols + 0.5) * cellH + (part(1000) - 0.5) * cellH * 0.5,
    );

    final radiusFactor = switch (task.priority) {
      TaskPriority.low => 0.085,
      TaskPriority.medium => 0.11,
      TaskPriority.high => 0.14,
    };

    return SkyStar(
      task: task,
      center: center,
      radius: cellW * radiusFactor,
      rotation: (part(1000000) - 0.5) * 0.5,
      phase: part(7),
    );
  }

  static SkyStar? hitTest(List<SkyStar> stars, Offset point) {
    SkyStar? best;
    var bestDistance = double.infinity;

    for (final star in stars) {
      final distance = (star.center - point).distance;
      final reach = math.max(star.radius + 8, 22.0);
      if (distance <= reach && distance < bestDistance) {
        best = star;
        bestDistance = distance;
      }
    }
    return best;
  }

  static int _scramble(String id) {
    var h = 5381;
    for (final unit in id.codeUnits) {
      h = (h * 33 + unit) & 0x7FFFFFFF;
    }
    return (h * 48271) % 2147483647;
  }
}
