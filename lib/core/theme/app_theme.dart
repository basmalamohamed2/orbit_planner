import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_planner/core/theme/orbit_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = _build(
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF22201D),
      onPrimary: Color(0xFFFBF8F1),
      secondary: Color(0xFFB84E27),
      onSecondary: Color(0xFFFBF8F1),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFBF8F1),
      surface: Color(0xFFFBF8F1),
      onSurface: Color(0xFF22201D),
      surfaceContainer: Color(0xFFF3EFE6),
      outline: Color(0xFFDDD6C8),
    ),
    orbit: OrbitColors.light,
  );

  static final ThemeData dark = _build(
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFF5F2EB),
      onPrimary: Color(0xFF1E1C1A),
      secondary: Color(0xFFE07A5F),
      onSecondary: Color(0xFF1E1C1A),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF1E1C1A),
      surface: Color(0xFF1E1C1A),
      onSurface: Color(0xFFF5F2EB),
      surfaceContainer: Color(0xFF292623),
      outline: Color(0xFF3A3633),
    ),
    orbit: OrbitColors.dark,
  );

  static ThemeData _build({
    required ColorScheme scheme,
    required OrbitColors orbit,
  }) {
    final textTheme = _textTheme(scheme.onSurface, orbit.muted);

    Color navColor(Set<WidgetState> states) =>
        states.contains(WidgetState.selected) ? scheme.onSurface : orbit.muted;

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      extensions: [orbit],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineMedium,
      ),
      dividerTheme: DividerThemeData(color: scheme.outline, thickness: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: orbit.outline,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(color: navColor(states), size: 24),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(color: navColor(states)),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: orbit.outline,
        selectedIconTheme: IconThemeData(color: scheme.onSurface),
        unselectedIconTheme: IconThemeData(color: orbit.muted),
        selectedLabelTextStyle: textTheme.labelLarge!.copyWith(
          color: scheme.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge!.copyWith(
          color: orbit.muted,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: orbit.muted,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          side: BorderSide(color: orbit.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: orbit.muted),
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.secondary),
        border: _inputBorder(orbit.outline),
        enabledBorder: _inputBorder(orbit.outline),
        focusedBorder: _inputBorder(scheme.onSurface, width: 1.5),
        errorBorder: _inputBorder(scheme.secondary),
        focusedErrorBorder: _inputBorder(scheme.secondary, width: 1.5),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 4,
        activeTrackColor: scheme.secondary,
        inactiveTrackColor: orbit.outline,
        thumbColor: scheme.secondary,
        overlayColor: scheme.secondary.withAlpha(31),
        activeTickMarkColor: scheme.onSecondary,
        inactiveTickMarkColor: orbit.muted,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: orbit.outline,
        side: BorderSide(color: orbit.outline),
        labelStyle: textTheme.labelLarge,
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.surface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme _textTheme(Color ink, Color muted) {
    final sans = GoogleFonts.latoTextTheme();

    TextStyle serif(double size, double lineHeight, double spacing) =>
        GoogleFonts.newsreader(
          fontSize: size,
          height: lineHeight / size,
          fontWeight: FontWeight.w600,
          letterSpacing: spacing,
          color: ink,
        );

    return sans.copyWith(
      displayLarge: serif(30, 36, -0.25),
      headlineLarge: serif(26, 32, -0.2),
      headlineMedium: serif(22, 28, -0.1),
      headlineSmall: serif(18, 24, 0),
      titleMedium: GoogleFonts.lato(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyMedium: GoogleFonts.lato(fontSize: 15, height: 22 / 15, color: ink),
      bodySmall: GoogleFonts.lato(fontSize: 13, height: 18 / 13, color: muted),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: ink,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: muted,
      ),
    );
  }
}
