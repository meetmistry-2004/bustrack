import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
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
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool _isRouteActive = false;
  Timer? _lateTimer;
  bool _busArrivedNotified = false;
  String _notificationMessage = "";
  
  // Location control.
  bool _locationEnabled = false;
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng _currentPosition = const LatLng(0, 0);
  
  // Threshold for arrival.
  final double arrivalThreshold = 50.0;
  // Expected travel duration.
  final Duration expectedTravelDuration = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _listenForStudentLocation();
  }
  
  Future<void> _initializeLocation() async {
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
    final locData = await _locationService.getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      setState(() {
        _currentPosition = LatLng(locData.latitude!, locData.longitude!);
        SharedLocationData.driverLocation = _currentPosition;
        _locationEnabled = true;
      });
      _dbRef.child('locations/driver').set({
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
      });
      _dbRef.child('locations/driver').onDisconnect().remove();
    }
    _locationSubscription = _locationService.onLocationChanged.listen((locData) {
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locData.latitude!, locData.longitude!);
          SharedLocationData.driverLocation = _currentPosition;
        });
        _dbRef.child('locations/driver').set({
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
        });
        if (_isRouteActive && _mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        }
        _checkArrival();
      }
    });
  }
  
  Future<void> _disableLocation() async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    setState(() {
      _locationEnabled = false;
      _currentPosition = const LatLng(0, 0);
      SharedLocationData.driverLocation = const LatLng(0, 0);
    });
    _dbRef.child('locations/driver').remove();
  }
  
  void _listenForStudentLocation() {
    _dbRef.child('locations/student').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        LatLng studentLoc = LatLng(
          (data['latitude'] as num).toDouble(),
          (data['longitude'] as num).toDouble(),
        );
        setState(() {
          SharedLocationData.studentLocation = studentLoc;
        });
      }
    });
  }
  
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
        _dbRef.child('busNotifications').push().set({
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }
  }
  
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371000;
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = math.sin(dLat/2)*math.sin(dLat/2) +
               math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
               math.sin(dLon/2)*math.sin(dLon/2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a));
    return R * c;
  }
  
  double _deg2rad(double deg) => deg * (math.pi/180);
  
  void _startRoute() {
    setState(() {
      _isRouteActive = true;
      SharedLocationData.routeStarted = true;
      _busArrivedNotified = false;
      _notificationMessage = "Route has started";
    });
    // Show notification locally.
    NotificationService().showNotification("Route Start", "Route has started");
    SharedLocationData.notifications.add("Route has started");
    // Push the notification to Firebase.
    _dbRef.child('busNotifications').push().set({
      'message': "Route has started",
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    _lateTimer?.cancel();
    _lateTimer = Timer(expectedTravelDuration, () {
      if (!_busArrivedNotified) {
        String message = "Bus is running late";
        SharedLocationData.notifications.add(message);
        NotificationService().showNotification("Delay", message);
        setState(() {
          _notificationMessage = message;
        });
        _dbRef.child('busNotifications').push().set({
          'message': message,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }
  
  void _endRoute() {
    setState(() {
      _isRouteActive = false;
      SharedLocationData.routeStarted = false;
      _notificationMessage = "Route has ended";
    });
    NotificationService().showNotification("Route End", "Route has ended");
    SharedLocationData.notifications.add("Route has ended");
    _dbRef.child('busNotifications').push().set({
      'message': "Route has ended",
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    _lateTimer?.cancel();
    Navigator.pop(context);
  }
  
  @override
  void dispose() {
    _disableLocation();
    _lateTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Optionally display the latest notification in the AppBar.
    String latestNotification = _notificationMessage; // or use SharedLocationData.notifications.last if available.
    
    // Center map between driver and student if student location is valid.
    LatLng center = SharedLocationData.isStudentLocationValid
        ? LatLng(
            (SharedLocationData.driverLocation.latitude +
             SharedLocationData.studentLocation.latitude) / 2,
            (SharedLocationData.driverLocation.longitude +
             SharedLocationData.studentLocation.longitude) / 2,
          )
        : _currentPosition;
    
    Set<Marker> markers = {};
    if (_locationEnabled &&
        _currentPosition.latitude != 0 &&
        _currentPosition.longitude != 0) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Driver Location'),
        ),
      );
    }
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Driver Map",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            if (latestNotification.isNotEmpty)
              Text(
                latestNotification,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
          ],
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          Row(
            children: [
              const Text("Location", style: TextStyle(color: Colors.black)),
              Switch(
                value: _locationEnabled,
                onChanged: (val) {
                  if (val) {
                    _initializeLocation();
                  } else {
                    _disableLocation();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
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
