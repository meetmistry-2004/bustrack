import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Full background color
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Back arrow color
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeading('🌟 Welcome to BusSafe – Your Ultimate Navigation Guide!'),
              buildText(
                  'Navigating  can be challenging, especially for new users. BusSafe is designed to make  navigation easier, smarter, and more convenient for students, faculty, and public.'),

              buildHeading('🎯 Our Mission'),
              buildText(
                  'Our goal is to help everyone save time by providing accurate directions, real-time updates, and essential information about the bus and area.'),

              buildHeading('🚀 Key Features'),
              buildBulletPoint('✅ Interactive Map – Easily find bus location,routes,bus details and more.'),
              buildBulletPoint('✅ Live Navigation – Step-by-step directions to any location .'),
              buildBulletPoint('✅ Notice Board – Stay updated with timings, changes in routes,bus details '),
              buildBulletPoint('✅ Transport Info – Find bus routes, timings, and  schedules.'),
              buildBulletPoint('✅ SOS & Emergency Contacts – Quick access to security, medical help, and administration.'),

              buildHeading('🌍 Why Choose BusSafe'),
              buildBulletPoint('📌 Designed for Students – Tailored for university and school environments.'),
              buildBulletPoint('📌 User-Friendly Interface – Simple, intuitive, and easy to use.'),
              buildBulletPoint('📌 Real-Time Updates – Get instant notifications on schedule changes,route details, and more.'),

              buildHeading('🤝 Join Us!'),
              buildText(
                  'We are constantly improving BusSafe to provide the best experience for students and parents. Your feedback and suggestions help us grow!'),

              buildText('📧 Contact us at busSafe@gmail.com'),
              buildText('🌐 Visit our website: www.bussafe.com'),
              buildText('🚀 Download  BusSafe and navigate like a pro!'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeading(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget buildText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
