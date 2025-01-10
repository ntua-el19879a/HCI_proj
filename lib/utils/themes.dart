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

final AppTheme indigoTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.indigo[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.indigo[800],
    ),
  ),
  primary: Colors.indigo,
  secondary: Colors.indigoAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme greenTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.green[100],
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
    scaffoldBackgroundColor: Colors.green[800],
  ),
  primary: Colors.green,
  secondary: Colors.greenAccent,
  primaryText: Colors.white,
  secondaryText: Colors.white70,
);

final AppTheme spaceTheme = AppTheme(
  themeData: ThemeData(
    scaffoldBackgroundColor: Colors.black,
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

final AppTheme royalTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.purple[100],
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
    scaffoldBackgroundColor: Colors.lightBlue[100],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.blue,
  secondary: Colors.lightBlueAccent,
  primaryText: Colors.black87,
  secondaryText: Colors.black54,
);

final AppTheme sunsetTheme = AppTheme(
  themeData: ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.orange[100],
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
  ),
  primary: Colors.orange,
  secondary: Colors.deepOrange,
  primaryText: Colors.black87,
  secondaryText: Colors.black54,
);
