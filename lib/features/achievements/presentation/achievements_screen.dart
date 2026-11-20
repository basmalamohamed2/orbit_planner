import 'package:flutter/material.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: const PlaceholderView(
        icon: Icons.star_outline,
        title: 'No stars yet',
        message: 'Completed tasks will shine here as stars.',
      ),
    );
  }
}
