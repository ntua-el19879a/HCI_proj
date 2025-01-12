import 'package:flutter/foundation.dart';
import 'package:prioritize_it/utils/global_settings.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';

class GlobalSettingsProvider with ChangeNotifier {
  void toggleTheme(bool isDarkMode) {
    GlobalSettings.themeModeType =
    isDarkMode ? ThemeModeType.dark : ThemeModeType.light;
    notifyListeners();
  }

  void toggleNotifications(bool show) {
    GlobalSettings.showNotifications = show;
    notifyListeners();
  }

  void toggleSoundEffects(bool enable) {
    GlobalSettings.soundEffects = enable;
    notifyListeners();
  }
}