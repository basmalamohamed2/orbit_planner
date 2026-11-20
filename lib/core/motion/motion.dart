import 'package:flutter/widgets.dart';

void syncLoopingAnimation(
  BuildContext context,
  AnimationController controller, {
  required bool enabled,
}) {
  final allowed = enabled && !MediaQuery.disableAnimationsOf(context);
  if (!allowed) {
    controller.stop();
  } else if (!controller.isAnimating) {
    controller.repeat();
  }
}
