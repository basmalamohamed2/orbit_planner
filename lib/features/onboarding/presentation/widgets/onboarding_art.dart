import 'package:flutter/material.dart';
import 'package:orbit_planner/core/shapes/ellipse.dart';
import 'package:orbit_planner/core/shapes/orbit_drawing.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';
import 'package:orbit_planner/features/onboarding/presentation/onboarding_slides.dart';

class OnboardingArt extends StatelessWidget {
  const OnboardingArt({super.key, required this.kind, required this.size});

  final OnboardingArtKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _ArtPainter(kind, context.orbit)),
    );
  }
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.kind, this.colors);

  final OnboardingArtKind kind;
  final OrbitColors colors;

  Color get _ringColor => Color.lerp(colors.outline, colors.muted, 0.35)!;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final c = Offset(s / 2, s / 2);

    switch (kind) {
      case OnboardingArtKind.sun:
        _paintSun(canvas, s, c);
      case OnboardingArtKind.orbits:
        _paintOrbits(canvas, s, c);
      case OnboardingArtKind.stars:
        _paintStars(canvas, s, c);
    }
  }

  void _paintSun(Canvas canvas, double s, Offset c) {
    const rot = -0.1;
    final rx = s * 0.38;
    final ry = s * 0.36;

    _ring(canvas, c, rx, ry, rot);
    drawSunDisc(canvas, c, s * 0.13, colors.sun, colors.shadow);
    _planet(
      canvas,
      pointOnEllipse(c, rx, ry, rot, -0.9),
      s * 0.075,
      colors.personal,
    );
    _planet(
      canvas,
      pointOnEllipse(c, rx, ry, rot, 2.4),
      s * 0.055,
      colors.work,
    );
    _planet(
      canvas,
      pointOnEllipse(c, rx, ry, rot, 4.3),
      s * 0.04,
      colors.study,
    );
  }

  void _paintOrbits(Canvas canvas, double s, Offset c) {
    const rotInner = -0.06;
    const rotMid = 0.1;
    const rotOuter = -0.04;
    final inner = [s * 0.2, s * 0.19];
    final mid = [s * 0.33, s * 0.31];
    final outer = [s * 0.46, s * 0.44];

    _ring(canvas, c, outer[0], outer[1], rotOuter);
    _ring(canvas, c, mid[0], mid[1], rotMid);
    _ring(canvas, c, inner[0], inner[1], rotInner);
    drawSunDisc(canvas, c, s * 0.08, colors.sun, colors.shadow);

    _planet(
      canvas,
      pointOnEllipse(c, inner[0], inner[1], rotInner, 0.6),
      s * 0.06,
      colors.personal,
    );
    _planet(
      canvas,
      pointOnEllipse(c, mid[0], mid[1], rotMid, 3.6),
      s * 0.05,
      colors.work,
    );
    _planet(
      canvas,
      pointOnEllipse(c, outer[0], outer[1], rotOuter, 5.3),
      s * 0.04,
      colors.study,
    );
  }

  void _paintStars(Canvas canvas, double s, Offset c) {
    _ring(canvas, c, s * 0.3, s * 0.28, 0.08);

    const stars = <List<double>>[
      [0.50, 0.50, 0.17, 0.0],
      [0.22, 0.28, 0.09, -0.15],
      [0.78, 0.22, 0.065, 0.2],
      [0.78, 0.74, 0.10, -0.1],
      [0.24, 0.74, 0.055, 0.25],
      [0.52, 0.90, 0.045, -0.2],
    ];
    for (final st in stars) {
      drawStar(
        canvas,
        Offset(s * st[0], s * st[1]),
        s * st[2],
        colors.star,
        colors.shadow,
        rotation: st[3],
      );
    }

    final dot = Paint()..color = _ringColor;
    for (final d in const [
      [0.1, 0.5],
      [0.9, 0.48],
      [0.4, 0.1],
      [0.65, 0.12],
      [0.9, 0.9],
    ]) {
      canvas.drawCircle(Offset(s * d[0], s * d[1]), s * 0.008, dot);
    }
  }

  void _ring(Canvas canvas, Offset c, double rx, double ry, double rot) {
    drawDashedEllipse(canvas, c, rx, ry, rot, _ringColor);
  }

  void _planet(Canvas canvas, Offset p, double r, Color color) {
    drawPlanetDisc(canvas, p, r, color, colors.shadow);
  }

  @override
  bool shouldRepaint(_ArtPainter old) =>
      old.kind != kind || old.colors != colors;
}
