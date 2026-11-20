import 'package:flutter/material.dart';
import 'package:orbit_planner/app/shell/app_shell.dart';
import 'package:orbit_planner/core/theme/app_theme.dart';
import 'package:orbit_planner/features/onboarding/presentation/onboarding_screen.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/theme_view_model.dart';
import 'package:orbit_planner/features/tasks/data/in_memory_task_repository.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(
          create: (_) => TasksViewModel(InMemoryTaskRepository()),
        ),
      ],
      child: const OrbitPlannerApp(),
    ),
  );
}

class OrbitPlannerApp extends StatefulWidget {
  const OrbitPlannerApp({super.key});

  @override
  State<OrbitPlannerApp> createState() => _OrbitPlannerAppState();
}

class _OrbitPlannerAppState extends State<OrbitPlannerApp> {
  bool _onboardingDone = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeViewModel, ThemeMode>(
      (vm) => vm.mode,
    );

    return MaterialApp(
      title: 'Orbit Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _onboardingDone
            ? const AppShell(key: ValueKey('shell'))
            : OnboardingScreen(
                key: const ValueKey('onboarding'),
                onFinished: () => setState(() => _onboardingDone = true),
              ),
      ),
    );
  }
}
