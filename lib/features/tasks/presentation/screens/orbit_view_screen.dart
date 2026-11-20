import 'package:flutter/material.dart';
import 'package:orbit_planner/core/widgets/placeholder_view.dart';

class OrbitViewScreen extends StatelessWidget {
  const OrbitViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orbit')),
      body: const PlaceholderView(
        icon: Icons.public,
        title: 'Your orbit is quiet',
        message: 'Planets will drift here once we build the Orbit View.',
      ),
    );
  }
}
