enum AppThemeMode { system, light, dark }

enum ReminderLead {
  atDueTime(Duration.zero, 'On time'),
  fifteenMinutes(Duration(minutes: 15), '15 min'),
  oneHour(Duration(hours: 1), '1 hour');

  const ReminderLead(this.duration, this.label);

  final Duration duration;
  final String label;
}

class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.motionEnabled = true,
    this.onboardingSeen = false,
    this.remindersEnabled = false,
    this.reminderLead = ReminderLead.atDueTime,
  });

  final AppThemeMode themeMode;

  final bool motionEnabled;

  final bool onboardingSeen;

  final bool remindersEnabled;

  final ReminderLead reminderLead;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? motionEnabled,
    bool? onboardingSeen,
    bool? remindersEnabled,
    ReminderLead? reminderLead,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      motionEnabled: motionEnabled ?? this.motionEnabled,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderLead: reminderLead ?? this.reminderLead,
    );
  }
}

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}
