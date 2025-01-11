//settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prioritize_it/utils/app_constants.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(
        title: SETTINGS_TITLE,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    activeColor: themeProvider.currentTheme.primary,
                    value: themeProvider.mode == ThemeModeType.dark,
                    onChanged: (value) {
                      HapticFeedback.mediumImpact();
                      themeProvider.switchMode(
                          value ? ThemeModeType.dark : ThemeModeType.light);
                    },
                  );
                },
              ),
              // ... Add other settings here
            ],
          ),
        ));
  }
}
