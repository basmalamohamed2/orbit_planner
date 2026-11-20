import 'package:orbit_planner/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._prefs);

  static const _themeKey = 'settings_theme_mode';
  static const _motionKey = 'settings_motion_enabled';
  static const _onboardingKey = 'settings_onboarding_seen';

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    final themeName = _prefs.getString(_themeKey);
    var themeMode = AppThemeMode.system;
    for (final mode in AppThemeMode.values) {
      if (mode.name == themeName) themeMode = mode;
    }

    return AppSettings(
      themeMode: themeMode,
      motionEnabled: _prefs.getBool(_motionKey) ?? true,
      onboardingSeen: _prefs.getBool(_onboardingKey) ?? false,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setString(_themeKey, settings.themeMode.name),
      _prefs.setBool(_motionKey, settings.motionEnabled),
      _prefs.setBool(_onboardingKey, settings.onboardingSeen),
    ]);
  }
}
