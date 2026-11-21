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

String formatDueTime(BuildContext context, TimeOfDay time) {
  return MaterialLocalizations.of(context).formatTimeOfDay(
    time,
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
}

extension TaskUi on Task {
  String dueLabel(DateTime now, {String? timeText}) {
    final at = (hasTime && timeText != null) ? ' · $timeText' : '';
    final days = daysUntilDue(now);

    if (days < -1) return 'Overdue by ${-days} days';
    if (days == -1) return 'Overdue by 1 day';
    if (days == 0) {
      if (hasTime && timeText != null && isOverdue(now)) {
        return 'Overdue since $timeText';
      }
      return 'Due today$at';
    }
    if (days == 1) return 'Due tomorrow$at';
    return 'Due in $days days$at';
  }

  String dueLabelOf(BuildContext context) {
    final timeText = hasTime
        ? formatDueTime(context, TimeOfDay.fromDateTime(dueDate))
        : null;
    return dueLabel(DateTime.now(), timeText: timeText);
  }
}
