import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:orbit_planner/features/notifications/domain/reminder_planner.dart';
import 'package:orbit_planner/features/notifications/domain/reminder_service.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';

class ReminderCoordinator {
  ReminderCoordinator({
    required this.service,
    required this.tasks,
    required this.settings,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  final ReminderService service;
  final TasksViewModel tasks;
  final SettingsViewModel settings;
  final DateTime Function() _now;

  static const maxPending = 60;

  final Map<String, ScheduledReminder> _scheduled = {};
  bool _started = false;
  bool _running = false;
  bool _dirty = false;
  bool _clearedStale = false;

  void start() {
    if (_started) return;
    _started = true;
    tasks.addListener(_request);
    settings.addListener(_request);
    _request();
  }

  void dispose() {
    tasks.removeListener(_request);
    settings.removeListener(_request);
  }

  void _request() {
    if (_running) {
      _dirty = true;
      return;
    }
    unawaited(_run());
  }

  Future<void> _run() async {
    _running = true;
    try {
      do {
        _dirty = false;
        await _sync();
      } while (_dirty);
    } finally {
      _running = false;
    }
  }

  Future<void> _sync() async {
    if (!service.isSupported || tasks.isLoading) return;

    try {
      if (!_clearedStale) {
        await service.cancelAll();
        _scheduled.clear();
        _clearedStale = true;
      }

      if (!settings.remindersEnabled) {
        if (_scheduled.isNotEmpty) {
          await service.cancelAll();
          _scheduled.clear();
        }
        return;
      }

      final desired = _plan();

      for (final taskId in _scheduled.keys.toList()) {
        if (desired.containsKey(taskId)) continue;
        await _guard(() => service.cancel(taskId));
        _scheduled.remove(taskId);
      }

      for (final reminder in desired.values) {
        if (_scheduled[reminder.taskId] == reminder) continue;
        final ok = await _guard(() => service.schedule(reminder));
        if (ok) _scheduled[reminder.taskId] = reminder;
      }
    } catch (error) {
      debugPrint('Reminder sync failed: $error');
    }
  }

  Map<String, ScheduledReminder> _plan() {
    final now = _now();
    final lead = settings.reminderLead.duration;

    final reminders = <ScheduledReminder>[];
    for (final task in tasks.activeTasks) {
      final fireAt = ReminderPlanner.fireTimeFor(task, lead: lead, now: now);
      if (fireAt == null) continue;
      reminders.add(
        ScheduledReminder(
          taskId: task.id,
          title: task.title,
          body: ReminderPlanner.bodyFor(task, lead),
          fireAt: fireAt,
        ),
      );
    }

    reminders.sort((a, b) => a.fireAt.compareTo(b.fireAt));
    return {for (final r in reminders.take(maxPending)) r.taskId: r};
  }

  Future<bool> _guard(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (error) {
      debugPrint('Reminder operation failed: $error');
      return false;
    }
  }
}
