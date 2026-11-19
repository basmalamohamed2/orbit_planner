import 'dart:math' as math;
import 'dart:ui';

Path starPath(
  Offset center,
  double radius, {
  int points = 5,
  double innerRatio = 0.45,
  double rotation = 0,
}) {
  final path = Path();
  final inner = radius * innerRatio;
  final step = math.pi / points;

  for (int i = 0; i < points * 2; i++) {
    final r = i.isEven ? radius : inner;
    final a = -math.pi / 2 + rotation + i * step;
    final p = Offset(center.dx + r * math.cos(a), center.dy + r * math.sin(a));
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  path.close();
  return path;
}
