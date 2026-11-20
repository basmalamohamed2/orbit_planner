import 'package:flutter/material.dart';

class AppDestination {
  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const appDestinations = <AppDestination>[
  AppDestination(
    label: 'Orbit',
    icon: Icons.public_outlined,
    selectedIcon: Icons.public,
  ),
  AppDestination(
    label: 'List',
    icon: Icons.format_list_bulleted,
    selectedIcon: Icons.format_list_bulleted,
  ),
  AppDestination(
    label: 'Achievements',
    icon: Icons.star_outline,
    selectedIcon: Icons.star,
  ),
  AppDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];
