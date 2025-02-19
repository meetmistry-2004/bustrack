import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trackbus/sharedlocation.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Location _locationService = Location();

  // Current student location (initialized from shared data)
  LatLng _currentPosition = SharedLocationData.studentLocation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndListen();

    // Refresh UI every second to update the driver's marker if it changes.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

    // Listen for location updates and update student location.
    _locationService.onLocationChanged.listen((LocationData locData) {
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locData.latitude!, locData.longitude!);
          // Update the shared student location.
          SharedLocationData.studentLocation = _currentPosition;
        });
        if (_mapController != null) {
          _mapController!.animateCamera(
            CameraUpdate.newLatLng(_currentPosition),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the midpoint between the driver's and student's locations.
    LatLng center = LatLng(
      (SharedLocationData.driverLocation.latitude + SharedLocationData.studentLocation.latitude) / 2,
      (SharedLocationData.driverLocation.longitude + SharedLocationData.studentLocation.longitude) / 2,
    );

    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: SharedLocationData.driverLocation,
        infoWindow: const InfoWindow(title: 'Driver (Bus) Location'),
      ),
      Marker(
        markerId: const MarkerId('student'),
        position: SharedLocationData.studentLocation,
        infoWindow: const InfoWindow(title: 'Your Location'),
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
          "Student Map",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: center, zoom: 14),
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
