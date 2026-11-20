import 'package:orbit_planner/features/tasks/domain/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> saveTask(Task task);

  Future<void> deleteTask(String id);
}
