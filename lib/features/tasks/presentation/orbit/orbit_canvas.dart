import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/motion/motion.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_layout.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_painter.dart';
import 'package:orbit_planner/features/tasks/presentation/task_ui.dart';

class OrbitCanvas extends StatefulWidget {
  const OrbitCanvas({
    super.key,
    required this.planets,
    required this.selectedId,
    required this.onSelect,
    this.motionEnabled = true,
  });

  final List<OrbitPlanet> planets;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final bool motionEnabled;

  @override
  State<OrbitCanvas> createState() => OrbitCanvasState();
}

class OrbitCanvasState extends State<OrbitCanvas>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 180),
  );

  late final AnimationController _celebrationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  OrbitCelebration? _celebration;
  double _size = 0;

  void celebrate(String taskId) {
    if (!widget.motionEnabled ||
        MediaQuery.disableAnimationsOf(context) ||
        _size == 0) {
      return;
    }

    final matches = widget.planets.where((p) => p.task.id == taskId);
    if (matches.isEmpty) return;
    final planet = matches.first;

    setState(() {
      _celebration = OrbitCelebration(
        position: OrbitLayout.positionOf(planet, _controller.value, _size),
        radius: OrbitLayout.planetRadius(planet.task.priority) * _size,
        color: planet.task.category.color(context.orbit),
      );
    });
    _celebrationController.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    syncLoopingAnimation(context, _controller, enabled: widget.motionEnabled);
  }

  @override
  void didUpdateWidget(OrbitCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.motionEnabled != widget.motionEnabled) {
      syncLoopingAnimation(context, _controller, enabled: widget.motionEnabled);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.orbit;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        _size = size;

        return Center(
          child: SizedBox.square(
            dimension: size,
            child: Semantics(
              label:
                  '${widget.planets.length} tasks orbiting you. '
                  'Tap a planet to select it.',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final hit = OrbitLayout.hitTest(
                    widget.planets,
                    details.localPosition,
                    _controller.value,
                    size,
                  );
                  widget.onSelect(hit?.task.id);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: OrbitRingsPainter(colors: colors),
                      ),
                    ),
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: OrbitPlanetsPainter(
                          planets: widget.planets,
                          colors: colors,
                          animation: _controller,
                          selectedId: widget.selectedId,
                        ),
                      ),
                    ),
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: OrbitCelebrationPainter(
                          celebration: _celebration,
                          colors: colors,
                          animation: _celebrationController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
