import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/screens/auth_screen.dart';
import 'package:prioritize_it/screens/home_screen.dart';
import 'package:prioritize_it/screens/add_task_screen.dart';
import 'package:prioritize_it/screens/login_screen.dart';
import 'package:prioritize_it/screens/settings_screen.dart';
import 'package:prioritize_it/screens/streak_screen.dart';
import 'package:prioritize_it/screens/calendar_screen.dart';
import 'package:provider/provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/screens/themes_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prioritize-It',
      theme: Provider.of<ThemeProvider>(context)
          .currentTheme, // Use currentTheme directly
      // Remove darkTheme and themeMode properties
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
        '/add_task': (context) => AddTaskScreen(),
        '/settings': (context) => SettingsScreen(),
        '/streak': (context) => StreakScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/themes': (context) => ThemesScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: authProvider.checkUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        return Consumer<CustomAuthProvider>(
          builder: (context, provider, _) {
            if (provider.currentUser != null) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          },
        );
      },
    );
  }
}
