// DriverMapPage.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trackbus/sharedlocation.dart';
import 'package:trackbus/Notification_services.dart';

class DriverMapPage extends StatefulWidget {
  const DriverMapPage({Key? key}) : super(key: key);

  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  GoogleMapController? _mapController;
  final Location _locationService = Location();
  bool _isRouteActive = false;
  Timer? _lateTimer;
  bool _busArrivedNotified = false;

  // Current driver location (initialized from shared data)
  LatLng _currentPosition = SharedLocationData.driverLocation;

  // Define a threshold (in meters) to consider the bus has arrived.
  final double arrivalThreshold = 50.0;
  
  // For demonstration, assume the expected travel duration is 30 seconds.
  final Duration expectedTravelDuration = const Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndListen();
  }

  @override
  void dispose() {
    _lateTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermissionAndListen() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Listen for location updates and update driver location.
    _locationService.onLocationChanged.listen((LocationData locData) {
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locData.latitude!, locData.longitude!);
          // Update the shared driver location.
          SharedLocationData.driverLocation = _currentPosition;
        });
        if (_isRouteActive && _mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(_currentPosition),
          );
        }
        _checkArrival();
      }
    });
  }

  // Check if bus has reached the student's location.
  void _checkArrival() {
    double distance = _calculateDistance(
      _currentPosition.latitude,
      _currentPosition.longitude,
      SharedLocationData.studentLocation.latitude,
      SharedLocationData.studentLocation.longitude,
    );
    if (distance <= arrivalThreshold && !_busArrivedNotified) {
      _busArrivedNotified = true;
      String message = "Bus has reached your location";
      SharedLocationData.notifications.add(message);
      NotificationService().showNotification("Arrival", message);
    }
  }

  // Haversine formula to calculate the distance (in meters) between two points.
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth's radius in meters
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) {
    return deg * (math.pi / 180);
  }

  void _startRoute() {
    setState(() {
      _isRouteActive = true;
      SharedLocationData.routeStarted = true;
      String message = "Route has started";
      SharedLocationData.notifications.add(message);
      NotificationService().showNotification("Route Start", message);
      _busArrivedNotified = false; // reset for this journey
    });
    // Schedule a timer to check for delay.
    _lateTimer?.cancel();
    _lateTimer = Timer(expectedTravelDuration, () {
      if (!_busArrivedNotified) {
        String message = "Bus is running late";
        SharedLocationData.notifications.add(message);
        NotificationService().showNotification("Delay", message);
      }
    });
  }

  void _endRoute() {
    setState(() {
      _isRouteActive = false;
      SharedLocationData.routeStarted = false;
      String message = "Route has ended";
      SharedLocationData.notifications.add(message);
      NotificationService().showNotification("Route End", message);
    });
    _lateTimer?.cancel();
    // Close the map page and return to the previous screen.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the center as the midpoint between driver and student.
    LatLng center = LatLng(
      (SharedLocationData.driverLocation.latitude +
              SharedLocationData.studentLocation.latitude) /
          2,
      (SharedLocationData.driverLocation.longitude +
              SharedLocationData.studentLocation.longitude) /
          2,
    );

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: SharedLocationData.driverLocation,
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
      Marker(
        markerId: const MarkerId('student'),
        position: SharedLocationData.studentLocation,
        infoWindow: const InfoWindow(title: 'Student Location'),
      ),
    };

    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          SharedLocationData.driverLocation,
          SharedLocationData.studentLocation,
        ],
        color: Colors.blue,
        width: 5,
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Map",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Buttons for controlling route tracking.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _startRoute,
                child: const Text("Start Route"),
              ),
              ElevatedButton(
                onPressed: _endRoute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("End Route"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Show the map only when route is active.
          Expanded(
            child: _isRouteActive
                ? GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: center, zoom: 14),
                    markers: markers,
                    polylines: polylines,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  )
                : Center(
                    child: Text(
                      "Route not active",
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
