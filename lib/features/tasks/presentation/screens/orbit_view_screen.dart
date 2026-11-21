import 'package:flutter/material.dart';
import 'package:orbit_planner/core/responsive/breakpoints.dart';
import 'package:orbit_planner/core/responsive/responsive_layout.dart';
import 'package:orbit_planner/features/settings/presentation/view_models/settings_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_canvas.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_layout.dart';
import 'package:orbit_planner/features/tasks/presentation/screens/planet_detail_screen.dart';
import 'package:orbit_planner/features/tasks/presentation/view_models/tasks_view_model.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/add_task_fab.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/add_task_sheet.dart';
import 'package:orbit_planner/features/tasks/presentation/widgets/orbit_info_panel.dart';
import 'package:provider/provider.dart';

class OrbitViewScreen extends StatefulWidget {
  const OrbitViewScreen({super.key});

  @override
  State<OrbitViewScreen> createState() => _OrbitViewScreenState();
}

class _OrbitViewScreenState extends State<OrbitViewScreen> {
  String? _selectedId;

  final _canvasKey = GlobalKey<OrbitCanvasState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TasksViewModel>();

    final motion = context.select<SettingsViewModel, bool>(
      (s) => s.motionEnabled,
    );

    final planets = OrbitLayout.build(vm.activeTasks, DateTime.now());

    final candidate = _selectedId == null ? null : vm.taskById(_selectedId!);
    final selected = (candidate != null && !candidate.isCompleted)
        ? candidate
        : null;

    final canvas = OrbitCanvas(
      key: _canvasKey,
      motionEnabled: motion,
      planets: planets,
      selectedId: selected?.id,
      onSelect: (id) => setState(() => _selectedId = id),
    );

    final panel = OrbitInfoPanel(
      selected: selected,
      hasPlanets: planets.isNotEmpty,
      onComplete: () {
        if (selected == null) return;
        _canvasKey.currentState?.celebrate(selected.id);
        vm.toggleComplete(selected.id);
      },
      onEdit: () {
        if (selected != null) showEditTaskSheet(context, selected);
      },
      onOpenDetails: () {
        if (selected != null) openPlanetDetail(context, selected.id);
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Orbit')),
      floatingActionButton: const AddTaskFab(),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ResponsiveCenter(
                maxWidth: 1000,
                child: context.isExpanded
                    ? Row(
                        children: [
                          Expanded(child: canvas),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 300,
                            child: Center(
                              child: SingleChildScrollView(child: panel),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(child: canvas),
                          const SizedBox(height: 12),
                          panel,
                          const SizedBox(height: 72),
                        ],
                      ),
              ),
            ),
    );
  }
}
