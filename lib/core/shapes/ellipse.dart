import 'dart:math' as math;
import 'dart:ui';

Offset pointOnEllipse(
  Offset center,
  double rx,
  double ry,
  double rotation,
  double angle,
) {
  final x = rx * math.cos(angle);
  final y = ry * math.sin(angle);
  return center +
      Offset(
        x * math.cos(rotation) - y * math.sin(rotation),
        x * math.sin(rotation) + y * math.cos(rotation),
      );
}
