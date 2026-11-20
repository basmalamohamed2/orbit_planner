import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasksViewModel>();
    final text = Theme.of(context).textTheme;
    final active = vm.activeTasks;
    final completed = vm.completedTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('List')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : active.isEmpty && completed.isEmpty
          ? const PlaceholderView(
              icon: Icons.format_list_bulleted,
              title: 'Nothing here yet',
              message: 'Add your first task and it will show up here.',
            )
          : SafeArea(
              child: ResponsiveCenter(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    for (final t in active) TaskTile(task: t),
                    if (completed.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text('COMPLETED', style: text.labelSmall),
                      const SizedBox(height: 12),
                      for (final t in completed) TaskTile(task: t),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
