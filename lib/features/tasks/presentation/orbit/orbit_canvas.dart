import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_layout.dart';
import 'package:orbit_planner/features/tasks/presentation/orbit/orbit_painter.dart';

class OrbitCanvas extends StatefulWidget {
  const OrbitCanvas({
    super.key,
    required this.planets,
    required this.selectedId,
    required this.onSelect,
  });

  final List<OrbitPlanet> planets;
  final String? selectedId;
  final ValueChanged<String?> onSelect;

  @override
  State<OrbitCanvas> createState() => _OrbitCanvasState();
}

class _OrbitCanvasState extends State<OrbitCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 180),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.orbit;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

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
