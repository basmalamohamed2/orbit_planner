import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

extension TaskCategoryUi on TaskCategory {
  Color color(OrbitColors c) => switch (this) {
    TaskCategory.study => c.study,
    TaskCategory.work => c.work,
    TaskCategory.personal => c.personal,
  };
}

extension TaskPriorityUi on TaskPriority {
  double get dotSize => switch (this) {
    TaskPriority.low => 12,
    TaskPriority.medium => 16,
    TaskPriority.high => 20,
  };
}

extension TaskUi on Task {
  String dueLabel(DateTime now) {
    final days = daysUntilDue(now);
    if (days < -1) return 'Overdue by ${-days} days';
    if (days == -1) return 'Overdue by 1 day';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }
}
