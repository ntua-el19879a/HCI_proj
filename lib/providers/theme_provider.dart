import 'package:flutter/material.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/utils/theme_name.dart';
import 'package:prioritize_it/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModeType mode;
  AppTheme _currentTheme;
  ThemeName themeName;

  ThemeProvider({
    required ThemeModeType initialMode,
    required AppTheme initialTheme,
    required ThemeName initialName,
  })  : mode = initialMode,
        themeName = initialName,
        _currentTheme = initialTheme;

  AppTheme get currentTheme => _currentTheme;

  void switchMode(ThemeModeType newMode) {
    mode = newMode;
    switchTheme(themeName);
  }

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
    if (mode == ThemeModeType.dark) {
      _swithToDarkTheme(newThemeName);
    } else {
      _switchToLightTheme(newThemeName);
    }
    notifyListeners();
  }
}
