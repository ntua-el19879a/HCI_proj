import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (add settings if targeting iOS)
     final DarwinInitializationSettings initializationSettingsIOS =
         DarwinInitializationSettings(
             // ... (iOS-specific settings)
        );

    // Initialization settings
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // Uncomment if targeting iOS
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required int id,
        required String title,
        required String body,
        String? payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'your_channel_id', // Replace with your channel ID
        'your_channel_name', // Replace with your channel name
        channelDescription:
        'your_channel_description', // Replace with your channel description
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }

// Add more methods for scheduling notifications, cancelling notifications, etc.
}
