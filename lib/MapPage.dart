import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:trackbus/sharedlocation.dart';
import 'package:trackbus/Notifications.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Location _locationService = Location();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Location control.
  bool _locationEnabled = false;
  StreamSubscription<LocationData>? _locationSubscription;
  LatLng _currentPosition = const LatLng(0, 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _listenForDriverLocation();
    _listenForBusNotifications();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
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
        SharedLocationData.studentLocation = _currentPosition;
        _locationEnabled = true;
      });
      _dbRef.child('locations/student').set({
        'latitude': _currentPosition.latitude,
        'longitude': _currentPosition.longitude,
      });
      _dbRef.child('locations/student').onDisconnect().remove();
    }
    _locationSubscription = _locationService.onLocationChanged.listen((locData) {
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locData.latitude!, locData.longitude!);
          SharedLocationData.studentLocation = _currentPosition;
        });
        _dbRef.child('locations/student').set({
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
        });
        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        }
      }
    });
  }
  
  Future<void> _disableLocation() async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    setState(() {
      _locationEnabled = false;
      _currentPosition = const LatLng(0, 0);
      SharedLocationData.studentLocation = const LatLng(0, 0);
    });
    _dbRef.child('locations/student').remove();
  }
  
  void _listenForDriverLocation() {
    _dbRef.child('locations/driver').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value == null) {
        setState(() {
          SharedLocationData.isDriverLocationEnabled = false;
        });
      } else if (value is Map) {
        if (value.containsKey('latitude') && value.containsKey('longitude')) {
          double lat = (value['latitude'] as num).toDouble();
          double lng = (value['longitude'] as num).toDouble();
          setState(() {
            SharedLocationData.driverLocation = LatLng(lat, lng);
            SharedLocationData.isDriverLocationEnabled = true;
          });
        } else {
          setState(() {
            SharedLocationData.isDriverLocationEnabled = false;
          });
        }
      }
    });
  }
  
  void _listenForBusNotifications() {
    _dbRef.child('busNotifications').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null && data.containsKey('message')) {
        String msg = data['message'];
        setState(() {
          SharedLocationData.notifications.add(msg);
        });
      }
    });
  }
  
  @override
  void dispose() {
    _disableLocation();
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    if (_locationEnabled &&
        _currentPosition.latitude != 0 &&
        _currentPosition.longitude != 0) {
      markers.add(
        Marker(
          markerId: const MarkerId('student'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      if (SharedLocationData.isDriverLocationEnabled) {
        markers.add(
          Marker(
            markerId: const MarkerId('driver'),
            position: SharedLocationData.driverLocation,
            infoWindow: const InfoWindow(title: 'Driver (Bus) Location'),
          ),
        );
      }
    }
    LatLng center = _locationEnabled ? _currentPosition : const LatLng(0, 0);
    String latestNotification = SharedLocationData.notifications.isNotEmpty
        ? SharedLocationData.notifications.last
        : "";
    
    Widget content = _locationEnabled
        ? GoogleMap(
            initialCameraPosition: CameraPosition(target: center, zoom: 14),
            markers: markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          )
        : Center(
            child: Text(
              "Please enable location to see your and the driver's current location.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          );
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Student Map",
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
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
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
