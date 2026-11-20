import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';
import 'package:orbit_planner/features/achievements/domain/achievement_stats.dart';
import 'package:orbit_planner/features/achievements/presentation/night_sky/night_sky.dart';
import 'package:orbit_planner/features/achievements/presentation/widgets/stats_row.dart';
import 'package:orbit_planner/features/tasks/presentation/screens/planet_detail_screen.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasksViewModel>();
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;
    final dates = MaterialLocalizations.of(context);

    final newestFirst = vm.completedTasks;
    final stats = AchievementStats.from(newestFirst, DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: newestFirst.isEmpty
          ? const PlaceholderView(
              icon: Icons.star_outline,
              title: 'No stars yet',
              message:
                  'Complete a task and its planet becomes a star in your sky.',
            )
          : SafeArea(
              child: ResponsiveCenter(
                maxWidth: 720,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    Text('Your night sky', style: text.headlineLarge),
                    const SizedBox(height: 16),
                    StatsRow(stats: stats),
                    const SizedBox(height: 20),
                    NightSky(
                      stars: newestFirst.reversed.toList(),
                      onStarTap: (task) => openPlanetDetail(context, task.id),
                    ),
                    const SizedBox(height: 24),
                    Text('RECENTLY COMPLETED', style: text.labelSmall),
                    const SizedBox(height: 4),
                    for (final task in newestFirst.take(5))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => openPlanetDetail(context, task.id),
                        leading: Icon(Icons.star, color: orbit.star),
                        title: Text(task.title, style: text.bodyMedium),
                        subtitle: task.completedAt == null
                            ? null
                            : Text(
                                dates.formatMediumDate(task.completedAt!),
                                style: text.bodySmall,
                              ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
