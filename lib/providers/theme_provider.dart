import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.blue[200],
  );

  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
  );

  final ThemeData darkIndigoTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.indigo[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo[800],
    ),
  );

  final ThemeData lightGreenTheme = ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.green[100],
  );

  final ThemeData darkGreenTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.green[800],
  );

  final ThemeData spaceTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primarySwatch: Colors.grey,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );

  final ThemeData royalTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.purple[100],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  );

  final ThemeData oceanTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.lightBlue[100],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  );

  final ThemeData sunsetTheme = ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.orange[100],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  );

  ThemeData _currentTheme;
  String _currentThemeName;

  ThemeProvider()
      : _currentTheme = ThemeData.light(),
        _currentThemeName = 'Light Blue' {
    _loadInitialTheme();
  }

  ThemeData get currentTheme => _currentTheme;

  String get currentThemeName => _currentThemeName;

  void setTheme(ThemeData theme, String themeName) async {
    _currentTheme = theme;
    _currentThemeName = themeName;
    notifyListeners();

    // Save the selected theme to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeName);
  }

  Future<void> _loadInitialTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedThemeName = prefs.getString('selectedTheme');

    if (savedThemeName != null) {
      _currentThemeName = savedThemeName;
      _currentTheme = getThemeByName(savedThemeName);
    } else {
      _currentTheme = lightTheme; // Default to light theme
      _currentThemeName = 'Light Blue';
    }

    notifyListeners();
  }

  ThemeData getThemeByName(String name) {
    switch (name) {
      case 'Light Blue':
        return lightTheme;
      case 'Dark Indigo':
        return darkIndigoTheme;
      case 'Light Green':
        return lightGreenTheme;
      case 'Dark Green':
        return darkGreenTheme;
      case 'Space':
        return spaceTheme;
      case 'Royal':
        return royalTheme;
      case 'Ocean':
        return oceanTheme;
      case 'Sunset':
        return sunsetTheme;
      default:
        return lightTheme; // Default to light theme if not found
    }
  }
}