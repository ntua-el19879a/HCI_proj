import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:prioritize_it/utils/theme_name.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:provider/provider.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;

    return BaseLayout(
        title: 'Themes',
        body: ListView(
          children: [
            _buildThemeItem(
                context, ThemeName.green, greenTheme, 0),
            _buildThemeItem(
                context, ThemeName.blue, blueTheme, 0),
            _buildThemeItem(
                context, ThemeName.red, redTheme, 0),
            _buildThemeItem(
                context, ThemeName.teal, tealTheme, 200),
            _buildThemeItem(
                context, ThemeName.royal, royalTheme, 200),
            _buildThemeItem(
                context, ThemeName.ocean, oceanTheme, 300),
            _buildThemeItem(
                context, ThemeName.sunset, sunsetTheme, 350),
            // Add more themes here
          ],
        ));
  }

  Widget _buildThemeItem(BuildContext context, ThemeName name, AppTheme theme,
      int requiredPoints) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;
    final isLocked = userPoints < requiredPoints;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return ListTile(
      title: Text(themeNameStringMap[name] ?? 'Unknown'),
      subtitle: isLocked ? Text('Requires $requiredPoints points') : null,
      trailing: isLocked
          ? Icon(Icons.lock)
          : themeProvider.themeName == name
          ? Icon(Icons.check_circle,
          color: themeProvider
              .currentTheme.primary) // Show checkmark if selected
          : null,
      onTap: isLocked
          ? null
          : () async {
        HapticFeedback.selectionClick();
        themeProvider.switchTheme(name);
        if (!isLocked) {
          await NotificationService.showNotification(
            id: name.hashCode,
            title: 'New Theme Unlocked!',
            body: 'You have unlocked the ${themeNameStringMap[name] ?? ''} theme. Check it out!',
          );
        }
      },
      tileColor: themeProvider.themeName == name
          ? themeProvider.currentTheme.primary.withValues(alpha: .5)
          : null,
    );
  }
}