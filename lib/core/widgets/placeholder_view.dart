import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';

class PlaceholderView extends StatelessWidget {
  const PlaceholderView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: context.orbit.muted),
            const SizedBox(height: 16),
            Text(title, style: text.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: text.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
