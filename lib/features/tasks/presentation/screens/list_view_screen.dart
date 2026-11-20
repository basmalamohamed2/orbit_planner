import 'package:flutter/material.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List')),
      body: const PlaceholderView(
        icon: Icons.format_list_bulleted,
        title: 'The classic view',
        message: 'A simple list of your tasks will live here.',
      ),
    );
  }
}
