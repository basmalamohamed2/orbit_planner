import 'package:orbit_planner/features/tasks/domain/task.dart';

class ReminderPlanner {
  ReminderPlanner._();

  static const allDayHour = 9;

  static const _minimumLeadTime = Duration(seconds: 5);

  static DateTime? fireTimeFor(
    Task task, {
    required Duration lead,
    required DateTime now,
  }) {
    if (task.isCompleted) return null;

    final due = task.dueDate;
    final fireAt = task.hasTime
        ? due.subtract(lead)
        : DateTime(due.year, due.month, due.day, allDayHour);

    return fireAt.isAfter(now.add(_minimumLeadTime)) ? fireAt : null;
  }

  static String bodyFor(Task task, Duration lead) {
    if (!task.hasTime) return 'Due today';
    if (lead == Duration.zero) return 'It’s time';
    if (lead.inMinutes < 60) return 'Due in ${lead.inMinutes} minutes';

    final hours = lead.inHours;
    return hours == 1 ? 'Due in 1 hour' : 'Due in $hours hours';
  }
}
