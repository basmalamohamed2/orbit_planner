import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_planner/core/shapes/star_path.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/achievements/presentation/night_sky/night_sky_layout.dart';
import 'package:orbit_planner/features/tasks/domain/task.dart';

class NightSky extends StatefulWidget {
  const NightSky({super.key, required this.stars, required this.onStarTap});

  final List<Task> stars;
  final ValueChanged<Task> onStarTap;

  @override
  State<NightSky> createState() => _NightSkyState();
}

class _NightSkyState extends State<NightSky>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
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
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = NightSkyLayout.heightFor(widget.stars.length, width);
        final stars = NightSkyLayout.build(widget.stars, width);

        return Material(
          color: scheme.surfaceContainer,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colors.outline),
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Semantics(
              label:
                  '${stars.length} stars in your night sky. Tap a star to open its task.',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (details) {
                  final hit = NightSkyLayout.hitTest(
                    stars,
                    details.localPosition,
                  );
                  if (hit != null) widget.onStarTap(hit.task);
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: _BackdropPainter(colors: colors),
                      ),
                    ),
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: _StarsPainter(
                          stars: stars,
                          colors: colors,
                          animation: _controller,
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

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({required this.colors});

  final OrbitColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.lerp(colors.outline, colors.muted, 0.5)!;
    final random = math.Random(11);
    final count = (size.width * size.height / 3500).round();

    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BackdropPainter old) => old.colors != colors;
}

class _StarsPainter extends CustomPainter {
  _StarsPainter({
    required this.stars,
    required this.colors,
    required this.animation,
  }) : super(repaint: animation);

  final List<SkyStar> stars;
  final OrbitColors colors;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final t = animation.value;

    for (final star in stars) {
      final scale = 1 + 0.07 * math.sin(2 * math.pi * (t + star.phase));
      final path = starPath(
        star.center,
        star.radius * scale,
        rotation: star.rotation,
      );

      canvas.drawPath(
        path.shift(const Offset(1.5, 1.5)),
        Paint()..color = colors.shadow,
      );
      canvas.drawPath(path, Paint()..color = colors.star);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) =>
      old.stars != stars || old.colors != colors;
}
