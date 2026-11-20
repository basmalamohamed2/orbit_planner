import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';
import 'package:orbit_planner/features/tasks/domain/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository({List<Task>? seed})
    : _tasks = List.of(seed ?? _sampleTasks());

  final List<Task> _tasks;

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  Future<void> saveTask(Task task) async {
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i == -1) {
      _tasks.add(task);
    } else {
      _tasks[i] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }

  static List<Task> _sampleTasks() {
    final now = DateTime.now();
    DateTime inDays(int d) => now.add(Duration(days: d));

    return [
      Task(
        id: '1',
        title: 'Physics Ch. 4',
        category: TaskCategory.study,
        priority: TaskPriority.high,
        dueDate: inDays(3),
      ),
      Task(
        id: '2',
        title: 'Design review',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        dueDate: inDays(1),
      ),
      Task(
        id: '3',
        title: 'Call grandma',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        dueDate: inDays(7),
      ),
      Task(
        id: '4',
        title: 'Flutter course: lesson 5',
        category: TaskCategory.study,
        priority: TaskPriority.medium,
        dueDate: inDays(14),
      ),
      Task(
        id: '5',
        title: 'Buy a new notebook',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        dueDate: inDays(-1),
        isCompleted: true,
        completedAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }
}
