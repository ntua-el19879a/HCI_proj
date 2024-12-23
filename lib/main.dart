import 'package:flutter/material.dart';
import 'package:prioritize_it/providers/task_provider.dart';
import 'package:prioritize_it/providers/user_provider.dart';
import 'package:prioritize_it/services/database_service.dart';
import 'package:prioritize_it/services/gps_service.dart';
import 'package:prioritize_it/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await DatabaseService.initialize();
  // await GpsService.initialize();
  // await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()), // Provide UserProvider here
        // ... other providers
      ],
      child: const App(),
    ),
  );
}