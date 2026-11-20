import 'package:orbit_planner/features/tasks/domain/task.dart';
import 'package:orbit_planner/features/tasks/domain/task_category.dart';
import 'package:orbit_planner/features/tasks/domain/task_priority.dart';

Map<String, dynamic> taskToJson(Task task) {
  return {
    'id': task.id,
    'title': task.title,
    'category': task.category.name,
    'priority': task.priority.name,
    'dueDate': task.dueDate.toIso8601String(),
    'isCompleted': task.isCompleted,
    'completedAt': task.completedAt?.toIso8601String(),
    'notes': [
      for (final note in task.notes)
        {
          'id': note.id,
          'text': note.text,
          'createdAt': note.createdAt.toIso8601String(),
        },
    ],
  };
}

Task taskFromJson(Map<String, dynamic> json) {
  final completedAt = json['completedAt'] as String?;

  return Task(
    id: json['id'] as String,
    title: json['title'] as String,
    category: TaskCategory.values.byName(json['category'] as String),
    priority: TaskPriority.values.byName(json['priority'] as String),
    dueDate: DateTime.parse(json['dueDate'] as String),
    isCompleted: json['isCompleted'] as bool? ?? false,
    completedAt: completedAt == null ? null : DateTime.parse(completedAt),
    notes: [
      for (final raw in (json['notes'] as List<dynamic>? ?? const []))
        Note(
          id: (raw as Map<String, dynamic>)['id'] as String,
          text: raw['text'] as String,
          createdAt: DateTime.parse(raw['createdAt'] as String),
        ),
    ],
  );
}
