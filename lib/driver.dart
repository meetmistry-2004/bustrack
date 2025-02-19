
import 'package:flutter/material.dart';
import 'package:trackbus/student.dart';

void main() {
  runApp(driver());
}

class driver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      home: Scaffold(
        appBar: AppBar(title: Text('Student Details')),
        body: Padding(
          padding: EdgeInsets.all(16),
          // Wrap the Column in a SingleChildScrollView to make it scrollable
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Expand boxes to full width
              children: [
                buildBorderedBox('Driver Name:', 'joe clark'),
                buildBorderedBox('Driver id:', '07'),
                buildBorderedBox('Driver contact', '+91 897 773 7655'),
                buildBorderedBox('Bus number', 'MH 00 78 8055'),
                buildBorderedBox('Driver Name', 'zoe major'),
                buildBorderedBox('Driver id', '05'),
                buildBorderedBox('Driver contact', '+91 897 869 8922'),
                buildBorderedBox('Bus Number', 'MH 00 98 8976'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBorderedBox(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), // Spacing between boxes
      padding: EdgeInsets.all(10), // Padding inside the box
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        border: Border.all(color: Colors.blue, width: 2), // Border color and width
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
        ], // Shadow effect
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to left inside box
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
