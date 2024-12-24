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
  bool _isDarkMode;
  String _currentThemeName;

  ThemeProvider(bool isDarkMode)
      : _isDarkMode = isDarkMode,
        _currentTheme = isDarkMode
            ? ThemeData.dark()
            : ThemeData
            .light(), // Initialize _currentTheme in the constructor
        _currentThemeName = isDarkMode ? 'Dark Indigo' : 'Light Blue' {
    _loadInitialTheme();
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;
  String get currentThemeName => _currentThemeName;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode ? darkTheme : lightTheme;
    _currentThemeName = _isDarkMode ? 'Dark Indigo' : 'Light Blue';
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void setTheme(ThemeData theme, String themeName) async {
    _currentTheme = theme;
    _currentThemeName = themeName;
    _isDarkMode =
        theme.brightness == Brightness.dark;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeName);
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  static Future<bool> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> _loadInitialTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedThemeName = prefs.getString('selectedTheme');

    if (savedThemeName != null) {
      _currentThemeName = savedThemeName;
      _currentTheme = getThemeByName(savedThemeName);
      _isDarkMode = _currentTheme.brightness == Brightness.dark;
    } else {
      bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _currentTheme = isDarkMode ? darkTheme : lightTheme;
      _currentThemeName = isDarkMode ? 'Dark Indigo' : 'Light Blue';
      _isDarkMode = isDarkMode;
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
        return lightTheme;
    }
  }
}