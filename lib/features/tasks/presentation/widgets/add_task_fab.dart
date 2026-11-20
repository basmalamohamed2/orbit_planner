import 'package:flutter/material.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/add_task_sheet.dart';

class AddTaskFab extends StatelessWidget {
  const AddTaskFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      tooltip: 'Add task',
      onPressed: () => showAddTaskSheet(context),
      child: const Icon(Icons.add),
    );
  }
}
