import 'package:flutter/material.dart';
import 'package:prioritize_it/utils/global_settings.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/utils/theme_name.dart';
import 'package:prioritize_it/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme;
  ThemeName themeName;

  ThemeProvider({
    required AppTheme initialTheme,
    required ThemeName initialName,
  })  : themeName = initialName,
        _currentTheme = initialTheme;

  AppTheme get currentTheme => _currentTheme;

  void _swithToDarkTheme(ThemeName newThemeName) {
    if (newThemeName == ThemeName.blue) {
      _currentTheme = darkBlueTheme;
    }
    if (newThemeName == ThemeName.green) {
      _currentTheme = darkGreenTheme;
    }
    if (newThemeName == ThemeName.red) {
      _currentTheme = darkRedTheme;
    }
    if (newThemeName == ThemeName.teal) {
      _currentTheme = darkTealTheme;
    }
    if (newThemeName == ThemeName.royal) {
      _currentTheme = darkRoyalTheme;
    }
    if (newThemeName == ThemeName.ocean) {
      _currentTheme = darkOceanTheme;
    }
    if (newThemeName == ThemeName.sunset) {
      _currentTheme = darkSunsetTheme;
    }
  }

  void _switchToLightTheme(ThemeName newThemeName) {
    if (newThemeName == ThemeName.blue) {
      _currentTheme = blueTheme;
    }
    if (newThemeName == ThemeName.green) {
      _currentTheme = greenTheme;
    }
    if (newThemeName == ThemeName.red) {
      _currentTheme = redTheme;
    }
    if (newThemeName == ThemeName.teal) {
      _currentTheme = tealTheme;
    }
    if (newThemeName == ThemeName.royal) {
      _currentTheme = royalTheme;
    }
    if (newThemeName == ThemeName.ocean) {
      _currentTheme = oceanTheme;
    }
    if (newThemeName == ThemeName.sunset) {
      _currentTheme = sunsetTheme;
    }
  }

  void switchTheme(ThemeName newThemeName) {
    themeName = newThemeName;
    if (GlobalSettings.themeModeType == ThemeModeType.dark) {
      _swithToDarkTheme(newThemeName);
    } else {
      _switchToLightTheme(newThemeName);
    }
    notifyListeners();
  }
}