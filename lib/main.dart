import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:prioritize_it/utils/theme_mode_type.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService db;

  // Initialize services with error handling
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    db = DatabaseService();
    debugPrint('Database successfully initialized');
  } catch (e) {
    debugPrint("Error initializing database: $e");
    return; // Consider alternative error handling (e.g., show error screen)
  }

  try {
    await NotificationService.initialize();
    debugPrint("NotificationService initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing NotificationService: $e");
    // You might want to handle this differently, e.g., by disabling
    // notifications or showing a warning to the user
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider(db)),
        ChangeNotifierProvider(create: (context) {
          var userProvider = UserProvider(db);
          userProvider.loadUser(); // Load user data immediately
          return userProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            initialMode: ThemeModeType.light,
            initialTheme: greenTheme,
          ),
        ),
        ChangeNotifierProvider(create: (context) => CustomAuthProvider(db)),
        // ... other providers
      ],
      child: const App(),
    ),
  );
}
