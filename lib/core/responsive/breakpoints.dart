import 'package:flutter/material.dart';

enum ScreenSize { compact, medium, expanded }

class Breakpoints {
  Breakpoints._();

  static const double mediumMin = 600;
  static const double expandedMin = 1024;

  static ScreenSize of(double width) {
    if (width >= expandedMin) return ScreenSize.expanded;
    if (width >= mediumMin) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}

extension ResponsiveX on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  ScreenSize get screenType => Breakpoints.of(screenSize.width);

  bool get isCompact => screenType == ScreenSize.compact;
  bool get isMedium => screenType == ScreenSize.medium;
  bool get isExpanded => screenType == ScreenSize.expanded;

  T responsive<T>({required T compact, T? medium, T? expanded}) {
    switch (screenType) {
      case ScreenSize.compact:
        return compact;
      case ScreenSize.medium:
        return medium ?? compact;
      case ScreenSize.expanded:
        return expanded ?? medium ?? compact;
    }
  }
}
