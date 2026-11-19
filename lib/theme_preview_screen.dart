import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/breakpoints.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final orbit = context.orbit;

    return Scaffold(
      appBar: AppBar(
        title: Text('Orbit Planner', style: text.headlineMedium),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              Text('3 planets in your orbit today', style: text.headlineLarge),
              const SizedBox(height: 8),
              Text('Completed tasks shine as stars.', style: text.bodyMedium),
              const SizedBox(height: 4),
              Text(
                'Deadlines are gentle gravitational realities.',
                style: text.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Layout: ${context.screenType.name} · '
                '${context.screenSize.width.round()}px',
                style: text.labelSmall,
              ),
              const SizedBox(height: 28),
              Text('CATEGORIES', style: text.labelSmall),
              const SizedBox(height: 14),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  _Planet(color: orbit.sun, label: 'You', size: 56),
                  _Planet(color: orbit.personal, label: 'Personal', size: 44),
                  _Planet(color: orbit.work, label: 'Work', size: 38),
                  _Planet(color: orbit.study, label: 'Study', size: 32),
                  _Planet(color: orbit.star, label: 'Star', size: 26),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: orbit.outline),
                  boxShadow: [
                    BoxShadow(color: orbit.outline, offset: const Offset(1, 1)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Physics Ch. 4', style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text('Due in 3 days', style: text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () {}, child: const Text('Add to Orbit')),
            ],
          ),
        ),
      ),
    );
  }
}

class _Planet extends StatelessWidget {
  const _Planet({required this.color, required this.label, required this.size});

  final Color color;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final orbit = context.orbit;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: orbit.shadow, offset: const Offset(2, 2)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
