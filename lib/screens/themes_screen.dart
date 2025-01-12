import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:prioritize_it/utils/theme_name.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:prioritize_it/widgets/buttons/styled_text_button.dart';
import 'package:provider/provider.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Themes',
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          final List<ThemeName> unlockedThemes = user?.unlockedThemes ?? [];
          final userPoints = user?.points ?? 0;

          return ListView(
            children: [
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.blue, blueTheme, 0),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.green, greenTheme, 0),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.red, redTheme, 0),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.teal, tealTheme, 200),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.royal, royalTheme, 200),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.bubblegum, bubblegumTheme, 300),
              _buildThemeItem(context, unlockedThemes, userPoints,
                  ThemeName.sunset, sunsetTheme, 350),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeItem(
    BuildContext context,
    List<ThemeName> unlockedThemes,
    int userPoints,
    ThemeName name,
    AppTheme theme,
    int requiredPoints,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isLocked = !unlockedThemes.contains(name);
    final isSelected = themeProvider.themeName == name;

    return ListTile(
      title: Text(
        themeNameStringMap[name] ?? 'Unknown Theme',
        style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
      subtitle: isLocked
          ? Text('Requires $requiredPoints points',
              style: TextStyle(color: Colors.red))
          : null,
      trailing: isLocked
          ? userPoints >= requiredPoints
              ? StyledTextButton(
                  child: const Text('Unlock'),
                  onPressed: () async {
                    userProvider.unlockTheme(name, requiredPoints);

                    await NotificationService.showInstantNotification(
                      'Theme Unlocked!',
                      'You have unlocked the ${themeNameStringMap[name] ?? ''} theme.',
                    );
                  },
                )
              : Icon(Icons.lock, color: themeProvider.currentTheme.primaryText)
          : isSelected
              ? Icon(Icons.check_circle, color: theme.primary)
              : null,
      tileColor: isSelected ? theme.primary.withOpacity(0.1) : null,
      onTap: isLocked
          ? null
          : () {
              HapticFeedback.selectionClick();
              themeProvider.switchTheme(name);
            },
    );
  }
}
