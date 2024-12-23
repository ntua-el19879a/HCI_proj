import 'package:flutter/material.dart';
import 'package:prioritize_it/screens/home_screen.dart';
import 'package:prioritize_it/screens/add_task_screen.dart';
import 'package:prioritize_it/screens/settings_screen.dart';
import 'package:prioritize_it/screens/streak_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prioritize-It',
      theme: ThemeData(
        // Define your app's theme here
        primarySwatch: Colors.blue,
        // ...
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add_task': (context) => AddTaskScreen(),
        '/settings': (context) => SettingsScreen(),
        '/streak': (context) => StreakScreen(),
        // ... other routes
      },
    );
  }
}