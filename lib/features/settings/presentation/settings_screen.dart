import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/settings/domain/app_settings.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _clearAll(BuildContext context) async {
    final tasks = context.read<TasksViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await _confirm(
      context,
      title: 'Clear all tasks?',
      message:
          'Every planet, star and note will be deleted. This can’t be undone.',
      action: 'Clear all',
    );
    if (!ok) return;

    await tasks.clearAll();
    messenger.showSnackBar(const SnackBar(content: Text('All tasks cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsViewModel>();
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              _Section(
                title: 'APPEARANCE',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme', style: text.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          'Follow your device or pick one',
                          style: text.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<AppThemeMode>(
                            showSelectedIcon: false,
                            segments: const [
                              ButtonSegment(
                                value: AppThemeMode.system,
                                label: Text('System'),
                              ),
                              ButtonSegment(
                                value: AppThemeMode.light,
                                label: Text('Light'),
                              ),
                              ButtonSegment(
                                value: AppThemeMode.dark,
                                label: Text('Dark'),
                              ),
                            ],
                            selected: {settings.appThemeMode},
                            onSelectionChanged: (selection) =>
                                settings.setThemeMode(selection.first),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    value: settings.motionEnabled,
                    onChanged: settings.setMotionEnabled,
                    title: Text('Gentle motion', style: text.titleMedium),
                    subtitle: Text(
                      'Planets drift, moons orbit and stars twinkle',
                      style: text.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _Section(
                title: 'GENERAL',
                children: [
                  ListTile(
                    title: Text('Replay intro', style: text.titleMedium),
                    subtitle: Text(
                      'See the welcome slides again',
                      style: text.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: settings.resetOnboarding,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _Section(
                title: 'DATA',
                children: [
                  ListTile(
                    title: Text(
                      'Clear all tasks',
                      style: text.titleMedium?.copyWith(
                        color: scheme.secondary,
                      ),
                    ),
                    subtitle: Text(
                      'Delete every planet, star and note',
                      style: text.bodySmall,
                    ),
                    trailing: Icon(
                      Icons.delete_outline,
                      color: scheme.secondary,
                    ),
                    onTap: () => _clearAll(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Orbit Planner 1.0.0 · A note & to-do app built with Flutter',
                  style: text.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.labelSmall),
        const SizedBox(height: 12),
        Material(
          color: scheme.surfaceContainer,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: orbit.outline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
