import 'package:flutter/material.dart';
import 'package:trackbus/DriverMapPage.dart';
import 'package:url_launcher/url_launcher.dart'; // For making phone calls

// Global attendance logs list to store attendance records across screens.
List<Map<String, String>> attendanceLogs = [];

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
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  // List with 10 students, each having separate toggles for check-in and check-out.
  List<Map<String, dynamic>> students = [
    {'name': 'Alice Johnson', 'checkIn': false, 'checkOut': false},
    {'name': 'Bob Smith', 'checkIn': false, 'checkOut': false},
    {'name': 'Charlie Brown', 'checkIn': false, 'checkOut': false},
    {'name': 'Daisy Miller', 'checkIn': false, 'checkOut': false},
    {'name': 'Ethan Davis', 'checkIn': false, 'checkOut': false},
    {'name': 'Fiona Garcia', 'checkIn': false, 'checkOut': false},
    {'name': 'George Harris', 'checkIn': false, 'checkOut': false},
    {'name': 'Hannah Lee', 'checkIn': false, 'checkOut': false},
    {'name': 'Ian Martinez', 'checkIn': false, 'checkOut': false},
    {'name': 'Julia Nguyen', 'checkIn': false, 'checkOut': false},
  ];

  @override
  Widget build(BuildContext context) {
    final ButtonStyle saveButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      minimumSize: const Size(double.infinity, 50),
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
        itemCount: students.length + 1,
        itemBuilder: (context, index) {
          if (index < students.length) {
            var student = students[index];
            return ListTile(
              title: Text(student['name']),
              subtitle: Row(
                children: [
                  // Check-In switch
                  Row(
                    children: [
                      const Text("Check-In"),
                      Switch(
                        value: student['checkIn'],
                        onChanged: (value) {
                          setState(() {
                            student['checkIn'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Check-Out switch
                  Row(
                    children: [
                      const Text("Check-Out"),
                      Switch(
                        value: student['checkOut'],
                        onChanged: (value) {
                          setState(() {
                            student['checkOut'] = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            // Save Attendance button at the end of the list
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Mark student as present if either switch is enabled, otherwise absent.
                  int presentCount = students.where((s) => (s['checkIn'] == true || s['checkOut'] == true)).length;
                  int absentCount = students.length - presentCount;

                  String dateTime = DateTime.now().toLocal().toString().substring(0, 16); // e.g., "2025-02-28 14:30"
                  String details = '$presentCount present, $absentCount absent';

                  attendanceLogs.add({'date': dateTime, 'details': details});

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceHistoryScreen()),
                  );
                },
                style: saveButtonStyle,
                child: const Text(
                  'Save Attendance',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }
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
  Future<void> triggerEmergency(BuildContext context) async {
    // Show a confirmation dialog before triggering emergency
    bool confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Emergency'),
            content: const Text(
                'Are you sure you want to trigger an emergency alert? This will call the school admin immediately.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      // Use Indian phone number format
      final Uri launchUri = Uri(scheme: 'tel', path: '+919834562812');
      debugPrint('Attempting to launch: ${launchUri.toString()}');
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone call.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle emergencyButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red, // Red indicates urgency.
      minimumSize: const Size(200, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => triggerEmergency(context),
          style: emergencyButtonStyle,
          child: const Text(
            'Trigger Emergency',
            style: TextStyle(color: Colors.white),
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
  TextEditingController nameController = TextEditingController(text: 'John Doe');
  TextEditingController phoneController = TextEditingController(text: '+91 9834562812');

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
  AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Displays the list of attendance logs saved earlier.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Summary/History'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: attendanceLogs.length,
        itemBuilder: (context, index) {
          final log = attendanceLogs[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(log['date'] ?? ''),
            subtitle: Text(log['details'] ?? ''),
          );
        },
      ),
    );
  }
}
