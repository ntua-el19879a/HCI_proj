import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:prioritize_it/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services with error handling
  try {
    await DatabaseService.initialize();
    print("DatabaseService initialized successfully.");
  } catch (e) {
    print("Error initializing DatabaseService: $e");
    return; // Consider alternative error handling (e.g., show error screen)
  }

  try {
    await NotificationService.initialize();
    print("NotificationService initialized successfully.");
  } catch (e) {
    print("Error initializing NotificationService: $e");
    // You might want to handle this differently, e.g., by disabling
    // notifications or showing a warning to the user
  }

  // Load the user's theme preference before creating the app
  bool isDarkMode = await ThemeProvider.loadThemePreference();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) {
          var userProvider = UserProvider();
          userProvider.loadUser(); // Load user data immediately
          return userProvider;
        }),
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode)),
        // ... other providers
      ],
      child: const App(),
    ),
  );
}