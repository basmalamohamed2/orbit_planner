import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';

class OrbitInfoPanel extends StatelessWidget {
  const OrbitInfoPanel({
    super.key,
    required this.selected,
    required this.hasPlanets,
    required this.onComplete,
    required this.onOpenDetails,
  });

  final Task? selected;
  final bool hasPlanets;
  final VoidCallback onComplete;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Legend(),
        const SizedBox(height: 16),
        if (selected != null)
          _SelectedCard(
            task: selected!,
            onComplete: onComplete,
            onOpenDetails: onOpenDetails,
          )
        else
          Text(
            hasPlanets
                ? 'Tap a planet to see its task.'
                : 'Your sky is clear. Add a task to launch a planet.',
            style: text.bodySmall,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final category in TaskCategory.values)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: category.color(orbit),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(category.label, style: text.labelSmall),
                ],
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Size = priority · Closer to the sun = closer deadline',
          style: text.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({
    required this.task,
    required this.onComplete,
    required this.onOpenDetails,
  });

  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onOpenDetails;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    return Material(
      color: scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: orbit.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: task.category.color(orbit),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(task.title, style: text.titleMedium)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${task.category.label} · ${task.priority.label} priority',
              style: text.bodySmall,
            ),
            Text(task.dueLabel(DateTime.now()), style: text.bodySmall),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onOpenDetails,
                    child: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onComplete,
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
