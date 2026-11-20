import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/achievements/domain/achievement_stats.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.stats});

  final AchievementStats stats;

  @override
  Widget build(BuildContext context) {
    final favorite = stats.favoriteCategory;

    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'STARS', value: '${stats.totalStars}'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'STREAK',
            value: stats.streak == 1 ? '1 day' : '${stats.streak} days',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'FAVORITE',
            value: favorite?.label ?? '–',
            dotColor: favorite?.color(context.orbit),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, this.dotColor});

  final String label;
  final String value;
  final Color? dotColor;

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: text.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dotColor != null) ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(value, style: text.headlineMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
