// NotificationsPage.dart
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
      body: SharedLocationData.notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: SharedLocationData.notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(SharedLocationData.notifications[index]),
                );
              },
            ),
    );
  }
}
