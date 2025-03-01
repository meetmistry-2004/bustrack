import 'package:flutter/material.dart';
import 'package:trackbus/Driverloginpage.dart';
import 'package:trackbus/LoginPage.dart';
import 'package:trackbus/AboutUs.dart';
import 'package:trackbus/LocalMap.dart';
import 'package:trackbus/Notifications.dart';
import 'package:trackbus/ProfilePage.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;

  void _navigationBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bus_Safe",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
  child: Column(
    children: [
      ListTile(
        leading: Icon(Icons.person, color: Colors.blue),
        title: Text('Profile', style: TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfilePage()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.notifications, color: Colors.blue),
        title: Text('Notifications', style: TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationsPage()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.info, color: Colors.blue),
        title: Text('About Us', style: TextStyle(fontSize: 16)),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AboutUsPage()));
        },
      ),
    ],
  ),
),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              title: "Login as Student/Parent",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            const SizedBox(height: 40),
            CustomButton(
              title: "Login as Driver",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  DriverLoginPage()),
                );
              },
            ),
            const SizedBox(height: 40),
            CustomButton(
              title: "General Navigation Map/Routes",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BusTrackingMap()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomButton({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
