import 'package:flutter/material.dart';
import 'package:orbit_planner/app/shell/app_shell.dart';
import 'package:orbit_planner/core/theme/app_theme.dart';
import 'package:orbit_planner/features/onboarding/presentation/onboarding_screen.dart';
import 'package:orbit_planner/features/settings/data/local_settings_repository.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/data/local_task_repository.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settingsRepository = LocalSettingsRepository(prefs);
  final taskRepository = LocalTaskRepository(
    prefs,
  );
  final settings = await settingsRepository.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(settingsRepository, settings),
        ),
        ChangeNotifierProvider(create: (_) => TasksViewModel(taskRepository)),
      ],
      child: const OrbitPlannerApp(),
    ),
  );
}

class OrbitPlannerApp extends StatelessWidget {
  const OrbitPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<SettingsViewModel, ThemeMode>(
      (s) => s.themeMode,
    );
    final onboardingSeen = context.select<SettingsViewModel, bool>(
      (s) => s.onboardingSeen,
    );

    return MaterialApp(
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
