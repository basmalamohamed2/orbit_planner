import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/breakpoints.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/add_task_sheet.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/moon_notes_section.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/planet_with_moons.dart';
import 'package:provider/provider.dart';

void openPlanetDetail(BuildContext context, String taskId) =>
    openPlanetDetailOn(Navigator.of(context), taskId);

void openPlanetDetailOn(NavigatorState navigator, String taskId) {
  navigator.push(
    MaterialPageRoute<void>(builder: (_) => PlanetDetailScreen(taskId: taskId)),
  );
}

class PlanetDetailScreen extends StatelessWidget {
  const PlanetDetailScreen({super.key, required this.taskId});

  final String taskId;

  Future<void> _confirmDelete(BuildContext context, Task task) async {
    final vm = context.read<TasksViewModel>();
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this planet?'),
        content: Text('"${task.title}" and its notes will be gone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      navigator.pop();
      vm.deleteTask(task.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksViewModel>().taskById(taskId);

    if (task == null) return const Scaffold();

    final header = _PlanetHeader(task: task);
    final notes = MoonNotesSection(task: task);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planet'),
        actions: [
          IconButton(
            tooltip: 'Edit task',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showEditTaskSheet(context, task),
          ),
          IconButton(
            tooltip: 'Delete task',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, task),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 960,
          child: context.isExpanded
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: header,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: notes,
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [header, const SizedBox(height: 28), notes],
                ),
        ),
      ),
    );
  }
}

class _PlanetHeader extends StatelessWidget {
  const _PlanetHeader({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;
    final dates = MaterialLocalizations.of(context);
    final motion = context.select<SettingsViewModel, bool>(
      (s) => s.motionEnabled,
    );

    final statusLabel = task.isCompleted
        ? 'Completed ${dates.formatMediumDate(task.completedAt ?? DateTime.now())}'
        : task.dueLabelOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = math.min(constraints.maxWidth, 300.0);
            return Center(
              child: PlanetWithMoons(
                task: task,
                size: size,
                motionEnabled: motion,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          task.title,
          style: text.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _Pill(
              label: task.category.label,
              dotColor: task.category.color(orbit),
            ),
            _Pill(label: '${task.priority.label} priority'),
            _Pill(label: statusLabel),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () =>
              context.read<TasksViewModel>().toggleComplete(task.id),
          child: Text(task.isCompleted ? 'Reopen planet' : 'Complete'),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.dotColor});

  final String label;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: orbit.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: text.labelLarge),
        ],
      ),
    );
  }
}
