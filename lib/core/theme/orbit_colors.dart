import 'package:flutter/material.dart';

@immutable
class OrbitColors extends ThemeExtension<OrbitColors> {
  const OrbitColors({
    required this.study,
    required this.work,
    required this.personal,
    required this.sun,
    required this.star,
    required this.outline,
    required this.muted,
    required this.shadow,
  });

  final Color study;
  final Color work;
  final Color personal;
  final Color sun;
  final Color star;
  final Color outline;
  final Color muted;
  final Color shadow;

  static const light = OrbitColors(
    study: Color(0xFF3E6649),
    work: Color(0xFF2D4C73),
    personal: Color(0xFFB84E27),
    sun: Color(0xFFE5A93C),
    star: Color(0xFFB87A14),
    outline: Color(0xFFDDD6C8),
    muted: Color(0xFF59544B),
    shadow: Color(0xFF22201D),
  );

  static const dark = OrbitColors(
    study: Color(0xFF6FA37F),
    work: Color(0xFF6F93C4),
    personal: Color(0xFFE07A5F),
    sun: Color(0xFFE5A93C),
    star: Color(0xFFE5A93C),
    outline: Color(0xFF3A3633),
    muted: Color(0xFFA39E95),
    shadow: Color(0xFF0F0E0D),
  );

  @override
  OrbitColors copyWith({
    Color? study,
    Color? work,
    Color? personal,
    Color? sun,
    Color? star,
    Color? outline,
    Color? muted,
    Color? shadow,
  }) {
    return OrbitColors(
      study: study ?? this.study,
      work: work ?? this.work,
      personal: personal ?? this.personal,
      sun: sun ?? this.sun,
      star: star ?? this.star,
      outline: outline ?? this.outline,
      muted: muted ?? this.muted,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  OrbitColors lerp(ThemeExtension<OrbitColors>? other, double t) {
    if (other is! OrbitColors) return this;
    return OrbitColors(
      study: Color.lerp(study, other.study, t)!,
      work: Color.lerp(work, other.work, t)!,
      personal: Color.lerp(personal, other.personal, t)!,
      sun: Color.lerp(sun, other.sun, t)!,
      star: Color.lerp(star, other.star, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension OrbitThemeX on BuildContext {
  OrbitColors get orbit => Theme.of(this).extension<OrbitColors>()!;
}
