import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
      ),
      body: ListView(
        children: [
          _buildThemeItem(
              context, 'Light Blue', Provider.of<ThemeProvider>(context).lightTheme, 0),
          _buildThemeItem(
              context, 'Dark Indigo', Provider.of<ThemeProvider>(context).darkIndigoTheme, 0),
          _buildThemeItem(
              context, 'Light Green', Provider.of<ThemeProvider>(context).lightGreenTheme, 0),
          _buildThemeItem(
              context, 'Dark Green', Provider.of<ThemeProvider>(context).darkGreenTheme, 0),
          _buildThemeItem(
              context, 'Space', Provider.of<ThemeProvider>(context).spaceTheme, 150),
          _buildThemeItem(
              context, 'Royal', Provider.of<ThemeProvider>(context).royalTheme, 200),
          _buildThemeItem(
              context, 'Ocean', Provider.of<ThemeProvider>(context).oceanTheme, 300),
          _buildThemeItem(
              context, 'Sunset', Provider.of<ThemeProvider>(context).sunsetTheme, 350),
          // Add more themes here
        ],
      ),
    );
  }

  Widget _buildThemeItem(
      BuildContext context, String name, ThemeData theme, int requiredPoints) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPoints = userProvider.user?.points ?? 0;
    final isLocked = userPoints < requiredPoints;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return ListTile(
      title: Text(name),
      subtitle: isLocked ? Text('Requires $requiredPoints points') : null,
      trailing: isLocked
          ? Icon(Icons.lock)
          : themeProvider.currentThemeName == name
          ? Icon(Icons.check_circle, color: Colors.green) // Show checkmark if selected
          : null,
      onTap: isLocked
          ? null
          : () {
        themeProvider.setTheme(theme, name);
      },
      tileColor: themeProvider.currentThemeName == name ? theme.primaryColor.withOpacity(0.5) : null,
    );
  }
}