import 'package:flutter/material.dart';
import 'package:trackbus/DriverMapPage.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A base style for all buttons to keep them consistent
    final ButtonStyle baseButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Button background color
      minimumSize: const Size(double.infinity, 50), // Full width, 50 px height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Slightly rounded corners
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home Page'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverMapPage()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Start Navigation',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentAttendanceScreen()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Student Check-In/Check-Out',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationScreen()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Route Navigation',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyScreen()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Emergency',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Profile/Settings',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
                );
              },
              style: baseButtonStyle,
              child: const Text(
                'Attendance Summary/History',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteScreen extends StatefulWidget {
  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  bool isRouteActive = false;
  DateTime? routeStartTime;

  void toggleRoute() {
    setState(() {
      if (isRouteActive) {
        // End route
        isRouteActive = false;
      } else {
        // Start route
        isRouteActive = true;
        routeStartTime = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String statusText = isRouteActive && routeStartTime != null
        ? 'Route started at ${routeStartTime!.toLocal().toString().substring(0, 16)}'
        : 'No active route';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Management'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              statusText,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: toggleRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                isRouteActive ? 'End Route' : 'Start Route',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentAttendanceScreen extends StatefulWidget {
  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  List<Map<String, dynamic>> students = [
    {'name': 'Alice Johnson', 'checkedIn': false},
    {'name': 'Bob Smith', 'checkedIn': false},
    {'name': 'Charlie Brown', 'checkedIn': false},
    {'name': 'Daisy Miller', 'checkedIn': false},
  ];

  void toggleAttendance(int index) {
    setState(() {
      students[index]['checkedIn'] = !students[index]['checkedIn'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle attendanceButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      minimumSize: const Size(120, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Check-In/Check-Out'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          bool checkedIn = students[index]['checkedIn'];
          return ListTile(
            title: Text(students[index]['name']),
            trailing: ElevatedButton(
              onPressed: () => toggleAttendance(index),
              style: attendanceButtonStyle.copyWith(
                backgroundColor: MaterialStateProperty.all(
                  checkedIn ? Colors.orange : Colors.green,
                  ),
                ),
                child: Text(
                  checkedIn ? 'Check-Out' : 'Check-In',
                  style: const TextStyle(color: Colors.black),
                ),
              ),

          );
        },
      ),
    );
  }
}

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this Container with an actual map widget when integrating a map package.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Navigation'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 300,
          color: Colors.grey[300],
          child: const Center(
            child: Text(
              'Map Placeholder',
              style: TextStyle(fontSize: 24, color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyScreen extends StatelessWidget {
  void triggerEmergency(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert'),
        content: const Text(
            'Emergency has been triggered! Please contact the school admin immediately.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle emergencyButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      minimumSize: const Size(200, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => triggerEmergency(context),
          style: emergencyButtonStyle,
          child: const Text(
            'Trigger Emergency',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController =
      TextEditingController(text: 'John Doe');
  TextEditingController phoneController =
      TextEditingController(text: '+1 234 567 890');

  void saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle profileButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      minimumSize: const Size(200, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile/Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              style: profileButtonStyle,
              child: const Text(
                'Save Profile',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> logs = [
    {'date': '2025-02-18', 'details': 'All students present'},
    {'date': '2025-02-17', 'details': '1 student absent'},
    {'date': '2025-02-16', 'details': '2 students absent'},
  ];

  AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Summary/History'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(logs[index]['date']!),
            subtitle: Text(logs[index]['details']!),
          );
        },
      ),
    );
  }
}
