import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: const Text('Settings'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
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
