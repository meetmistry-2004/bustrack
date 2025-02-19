
import 'package:flutter/material.dart';
import 'package:trackbus/student.dart';

void main() {
  runApp(second_page1());

}

class second_page1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(title: Text('Student Details')),
        body: Padding(
          padding: EdgeInsets.all(16), // Add padding around the column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Expand boxes to full width
            children: [
              buildBorderedBox('Name:', 'Swapnil Belkar'),
              buildBorderedBox('Roll no:', '84'),
              buildBorderedBox('Division:', 'B'),
              buildBorderedBox('Bus number', 'MH 00 78 8055')
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBorderedBox(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
