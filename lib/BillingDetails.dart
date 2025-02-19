import 'package:flutter/material.dart';

void main() => runApp(DetailsTemplateApp());

class DetailsTemplateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Details Template',
      debugShowCheckedModeBanner: false,
      home: DetailsScreen(),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  // Sample details stored in a Map
  final Map<String, String> details = {
    'Name': 'John Doe',
    'ID': '123456789',
    'Email': 'john.doe@example.com',
    'Contact': '+91 234 567 890',
    'Address': '123 Main Street, City, Country',
    'Due':'29/02/2025',
    'Pending Bills':'No',
    'Amount paid':'Rs 500',

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details Template')),
      body: SingleChildScrollView(
        // Allows scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // Display details in a column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}