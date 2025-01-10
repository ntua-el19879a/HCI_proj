// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with ChangeNotifier {
//   final ThemeData lightTheme = ThemeData(
//     primarySwatch: Colors.blue,
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Colors.blue[200],
//   );

//   final ThemeData darkTheme = ThemeData(
//     primarySwatch: Colors.indigo,
//     brightness: Brightness.dark,
//   );

//   final ThemeData darkIndigoTheme = ThemeData(
//     primarySwatch: Colors.indigo,
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: Colors.indigo[900],
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.indigo[800],
//     ),
//   );

//   final ThemeData lightGreenTheme = ThemeData(
//     primarySwatch: Colors.green,
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Colors.green[100],
//   );

//   final ThemeData darkGreenTheme = ThemeData(
//     brightness: Brightness.dark,
//     primarySwatch: Colors.green,
//     scaffoldBackgroundColor: Colors.green[800],
//   );

//   final ThemeData spaceTheme = ThemeData(
//     scaffoldBackgroundColor: Colors.black,
//     primarySwatch: Colors.grey,
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: Colors.white),
//       bodyMedium: TextStyle(color: Colors.white70),
//     ),
//   );

//   final ThemeData royalTheme = ThemeData(
//     primarySwatch: Colors.deepPurple,
//     scaffoldBackgroundColor: Colors.purple[100],
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//     ),
//   );

//   final ThemeData oceanTheme = ThemeData(
//     primarySwatch: Colors.blue,
//     scaffoldBackgroundColor: Colors.lightBlue[100],
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//     ),
//   );

//   final ThemeData sunsetTheme = ThemeData(
//     primarySwatch: Colors.orange,
//     scaffoldBackgroundColor: Colors.orange[100],
//     textTheme: TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//     ),
//   );

//   ThemeData _currentTheme;
//   String _currentThemeName;
//   bool _isDarkMode = false;

//   ThemeProvider()
//       : _currentTheme = ThemeData.light(),
//         _currentThemeName = 'Light Blue' {
//     _loadInitialTheme();
//   }

//   ThemeData get currentTheme => _currentTheme;

//   String get currentThemeName => _currentThemeName;

//   bool get isDarkMode => _isDarkMode;

//   // Updated setTheme method
//   void setTheme(ThemeData theme, String themeName) async {
//     _currentTheme = theme;
//     _currentThemeName = themeName;

//     // Apply dark mode modifications if _isDarkMode is true
//     if (_isDarkMode) {
//       _currentTheme = _applyDarkModeToTheme(theme);
//     }

//     notifyListeners();

//     // Save only the selected theme name to SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedTheme', themeName);
//   }

//   // Updated toggleDarkMode method
//   void toggleDarkMode() async {
//     _isDarkMode = !_isDarkMode;

//     // Re-apply dark mode modifications based on the new _isDarkMode value
//     _currentTheme = _applyDarkModeToTheme(getThemeByName(_currentThemeName));

//     notifyListeners();

//     // Save the dark mode preference to SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isDarkMode', _isDarkMode);
//   }

//   Future<void> _loadInitialTheme() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedThemeName = prefs.getString('selectedTheme');
//     _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Load dark mode preference

//     if (savedThemeName != null) {
//       _currentThemeName = savedThemeName;
//       _currentTheme = _getThemeData(savedThemeName);
//     } else {
//       _currentTheme = lightTheme; // Default to light theme
//       _currentThemeName = 'Light Blue';
//     }

//     // Apply dark mode modifications if _isDarkMode is true
//     if (_isDarkMode) {
//       _currentTheme = _applyDarkModeToTheme(_currentTheme);
//     }

//     notifyListeners();
//   }

//   // Helper method to get theme data based on name
//   ThemeData _getThemeData(String name) {
//     ThemeData baseTheme;
//     switch (name) {
//       case 'Light Blue':
//         baseTheme = lightTheme;
//         break;
//       case 'Dark Indigo':
//         baseTheme = darkIndigoTheme;
//         break;
//       case 'Light Green':
//         baseTheme = lightGreenTheme;
//         break;
//       case 'Dark Green':
//         baseTheme = darkGreenTheme;
//         break;
//       case 'Space':
//         baseTheme = spaceTheme;
//         break;
//       case 'Royal':
//         baseTheme = royalTheme;
//         break;
//       case 'Ocean':
//         baseTheme = oceanTheme;
//         break;
//       case 'Sunset':
//         baseTheme = sunsetTheme;
//         break;
//       default:
//         baseTheme = lightTheme; // Default to light theme if not found
//     }
//     return baseTheme;
//   }

//   // Helper method to apply dark mode modifications to a theme
//   ThemeData _applyDarkModeToTheme(ThemeData theme) {
//     if (_isDarkMode) {
//       return theme.copyWith(
//         scaffoldBackgroundColor: theme.scaffoldBackgroundColor
//             .withBlue(theme.scaffoldBackgroundColor.blue - 20)
//             .withGreen(theme.scaffoldBackgroundColor.green - 20)
//             .withRed(theme.scaffoldBackgroundColor.red - 20),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.black,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//           iconTheme: IconThemeData(color: Colors.white),
//           actionsIconTheme: IconThemeData(color: Colors.white),
//         ),
//         textTheme: theme.textTheme.apply(
//           bodyColor: Colors.white,
//           displayColor: Colors.white,
//         ),
//         switchTheme: SwitchThemeData(
//           thumbColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.white;
//                 }
//                 return null;
//               }),
//           trackColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.grey[400];
//                 }
//                 return null;
//               }),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         floatingActionButtonTheme: const FloatingActionButtonThemeData(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//         ),
//         dialogTheme: const DialogTheme(
//           backgroundColor: Colors.black,
//           titleTextStyle: TextStyle(color: Colors.white),
//           contentTextStyle: TextStyle(color: Colors.white),
//         ),
//       );
//     }
//     return theme;
//   }

//   // Add back the getThemeByName method
//   ThemeData getThemeByName(String name) {
//     switch (name) {
//       case 'Light Blue':
//         return lightTheme;
//       case 'Dark Indigo':
//         return darkIndigoTheme;
//       case 'Light Green':
//         return lightGreenTheme;
//       case 'Dark Green':
//         return darkGreenTheme;
//       case 'Space':
//         return spaceTheme;
//       case 'Royal':
//         return royalTheme;
//       case 'Ocean':
//         return oceanTheme;
//       case 'Sunset':
//         return sunsetTheme;
//       default:
//         return lightTheme;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:prioritize_it/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  final List<AppTheme> availableThemes;
  AppTheme _currentTheme;

  ThemeProvider({
    required this.availableThemes,
    required AppTheme initialTheme,
  }) : _currentTheme = initialTheme;

  AppTheme get currentTheme => _currentTheme;

  void switchTheme(AppTheme newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }
}
