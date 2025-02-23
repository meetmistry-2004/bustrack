import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Android initialization settings.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint("Notification tapped with payload: ${response.payload}");
        // Add navigation logic here if needed.
      },
    );
    // Skipping requestPermission() call.
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'bus_notification_channel', // channel id
      'Bus Notifications', // channel name
      channelDescription: 'Channel for bus notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        0, // notification id
        title,
        body,
        notificationDetails,
        payload: 'bus_notification',
      );
    } catch (e) {
      debugPrint("Error showing notification: $e");
    }
  }
}
