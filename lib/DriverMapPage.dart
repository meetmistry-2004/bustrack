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
  String _notificationMessage = "";

  // Current driver location (initialized from shared data)
  LatLng _currentPosition = SharedLocationData.driverLocation;

  // Threshold (in meters) to consider the bus has reached the student.
  final double arrivalThreshold = 50.0;
  // Expected travel duration: 5 minutes.
  final Duration expectedTravelDuration = const Duration(minutes: 5);

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

    // Listen for location updates.
    _locationService.onLocationChanged.listen((LocationData locData) {
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locData.latitude!, locData.longitude!);
          // Update shared driver location.
          SharedLocationData.driverLocation = _currentPosition;
        });
        if (_isRouteActive && _mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        }
        _checkArrival();
      }
    });
  }

  // Check if the bus has reached the student.
  void _checkArrival() {
    if (SharedLocationData.isStudentLocationValid) {
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
        setState(() {
          _notificationMessage = message;
        });
      }
    }
  }

  // Haversine formula.
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000; // Earth's radius in meters.
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  // When Start Route is pressed.
  void _startRoute() {
    setState(() {
      _isRouteActive = true;
      SharedLocationData.routeStarted = true;
      _busArrivedNotified = false;
      _notificationMessage = "";
    });
    // Immediately send a notification that the route has started.
    NotificationService().showNotification("Route Start", "Route has started");
    SharedLocationData.notifications.add("Route has started");

    // Schedule a timer for 5 minutes to check if the bus is still at the location.
    _lateTimer?.cancel();
    _lateTimer = Timer(expectedTravelDuration, () {
      if (!_busArrivedNotified) {
        String message = "Bus is running late";
        SharedLocationData.notifications.add(message);
        NotificationService().showNotification("Delay", message);
        setState(() {
          _notificationMessage = message;
        });
      }
    });
  }

  // When End Route is pressed.
  void _endRoute() {
    setState(() {
      _isRouteActive = false;
      SharedLocationData.routeStarted = false;
      _notificationMessage = "Route has ended";
    });
    NotificationService().showNotification("Route End", "Route has ended");
    SharedLocationData.notifications.add("Route has ended");
    _lateTimer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Center the map between driver and student.
    LatLng center = LatLng(
      (SharedLocationData.driverLocation.latitude +
              SharedLocationData.studentLocation.latitude) /
          2,
      (SharedLocationData.driverLocation.longitude +
              SharedLocationData.studentLocation.longitude) /
          2,
    );

    // Build markers.
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: _currentPosition,
        infoWindow: const InfoWindow(title: 'Driver Location'),
      ),
    };
    if (SharedLocationData.isStudentLocationValid) {
      markers.add(
        Marker(
          markerId: const MarkerId('student'),
          position: SharedLocationData.studentLocation,
          infoWindow: const InfoWindow(title: 'Student Location'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Map",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: _notificationMessage.isNotEmpty
              ? Container(
                  width: double.infinity,
                  color: Colors.yellow,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _notificationMessage,
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Only two buttons: Start Route and End Route.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _startRoute,
                child: const Text("Start Route"),
              ),
              ElevatedButton(
                onPressed: _endRoute,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("End Route"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Map view (only shown when route is active).
          Expanded(
            child: _isRouteActive
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(target: center, zoom: 14),
                    markers: markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  )
                : Center(
                    child: Text(
                      "Route not active",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
