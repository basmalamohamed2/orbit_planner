import 'package:flutter/material.dart';
import 'package:orbit_planner/app/shell/app_destinations.dart';
import 'package:orbit_planner/core/responsive/breakpoints.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/achievements/presentation/achievements_screen.dart';
import 'package:orbit_planner/features/settings/presentation/settings_screen.dart';
import 'package:orbit_planner/features/tasks/presentation/screens/list_view_screen.dart';
import 'package:orbit_planner/features/tasks/presentation/screens/orbit_view_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final _bodyKey = GlobalKey();

  void _select(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final body = IndexedStack(
      key: _bodyKey,
      index: _index,
      children: [
        const OrbitViewScreen(),
        const TaskListScreen(),
        const AchievementsScreen(),
        SettingsScreen(
          isDark: widget.isDark,
          onToggleTheme: widget.onToggleTheme,
        ),
      ],
    );

    if (context.isCompact) {
      return Scaffold(
        body: body,
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: context.orbit.outline)),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,
            destinations: [
              for (final d in appDestinations)
                NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ),
            ],
          ),
        ),
      );
    }

    final extended = context.isExpanded;
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            right: false,
            child: NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _select,
              extended: extended,
              // لما الـ rail يكون extended لازم labelType يبقى null
              labelType: extended ? null : NavigationRailLabelType.all,
              leading: _RailLogo(extended: extended),
              destinations: [
                for (final d in appDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _RailLogo extends StatelessWidget {
  const _RailLogo({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    final orbit = context.orbit;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: extended ? 16 : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: orbit.sun,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: orbit.shadow, offset: const Offset(2, 2)),
              ],
            ),
          ),
          if (extended) ...[
            const SizedBox(width: 12),
            Text(
              'Orbit Planner',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ],
      ),
    );
  }
}
