import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orbit_planner/app/reminder_coordinator.dart';
import 'package:orbit_planner/app/shell/app_shell.dart';
import 'package:orbit_planner/core/theme/app_theme.dart';
import 'package:orbit_planner/features/notifications/data/noop_reminder_service.dart';
import 'package:orbit_planner/features/notifications/domain/reminder_service.dart';
import 'package:orbit_planner/features/onboarding/presentation/onboarding_screen.dart';
import 'package:orbit_planner/features/settings/data/local_settings_repository.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/data/local_task_repository.dart';
import 'package:orbit_planner/features/tasks/presentation/screens/planet_detail_screen.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settingsRepository = LocalSettingsRepository(prefs);
  final taskRepository = LocalTaskRepository(prefs);
  final settings = await settingsRepository.load();
  final reminders = await createReminderService();
  final settingsViewModel = SettingsViewModel(settingsRepository, settings);
  final tasksViewModel = TasksViewModel(taskRepository);

  ReminderCoordinator(
    service: reminders,
    tasks: tasksViewModel,
    settings: settingsViewModel,
  ).start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsViewModel),
        ChangeNotifierProvider.value(value: tasksViewModel),
        Provider<ReminderService>.value(value: reminders),
      ],
      child: OrbitPlannerApp(reminders: reminders),
    ),
  );
}

class OrbitPlannerApp extends StatefulWidget {
  const OrbitPlannerApp({super.key, required this.reminders});

  final ReminderService reminders;

  @override
  State<OrbitPlannerApp> createState() => _OrbitPlannerAppState();
}

class _OrbitPlannerAppState extends State<OrbitPlannerApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<String>? _tapSubscription;

  @override
  void initState() {
    super.initState();

    _tapSubscription = widget.reminders.taps.listen(_openTask);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskId = await widget.reminders.takeLaunchTaskId();
      if (taskId != null) _openTask(taskId);
    });
  }

  @override
  void dispose() {
    _tapSubscription?.cancel();
    super.dispose();
  }

  void _openTask(String taskId) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null || !mounted) return;
    if (!context.read<SettingsViewModel>().onboardingSeen) return;
    openPlanetDetailOn(navigator, taskId);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<SettingsViewModel, ThemeMode>(
      (s) => s.themeMode,
    );
    final onboardingSeen = context.select<SettingsViewModel, bool>(
      (s) => s.onboardingSeen,
    );

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Orbit Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: onboardingSeen
            ? const AppShell(key: ValueKey('shell'))
            : OnboardingScreen(
                key: const ValueKey('onboarding'),
                onFinished: () =>
                    context.read<SettingsViewModel>().markOnboardingSeen(),
              ),
      ),
    );
  }
}
