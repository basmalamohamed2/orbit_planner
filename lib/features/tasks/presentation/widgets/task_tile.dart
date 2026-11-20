import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    final days = task.daysUntilDue(DateTime.now());
    final overdue = !task.isCompleted && days < 0;
    final subtitle = task.isCompleted
        ? '${task.category.label} · Completed'
        : '${task.category.label} · ${_dueLabel(days)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: scheme.surfaceContainer,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: orbit.outline),
        ),
        child: ListTile(
          leading: SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: Container(
                width: task.priority.dotSize,
                height: task.priority.dotSize,
                decoration: BoxDecoration(
                  color: task.category.color(orbit),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: orbit.shadow,
                      offset: const Offset(1.5, 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          title: Text(
            task.title,
            style: text.titleMedium?.copyWith(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? orbit.muted : null,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: text.bodySmall?.copyWith(
              color: overdue ? scheme.secondary : null,
            ),
          ),
          trailing: IconButton(
            tooltip: task.isCompleted ? 'Reopen' : 'Complete',
            icon: Icon(
              task.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isCompleted ? orbit.star : orbit.muted,
            ),
            onPressed: () =>
                context.read<TasksViewModel>().toggleComplete(task.id),
          ),
        ),
      ),
    );
  }

  static String _dueLabel(int days) {
    if (days < -1) return 'Overdue by ${-days} days';
    if (days == -1) return 'Overdue by 1 day';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }
}
