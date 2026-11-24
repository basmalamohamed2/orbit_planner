import 'package:orbit_planner/features/settings/domain/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._prefs);

  static const _themeKey = 'settings_theme_mode';
  static const _motionKey = 'settings_motion_enabled';
  static const _onboardingKey = 'settings_onboarding_seen';
  static const _remindersKey = 'settings_reminders_enabled';
  static const _reminderLeadKey = 'settings_reminder_lead';

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    final themeName = _prefs.getString(_themeKey);
    var themeMode = AppThemeMode.system;
    for (final mode in AppThemeMode.values) {
      if (mode.name == themeName) themeMode = mode;
    }

    final leadName = _prefs.getString(_reminderLeadKey);
    var reminderLead = ReminderLead.atDueTime;
    for (final lead in ReminderLead.values) {
      if (lead.name == leadName) reminderLead = lead;
    }

    return AppSettings(
      themeMode: themeMode,
      motionEnabled: _prefs.getBool(_motionKey) ?? true,
      onboardingSeen: _prefs.getBool(_onboardingKey) ?? false,
      remindersEnabled: _prefs.getBool(_remindersKey) ?? false,
      reminderLead: reminderLead,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setString(_themeKey, settings.themeMode.name),
      _prefs.setBool(_motionKey, settings.motionEnabled),
      _prefs.setBool(_onboardingKey, settings.onboardingSeen),
      _prefs.setBool(_remindersKey, settings.remindersEnabled),
      _prefs.setString(_reminderLeadKey, settings.reminderLead.name),
    ]);
  }
}
