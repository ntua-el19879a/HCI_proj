//main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prioritize_it/providers/auth_provider.dart';
import 'package:prioritize_it/providers/global_settings_provider.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/theme_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:prioritize_it/utils/theme_name.dart';
import 'package:prioritize_it/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final DatabaseService db;

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    db = DatabaseService();
    await NotificationService.initialize();
    debugPrint('Database successfully initialized');
  } catch (e) {
    debugPrint("Error initializing database: $e");
    return;
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
        ChangeNotifierProvider(create: (context) => GlobalSettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
              initialTheme: blueTheme, initialName: ThemeName.green),
        ),
        ChangeNotifierProvider(create: (context) => CustomAuthProvider(db)),
        // ... other providers
      ],
      child: const App(),
    ),
  );
}