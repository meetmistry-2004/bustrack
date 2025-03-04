import 'package:flutter/material.dart';
import 'package:trackbus/MapPage.dart';
import 'package:trackbus/RouteDetails.dart';
import 'package:trackbus/driver.dart';
import 'package:trackbus/second_page.dart';
import 'package:trackbus/ProfilePage.dart';
import 'package:trackbus/Notifications.dart';
import 'package:trackbus/AboutUs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackBus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Log(),
    );
  }
}

class Log extends StatelessWidget {
  const Log({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with modern styling.
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Navigation Page',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // Enhanced Drawer with a header for better UX.
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Profile', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title:
                  const Text('Notifications', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('About Us', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationButton(
                    context, 'Route Details', RouteDetailsApp()),
                const SizedBox(height: 30),
                _buildNavigationButton(context, 'Driver Details', driver()),
                const SizedBox(height: 30),
                _buildNavigationButton(context, 'Track Location', MapPage()),
                const SizedBox(height: 30),
                _buildNavigationButton(context, 'Student Details', second_page1()),
                const SizedBox(height: 30),
                // Updated Billing Details button.
                _buildNavigationButton(
                    context, 'Billing Details', const BillingDetailsPage()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 4,
        minimumSize: const Size(double.infinity, 60),
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

// ---------------------------
// Billing Details Page
// ---------------------------
class BillingDetailsPage extends StatefulWidget {
  const BillingDetailsPage({super.key});

  @override
  _BillingDetailsPageState createState() => _BillingDetailsPageState();
}

class _BillingDetailsPageState extends State<BillingDetailsPage> {
  final TextEditingController _codeController = TextEditingController();
  Map<String, dynamic>? _studentRecord;
  String? _errorMessage;

  final List<Map<String, dynamic>> dummyStudents = [
    {
      "name": "John Doe",
      "code": "1234",
      "email": "johndoe@example.com",
      "dueDate": "2025-03-15",
      "feePaid": true,
      "totalFee": 10000
    },
    {
      "name": "Jane Smith",
      "code": "5678",
      "email": "janesmith@example.com",
      "dueDate": "2025-03-20",
      "feePaid": false,
      "totalFee": 12000
    },
    {
      "name": "Michael Brown",
      "code": "9012",
      "email": "michaelbrown@example.com",
      "dueDate": "2025-04-01",
      "feePaid": true,
      "totalFee": 9000
    },
    {
      "name": "Emily Davis",
      "code": "3456",
      "email": "emilydavis@example.com",
      "dueDate": "2025-03-28",
      "feePaid": false,
      "totalFee": 11000
    },
    {
      "name": "Robert Wilson",
      "code": "7890",
      "email": "robertwilson@example.com",
      "dueDate": "2025-04-05",
      "feePaid": true,
      "totalFee": 10000
    },
    {
      "name": "Linda Johnson",
      "code": "2345",
      "email": "lindajohnson@example.com",
      "dueDate": "2025-03-30",
      "feePaid": false,
      "totalFee": 12000
    },
  ];

  void _checkBilling() {
    final code = _codeController.text.trim();
    if (code.length != 4 || int.tryParse(code) == null) {
      setState(() {
        _errorMessage = 'Please enter a valid 4-digit number.';
        _studentRecord = null;
      });
      return;
    }
    final record = dummyStudents.firstWhere(
      (student) => student["code"] == code,
      orElse: () => {},
    );
    if (record.isEmpty) {
      setState(() {
        _errorMessage = 'No record found for code $code';
        _studentRecord = null;
      });
    } else {
      setState(() {
        _errorMessage = null;
        _studentRecord = record;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Details'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Enter 4-digit code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkBilling,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            if (_studentRecord != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${_studentRecord!["name"]}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('4-digit Code: ${_studentRecord!["code"]}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Email: ${_studentRecord!["email"]}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Due Date: ${_studentRecord!["dueDate"]}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Fee Status: ${_studentRecord!["feePaid"] ? "Paid" : "Not Paid"}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Total Fee: \$${_studentRecord!["totalFee"]}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
