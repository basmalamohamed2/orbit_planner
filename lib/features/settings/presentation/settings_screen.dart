import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
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
                  value: isDark,
                  onChanged: (_) => onToggleTheme(),
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
