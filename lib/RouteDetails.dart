
import 'package:flutter/material.dart';

void main() {
  runApp(RouteDetailsApp());
}

class RouteDetailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Details',
      debugShowCheckedModeBanner: false,
      home: RouteDetailsScreen(),
    );
  }
}

class RouteDetailsScreen extends StatelessWidget {
  // List of route details for three routes
  final List<Map<String, String>> routes = [
    {
      "Route Name": "Main Campus route",
      "Starting Point": "j.b.nagar",
      "Ending Point": "School Main Campus",
      "Stops": "j.b.nagar,station road,best depot,m.m.colleege corner",
      "Duration": "45 minutes",
    },
    {
      "Route Name": "Gandhi nagar route",
      "Starting Point": "East Gate",
      "Ending Point": "School south gate",
      "Stops": "s.p.road,j.k. apartment,main signal,r.k.theatre,govind niwas",
      "Duration": "30 minutes",
    },
    {
      "Route Name": "West Campus Route",
      "Starting Point": "West Gate",
      "Ending Point": "primary campus gate ",
      "Stops": "s.j.road,major mansion,reegal road,j.b.college,mehta school,bmc playground",
      "Duration": "40 minutes",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        // Use ListView.builder for a scrollable list of routes
        child: ListView.builder(
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final route = routes[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: route.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
            );
          },
        ),
      ),
    );
  }
}
