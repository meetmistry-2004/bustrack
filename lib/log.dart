import 'package:flutter/material.dart';
import 'package:trackbus/MapPage.dart';
import 'package:trackbus/RouteDetails.dart';
import 'package:trackbus/driver.dart';
import 'package:trackbus/second_page.dart';
import 'package:trackbus/ProfilePage.dart';
import 'package:trackbus/Notifications.dart';
import 'package:trackbus/AboutUs.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 128, 219),
        title: const Text(
          'Navigation Page',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
            const Divider(),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.blue),
              title: const Text('Feedback', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPageUI()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}

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
    {"name": "John Doe", "code": "1234", "email": "johndoe@example.com", "dueDate": "2025-03-15", "feePaid": true, "totalFee": 10000},
    {"name": "Jane Smith", "code": "5678", "email": "janesmith@example.com", "dueDate": "2025-03-20", "feePaid": false, "totalFee": 12000},
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
      appBar: AppBar(title: const Text('Billing Details'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Enter 4-digit code', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkBilling,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
              child: const Text('OK', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 20),
            if (_studentRecord != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Name: ${_studentRecord!['name']}"),
                      Text("Email: ${_studentRecord!['email']}"),
                      Text("Due Date: ${_studentRecord!['dueDate']}"),
                      Text("Total Fee: ₹${_studentRecord!['totalFee']}"),
                      Text("Fee Paid: ${_studentRecord!['feePaid'] ? 'Yes' : 'No'}"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FeedbackPageUI extends StatefulWidget {
  const FeedbackPageUI({super.key});

  @override
  State<FeedbackPageUI> createState() => _FeedbackPageUIState();
}

class _FeedbackPageUIState extends State<FeedbackPageUI> {
  final _nameController = TextEditingController();
  final _feedbackController = TextEditingController();

  void _submit() async {
    final name = _nameController.text.trim();
    final feedback = _feedbackController.text.trim();

    if (name.isEmpty || feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mistrymeet72@gmail.com',
      query: Uri.encodeFull(
        'subject=Student Feedback from $name&body=$feedback',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open email app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Feedback'),
        backgroundColor: const Color.fromARGB(220, 52, 72, 252),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Your Feedback',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit Feedback'),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
