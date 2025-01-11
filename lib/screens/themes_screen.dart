import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:prioritize_it/widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;

    return BaseLayout(
        title: const Text('Themes'),
        body: ListView(
          children: [
            _buildThemeItem(context, 'Green', greenTheme, 0),
            _buildThemeItem(context, 'Blue', blueTheme, 0),
            _buildThemeItem(context, 'Red', redTheme, 0),
            _buildThemeItem(context, 'Space', spaceTheme, 200),
            _buildThemeItem(context, 'Royal', royalTheme, 200),
            _buildThemeItem(context, 'Ocean', oceanTheme, 300),
            _buildThemeItem(context, 'Sunset', sunsetTheme, 350),
            // Add more themes here
          ],
        ));
  }

  Widget _buildThemeItem(
      BuildContext context, String name, AppTheme theme, int requiredPoints) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;
    final isLocked = userPoints < requiredPoints;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return ListTile(
      title: Text(name),
      subtitle: isLocked ? Text('Requires $requiredPoints points') : null,
      trailing: isLocked
          ? Icon(Icons.lock)
          : themeProvider.currentTheme == theme
              ? Icon(Icons.check_circle,
                  color: Colors.green) // Show checkmark if selected
              : null,
      onTap: isLocked
          ? null
          : () {
              HapticFeedback.selectionClick();
              themeProvider.switchTheme(theme);
            },
      tileColor: themeProvider.currentTheme == theme
          ? theme.primary.withOpacity(0.5)
          : null,
    );
  }
}
