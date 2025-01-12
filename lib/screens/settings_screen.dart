//settings_screen.dart

import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/global_settings_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:prioritize_it/utils/global_settings.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:prioritize_it/widgets/styled_switch_list_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: SETTINGS_TITLE,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<GlobalSettingsProvider>(
              builder: (context, globalSettings, child) {
                return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                  return StyledSwitchListTile(
                      title: 'Dark Mode',
                      value: GlobalSettings.themeModeType == ThemeModeType.dark,
                      onChanged: (value) {
                        globalSettings.toggleTheme(value);
                        themeProvider.switchTheme(themeProvider.themeName);
                      });
                });
              },
            ),
            Consumer<GlobalSettingsProvider>(
              builder: (context, globalSettings, child) {
                return StyledSwitchListTile(
                    title: 'Show notifications',
                    value: GlobalSettings.showNotifications,
                    onChanged: (value) =>
                        globalSettings.toggleNotifications(value));
              },
            ),
            Consumer<GlobalSettingsProvider>(
              builder: (context, globalSettings, child) {
                return StyledSwitchListTile(
                    title: 'Sound effects',
                    value: GlobalSettings.soundEffects,
                    onChanged: (value) =>
                        globalSettings.toggleSoundEffects(value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
