class ScheduledReminder {
  const ScheduledReminder({
    required this.taskId,
    required this.title,
    required this.body,
    required this.fireAt,
  });

  final String taskId;
  final String title;
  final String body;
  final DateTime fireAt;

  @override
  bool operator ==(Object other) =>
      other is ScheduledReminder &&
      other.taskId == taskId &&
      other.title == title &&
      other.body == body &&
      other.fireAt == fireAt;

  @override
  int get hashCode => Object.hash(taskId, title, body, fireAt);
}

int notificationIdFor(String taskId) {
  var h = 5381;
  for (final unit in taskId.codeUnits) {
    h = (h * 33 + unit) & 0x7FFFFFFF;
  }
  return h;
}

abstract class ReminderService {
  bool get isSupported;

  Future<void> initialize();

  Future<bool> requestPermission();

  Future<void> schedule(ScheduledReminder reminder);

  Future<void> cancel(String taskId);

  Future<void> cancelAll();

  Stream<String> get taps;

  Future<String?> takeLaunchTaskId();
}
