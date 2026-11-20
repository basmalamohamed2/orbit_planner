import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

List<Task> buildSampleTasks(DateTime now) {
  DateTime inDays(int d) => now.add(Duration(days: d));

  return [
    Task(
      id: 'sample-1',
      title: 'Physics Ch. 4',
      category: TaskCategory.study,
      priority: TaskPriority.high,
      dueDate: inDays(3),
      notes: [
        Note(
          id: 'sample-n1',
          text: 'Focus on momentum and collision examples',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        Note(
          id: 'sample-n2',
          text: 'Ask the teacher about problem 12',
          createdAt: now.subtract(const Duration(hours: 3)),
        ),
      ],
    ),
    Task(
      id: 'sample-2',
      title: 'Design review',
      category: TaskCategory.work,
      priority: TaskPriority.medium,
      dueDate: inDays(1),
    ),
    Task(
      id: 'sample-3',
      title: 'Call grandma',
      category: TaskCategory.personal,
      priority: TaskPriority.low,
      dueDate: inDays(7),
    ),
    Task(
      id: 'sample-4',
      title: 'Flutter course: lesson 5',
      category: TaskCategory.study,
      priority: TaskPriority.medium,
      dueDate: inDays(14),
    ),
    Task(
      id: 'sample-5',
      title: 'Buy a new notebook',
      category: TaskCategory.personal,
      priority: TaskPriority.low,
      dueDate: inDays(-1),
      isCompleted: true,
      completedAt: now.subtract(const Duration(hours: 5)),
    ),
    Task(
      id: 'sample-6',
      title: 'Finish algebra worksheet',
      category: TaskCategory.study,
      priority: TaskPriority.medium,
      dueDate: inDays(-2),
      isCompleted: true,
      completedAt: now.subtract(const Duration(days: 1)),
    ),
    Task(
      id: 'sample-7',
      title: 'Send weekly report',
      category: TaskCategory.work,
      priority: TaskPriority.high,
      dueDate: inDays(-3),
      isCompleted: true,
      completedAt: now.subtract(const Duration(days: 2)),
    ),
  ];
}
