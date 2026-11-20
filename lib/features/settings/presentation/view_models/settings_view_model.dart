import 'package:flutter/material.dart';
import 'package:orbit_planner/features/settings/domain/app_settings.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel(this._repository, AppSettings initial)
    : _settings = initial;

  final SettingsRepository _repository;
  AppSettings _settings;

  AppThemeMode get appThemeMode => _settings.themeMode;
  bool get motionEnabled => _settings.motionEnabled;
  bool get onboardingSeen => _settings.onboardingSeen;

  ThemeMode get themeMode => switch (_settings.themeMode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update(_settings.copyWith(themeMode: mode));

  Future<void> setMotionEnabled(bool enabled) =>
      _update(_settings.copyWith(motionEnabled: enabled));

  Future<void> markOnboardingSeen() =>
      _update(_settings.copyWith(onboardingSeen: true));

  Future<void> resetOnboarding() =>
      _update(_settings.copyWith(onboardingSeen: false));

  Future<void> _update(AppSettings next) async {
    _settings = next;
    notifyListeners();
    await _repository.save(next);
  }
}
