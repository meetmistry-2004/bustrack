import 'package:flutter/material.dart';
import 'package:trackbus/sharedlocation.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          SharedLocationData.notification.isEmpty
              ? "No notifications"
              : SharedLocationData.notification,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
