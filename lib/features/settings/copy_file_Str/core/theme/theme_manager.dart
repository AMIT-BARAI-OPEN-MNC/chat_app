import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeSelection {
  system,
  light,
  dark,
}

class ThemeManager extends ChangeNotifier {
  static const String themePreferenceKey = 'theme_preference';

  ThemeModeSelection _themeModeSelection = ThemeModeSelection.system;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeModeSelection get themeModeSelection => _themeModeSelection;
  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(themePreferenceKey) ?? 'system';
    _themeModeSelection = _themeModeSelectionFromString(themeString);
    _updateThemeMode();
  }

  void _updateThemeMode() {
    switch (_themeModeSelection) {
      case ThemeModeSelection.system:
        _themeMode = ThemeMode.system;
        break;
      case ThemeModeSelection.light:
        _themeMode = ThemeMode.light;
        break;
      case ThemeModeSelection.dark:
        _themeMode = ThemeMode.dark;
        break;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeModeSelection themeModeSelection) {
    _themeModeSelection = themeModeSelection;
    _updateThemeMode();
    _saveThemeMode();
  }

  void _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        themePreferenceKey, _themeModeSelection.toString().split('.').last);
  }

  ThemeModeSelection _themeModeSelectionFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeModeSelection.light;
      case 'dark':
        return ThemeModeSelection.dark;
      case 'system':
      default:
        return ThemeModeSelection.system;
    }
  }
}
