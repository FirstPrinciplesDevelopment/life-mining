import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// Uses shared_preferences to persist user settings.
class SettingsService {
  SettingsService(this.prefs);

  final SharedPreferences prefs;
  final String themeKey = 'theme';

  /// Loads the User's preferred ThemeMode from local storage.
  ///
  /// Defaults to [ThemeMode.system] if preferred ThemeMode not found
  Future<ThemeMode> themeMode() async {
    // Retrieve User's preferences
    int? themeValue = prefs.getInt(themeKey);
    if (themeValue == null) {
      return ThemeMode.system;
    } else {
      return ThemeMode.values[themeValue];
    }
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally
    await prefs.setInt(themeKey, theme.index);
  }
}
