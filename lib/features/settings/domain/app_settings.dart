enum AppThemeMode { system, light, dark }

class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.motionEnabled = true,
    this.onboardingSeen = false,
  });

  final AppThemeMode themeMode;

  final bool motionEnabled;

  final bool onboardingSeen;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? motionEnabled,
    bool? onboardingSeen,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      motionEnabled: motionEnabled ?? this.motionEnabled,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }
}

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}
