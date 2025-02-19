import 'package:flutter/material.dart';
import 'package:trackbus/DriverMapPage.dart';
import 'package:trackbus/sharedlocation.dart';

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
            // Update shared data: mark route as started and set notification
            SharedLocationData.routeStarted = true;
            SharedLocationData.notification = "Route has started";
            // Navigate to the Driver Map page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DriverMapPage()),
            );
          },
          child: const Text("Start Route"),
        ),
      ),
    );
  }
}
