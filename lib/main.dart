import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/app_theme.dart';
import 'package:orbit_planner/features/onboarding/presentation/onboarding_screen.dart';
import 'package:orbit_planner/theme_preview_screen.dart';

void main() => runApp(const MoodOrbitApp());

class MoodOrbitApp extends StatefulWidget {
  const MoodOrbitApp({super.key});

  @override
  State<MoodOrbitApp> createState() => _MoodOrbitAppState();
}

class _MoodOrbitAppState extends State<MoodOrbitApp> {
  ThemeMode _mode = ThemeMode.light;

  bool _onboardingDone = false;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbit Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _mode,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _onboardingDone
            ? ThemePreviewScreen(
                key: const ValueKey('home'),
                isDark: _mode == ThemeMode.dark,
                onToggleTheme: _toggleTheme,
              )
            : OnboardingScreen(
                key: const ValueKey('onboarding'),
                onFinished: () => setState(() => _onboardingDone = true),
              ),
      ),
    );
  }
}
