import 'package:flutter/foundation.dart';
import 'package:orbit_planner/features/notifications/data/local_reminder_service.dart';
import 'package:orbit_planner/features/notifications/domain/reminder_service.dart';

class NoopReminderService implements ReminderService {
  @override
  bool get isSupported => false;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule(ScheduledReminder reminder) async {}

  @override
  Future<void> cancel(String taskId) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Stream<String> get taps => const Stream<String>.empty();

  @override
  Future<String?> takeLaunchTaskId() async => null;
}

Future<ReminderService> createReminderService() async {
  final isMobile =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  if (!isMobile) return NoopReminderService();

  try {
    final service = LocalReminderService();
    await service.initialize();
    return service;
  } catch (error) {
    debugPrint(
      'Reminders disabled, could not initialize notifications: $error',
    );
    return NoopReminderService();
  }
}
