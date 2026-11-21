import 'dart:convert';

import 'package:orbit_planner/features/tasks/data/task_json.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository(this._prefs);

  static const storageKey = 'tasks_v1';

  final SharedPreferences _prefs;

  List<Task>? _cache;

  List<Task> get _tasks => _cache ??= _read();

  List<Task> _read() {
    final raw = _prefs.getString(storageKey);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final tasks = <Task>[];
      for (final item in decoded) {
        try {
          tasks.add(taskFromJson(item as Map<String, dynamic>));
        } catch (_) {}
      }
      return tasks;
    } catch (_) {
      return [];
    }
  }

  Future<void> _write() {
    final encoded = jsonEncode([for (final t in _tasks) taskToJson(t)]);
    return _prefs.setString(storageKey, encoded);
  }

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  Future<void> saveTask(Task task) async {
    final tasks = _tasks;
    final i = tasks.indexWhere((t) => t.id == task.id);
    if (i == -1) {
      tasks.add(task);
    } else {
      tasks[i] = task;
    }
    await _write();
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _write();
  }

  @override
  Future<void> replaceAll(List<Task> tasks) async {
    _cache = List.of(tasks);
    await _write();
  }
}
