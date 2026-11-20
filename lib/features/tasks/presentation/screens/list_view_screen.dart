import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/add_task_fab.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskCategory? _filter;

  bool _matches(Task task) => _filter == null || task.category == _filter;

  void _delete(Task task) {
    final vm = context.read<TasksViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    vm.deleteTask(task.id);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Deleted "${task.title}"'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => vm.restoreTask(task),
          ),
        ),
      );
  }

  Widget _row(Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        background: const _DeleteBackground(),
        onDismissed: (_) => _delete(task),
        child: TaskTile(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasksViewModel>();
    final text = Theme.of(context).textTheme;

    final hasAny = vm.activeTasks.isNotEmpty || vm.completedTasks.isNotEmpty;
    final active = vm.activeTasks.where(_matches).toList();
    final completed = vm.completedTasks.where(_matches).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('List')),
      floatingActionButton: const AddTaskFab(),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !hasAny
          ? const PlaceholderView(
              icon: Icons.format_list_bulleted,
              title: 'Nothing here yet',
              message: 'Tap + to launch your first planet.',
            )
          : SafeArea(
              child: ResponsiveCenter(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
                  children: [
                    _FilterBar(
                      selected: _filter,
                      onChanged: (category) =>
                          setState(() => _filter = category),
                    ),
                    const SizedBox(height: 16),
                    if (active.isEmpty && completed.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No tasks in this category yet.',
                          style: text.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      )
                    else ...[
                      for (final task in active) _row(task),
                      if (completed.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('COMPLETED', style: text.labelSmall),
                        const SizedBox(height: 12),
                        for (final task in completed) _row(task),
                      ],
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final TaskCategory? selected;
  final ValueChanged<TaskCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final orbit = context.orbit;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onChanged(null),
            ),
          ),
          for (final category in TaskCategory.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.label),
                avatar: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: category.color(orbit),
                    shape: BoxShape.circle,
                  ),
                ),
                selected: selected == category,
                onSelected: (_) => onChanged(category),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: scheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.delete_outline, color: scheme.onSecondary),
    );
  }
}
