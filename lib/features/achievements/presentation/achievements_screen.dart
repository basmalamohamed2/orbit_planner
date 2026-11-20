import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasksViewModel>();
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;
    final stars = vm.completedTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: stars.isEmpty
          ? const PlaceholderView(
              icon: Icons.star_outline,
              title: 'No stars yet',
              message: 'Completed tasks will shine here as stars.',
            )
          : SafeArea(
              child: ResponsiveCenter(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    Text(
                      stars.length == 1
                          ? '1 star in your sky'
                          : '${stars.length} stars in your sky',
                      style: text.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    for (final t in stars)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: orbit.star),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(t.title, style: text.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
