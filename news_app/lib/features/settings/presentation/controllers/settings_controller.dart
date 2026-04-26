import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/app_preferences.dart';
import '../../../../core/services/service_providers.dart';

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.localeCode,
    required this.preferredCategories,
  });

  final ThemeMode themeMode;
  final String localeCode;
  final List<String> preferredCategories;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? localeCode,
    List<String>? preferredCategories,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      preferredCategories: preferredCategories ?? this.preferredCategories,
    );
  }
}

class SettingsController extends StateNotifier<AppSettings> {
  SettingsController(this._preferences)
    : super(
        AppSettings(
          themeMode: _preferences.themeMode,
          localeCode: _preferences.localeCode,
          preferredCategories: _preferences.preferredCategories.isEmpty
              ? AppConstants.defaultPreferredCategories
              : _preferences.preferredCategories,
        ),
      );

  final AppPreferences _preferences;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _preferences.saveThemeMode(mode);
  }

  Future<void> toggleThemeMode() async {
    final next = switch (state.themeMode) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.system,
      ThemeMode.system => ThemeMode.dark,
    };
    await setThemeMode(next);
  }

  Future<void> setLocaleCode(String localeCode) async {
    state = state.copyWith(localeCode: localeCode);
    await _preferences.saveLocaleCode(localeCode);
  }

  Future<void> togglePreferredCategory(String slug) async {
    final updated = state.preferredCategories.toList();
    if (updated.contains(slug)) {
      updated.remove(slug);
    } else {
      updated.add(slug);
    }

    state = state.copyWith(preferredCategories: updated);
    await _preferences.savePreferredCategories(updated);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AppSettings>((ref) {
      return SettingsController(ref.read(appPreferencesProvider));
    });
