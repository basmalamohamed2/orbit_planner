import 'package:orbit_planner/features/tasks/domain/sample_tasks.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_repository.dart';

class InMemoryTaskRepository implements TaskRepository {
  InMemoryTaskRepository({List<Task>? seed})
    : _tasks = List.of(seed ?? buildSampleTasks(DateTime.now()));

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

  @override
  Future<void> replaceAll(List<Task> tasks) async {
    _tasks
      ..clear()
      ..addAll(tasks);
  }
}
