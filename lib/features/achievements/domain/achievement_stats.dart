import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';

class AchievementStats {
  const AchievementStats({
    required this.totalStars,
    required this.streak,
    required this.favoriteCategory,
  });

  final int totalStars;
  final int streak;
  final TaskCategory? favoriteCategory;

  factory AchievementStats.from(List<Task> tasks, DateTime now) {
    final completed = tasks.where((t) => t.isCompleted).toList();

    final days = <DateTime>{
      for (final t in completed)
        if (t.completedAt != null)
          DateTime.utc(
            t.completedAt!.year,
            t.completedAt!.month,
            t.completedAt!.day,
          ),
    };

    var cursor = DateTime.utc(now.year, now.month, now.day);
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final counts = <TaskCategory, int>{};
    for (final t in completed) {
      counts[t.category] = (counts[t.category] ?? 0) + 1;
    }
    TaskCategory? favorite;
    var best = 0;
    for (final category in TaskCategory.values) {
      final count = counts[category] ?? 0;
      if (count > best) {
        best = count;
        favorite = category;
      }
    }

    return AchievementStats(
      totalStars: completed.length,
      streak: streak,
      favoriteCategory: favorite,
    );
  }
}
