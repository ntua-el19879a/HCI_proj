import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData themeData;
  final Color primary;
  final Color secondary;
  final Color primaryText;
  final Color secondaryText;

  AppTheme({
    required this.themeData,
    required this.primary,
    required this.secondary,
    required this.primaryText,
    required this.secondaryText,
  });
}

final Color lightBackgroundColor = Colors.grey[200]!; // Shared light background
final Color darkBackgroundColor = Colors.grey[900]!; // Shared dark background

final AppTheme greenTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
  ),
  primary: Colors.green,
  secondary: Colors.lightGreen,
  primaryText: Colors.black,
  secondaryText: Colors.black54,
);

final AppTheme darkGreenTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
  ),
  primary: Colors.green,
  secondary: Colors.greenAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme blueTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
  ),
  primary: Colors.blue,
  secondary: Colors.lightBlueAccent,
  primaryText: Colors.black,
  secondaryText: Colors.black54,
);

final AppTheme darkBlueTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
  ),
  primary: Colors.blue,
  secondary: Colors.blueAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme redTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
  ),
  primary: Colors.red,
  secondary: Colors.redAccent,
  primaryText: Colors.black,
  secondaryText: Colors.black54,
);

final AppTheme darkRedTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
  ),
  primary: Colors.red,
  secondary: Colors.redAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme spaceTheme = AppTheme(
  themeData: ThemeData(
      scaffoldBackgroundColor:
          lightBackgroundColor, // Use shared dark background
      primarySwatch: Colors.grey,
      brightness: Brightness.light),
  primary: Colors.grey,
  secondary: Colors.white,
  primaryText: Colors.black,
  secondaryText: Colors.black54,
);

final AppTheme royalTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.deepPurple,
  secondary: Colors.deepPurpleAccent,
  primaryText: Colors.black87,
  secondaryText: Colors.black54,
);

final AppTheme oceanTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.indigo,
  secondary: Colors.indigoAccent,
  primaryText: Colors.black87,
  secondaryText: Colors.black54,
);

final AppTheme sunsetTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    scaffoldBackgroundColor:
        lightBackgroundColor, // Use shared light background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.orange,
  secondary: Colors.deepOrange,
  primaryText: Colors.black87,
  secondaryText: Colors.black54,
);

final AppTheme darkSpaceTheme = AppTheme(
  themeData: ThemeData(
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
    primarySwatch: Colors.grey,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  ),
  primary: Colors.grey,
  secondary: Colors.white,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme darkRoyalTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.deepPurple,
  secondary: Colors.deepPurpleAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme darkOceanTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.blue,
  secondary: Colors.lightBlueAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme darkSunsetTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor, // Use shared dark background
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.orange,
  secondary: Colors.deepOrange,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);
