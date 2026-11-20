import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

class Note {
  const Note({required this.id, required this.text, required this.createdAt});

  final String id;
  final String text;
  final DateTime createdAt;
}

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.notes = const [],
  });

  final String id;
  final String title;
  final TaskCategory category;
  final TaskPriority priority;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final List<Note> notes;

  int daysUntilDue(DateTime now) {
    final today = DateTime.utc(now.year, now.month, now.day);
    final due = DateTime.utc(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

  Task copyWith({
    String? title,
    TaskCategory? category,
    TaskPriority? priority,
    DateTime? dueDate,
    List<Note>? notes,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted,
      completedAt: completedAt,
      notes: notes ?? this.notes,
    );
  }

  Task complete(DateTime at) {
    return Task(
      id: id,
      title: title,
      category: category,
      priority: priority,
      dueDate: dueDate,
      isCompleted: true,
      completedAt: at,
      notes: notes,
    );
  }

  Task reopen() {
    return Task(
      id: id,
      title: title,
      category: category,
      priority: priority,
      dueDate: dueDate,
      isCompleted: false,
      completedAt: null,
      notes: notes,
    );
  }
}
