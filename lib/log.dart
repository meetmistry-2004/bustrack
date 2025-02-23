import 'package:flutter/material.dart';
import 'package:trackbus/BillingDetails.dart';
import 'package:trackbus/MapPage.dart';
import 'package:trackbus/RouteDetails.dart';
import 'package:trackbus/driver.dart';
import 'package:trackbus/second_page.dart';

class Log extends StatelessWidget {
  const Log({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with blue background and black text
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Navigation Page',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[200], // Light body background
        child: Center(
          // Ensures the UI is scrollable on smaller screens
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavigationButton(context, 'Route Details', RouteDetailsApp()),
                  const SizedBox(height: 30),
                  _buildNavigationButton(context, 'Driver Details', driver()),
                  const SizedBox(height: 30),
                  _buildNavigationButton(context, 'Track Location', MapPage()),
                  const SizedBox(height: 30),
                  _buildNavigationButton(context, 'Student Details', second_page1()),
                  const SizedBox(height: 30),
                  _buildNavigationButton(context, 'Billing Details', DetailsTemplateApp()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build a uniform navigation button
  Widget _buildNavigationButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 60), // Same width & height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
