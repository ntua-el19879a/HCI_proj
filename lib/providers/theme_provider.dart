import 'package:flutter/material.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModeType mode;
  AppTheme _currentTheme;

  ThemeProvider({
    required ThemeModeType initialMode,
    required AppTheme initialTheme,
  })  : mode = initialMode,
        _currentTheme = initialTheme;

  AppTheme get currentTheme => _currentTheme;

  void switchMode(ThemeModeType newMode) {
    mode = newMode;
    switchTheme(currentTheme);
  }

  void _swithToDarkTheme(AppTheme newTheme) {
    if (newTheme == blueTheme) {
      _currentTheme = darkBlueTheme;
      return;
    }
    if (newTheme == greenTheme) {
      _currentTheme = darkGreenTheme;
      return;
    }
    if (newTheme == redTheme) {
      _currentTheme = darkRedTheme;
      return;
    }
    if (newTheme == spaceTheme) {
      _currentTheme = darkSpaceTheme;
      return;
    }
    if (newTheme == royalTheme) {
      _currentTheme = darkRoyalTheme;
      return;
    }
    if (newTheme == oceanTheme) {
      _currentTheme = darkOceanTheme;
      return;
    }
    if (newTheme == sunsetTheme) {
      _currentTheme = darkSunsetTheme;
      return;
    }
    // The below should not be reached.
    _currentTheme = newTheme;
  }

  void _switchToLightTheme(AppTheme newTheme) {
    if (newTheme == darkBlueTheme) {
      _currentTheme = blueTheme;
      return;
    }
    if (newTheme == darkGreenTheme) {
      _currentTheme = greenTheme;
      return;
    }
    if (newTheme == darkRedTheme) {
      _currentTheme = redTheme;
      return;
    }
    if (newTheme == darkSpaceTheme) {
      _currentTheme = spaceTheme;
      return;
    }
    if (newTheme == darkRoyalTheme) {
      _currentTheme = royalTheme;
      return;
    }
    if (newTheme == darkOceanTheme) {
      _currentTheme = oceanTheme;
      return;
    }
    if (newTheme == darkSunsetTheme) {
      _currentTheme = sunsetTheme;
      return;
    }
    // The below should not be reached.
    _currentTheme = newTheme;
  }

  void switchTheme(AppTheme newTheme) {
    if (mode == ThemeModeType.dark) {
      _swithToDarkTheme(newTheme);
    } else {
      _switchToLightTheme(newTheme);
    }
    notifyListeners();
  }
}
