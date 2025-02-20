// DriverNavigationPage.dart
import 'package:flutter/material.dart';
import 'package:trackbus/DriverMapPage.dart';
import 'package:trackbus/sharedlocation.dart';
import 'package:trackbus/Notification_services.dart';

class DriverNavigationPage extends StatelessWidget {
  const DriverNavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Mark the route as started and trigger notification.
            SharedLocationData.routeStarted = true;
            String message = "Route has started";
            SharedLocationData.notifications.add(message);
            NotificationService().showNotification("Route Start", message);
            // Navigate to the Driver Map page.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DriverMapPage()),
            );
          },
          child: const Text("Start Navigation"),
        ),
      ),
    );
  }
}
