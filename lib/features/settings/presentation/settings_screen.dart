import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeViewModel>();
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final orbit = context.orbit;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              Text('APPEARANCE', style: text.labelSmall),
              const SizedBox(height: 12),
              Material(
                color: scheme.surfaceContainer,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: orbit.outline),
                ),
                child: SwitchListTile(
                  value: theme.isDark,
                  onChanged: (_) => theme.toggle(),
                  title: Text('Earthy dark mode', style: text.titleMedium),
                  subtitle: Text(
                    'Warm charcoal instead of cream paper',
                    style: text.bodySmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
