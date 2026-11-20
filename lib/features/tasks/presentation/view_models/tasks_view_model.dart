import 'package:flutter/foundation.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';
import 'package:orbit_planner/features/tasks/domain/task_repository.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository) {
    load();
  }

  final TaskRepository _repository;

  List<Task> _tasks = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Task> get activeTasks =>
      _tasks.where((t) => !t.isCompleted).toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList()
    ..sort(
      (a, b) =>
          (b.completedAt ?? b.dueDate).compareTo(a.completedAt ?? a.dueDate),
    );

  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  Task? taskById(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  Future<void> load() async {
    _tasks = List.of(await _repository.getTasks());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required TaskCategory category,
    required TaskPriority priority,
    required DateTime dueDate,
  }) async {
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      category: category,
      priority: priority,
      dueDate: dueDate,
    );
    _tasks.add(task);
    notifyListeners();
    await _repository.saveTask(task);
  }

  Future<void> toggleComplete(String id) async {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i == -1) return;

    final task = _tasks[i];
    final updated = task.isCompleted
        ? task.reopen()
        : task.complete(DateTime.now());
    _tasks[i] = updated;
    notifyListeners();
    await _repository.saveTask(updated);
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _repository.deleteTask(id);
  }
}
