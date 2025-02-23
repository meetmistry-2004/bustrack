import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Model for Bus Data.
class Bus {
  final String busNumber;
  final LatLng location;

  Bus({required this.busNumber, required this.location});
}

class BusTrackingMap extends StatefulWidget {
  const BusTrackingMap({Key? key}) : super(key: key);

  @override
  _BusTrackingMapState createState() => _BusTrackingMapState();
}

class _BusTrackingMapState extends State<BusTrackingMap> {
  late GoogleMapController _mapController;
  final Location _location = Location();
  bool _locationPermissionGranted = false;

  // Set the initial camera position to Mumbai.
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(19.0760, 72.8777),
    zoom: 12,
  );

  // Sample bus data (all within Mumbai).
  final List<Bus> buses = [
    Bus(busNumber: '101', location: const LatLng(19.075, 72.877)),
    Bus(busNumber: '102', location: const LatLng(19.08, 72.88)),
    Bus(busNumber: '103', location: const LatLng(19.07, 72.87)),
    Bus(busNumber: '104', location: const LatLng(19.09, 72.89)),
    Bus(busNumber: '105', location: const LatLng(19.076, 72.87)),
  ];

  // Markers to display on the map.
  Set<Marker> _markers = {};

  // Search query to filter bus markers.
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _updateMarkers();
  }

  // Check and request location permissions.
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return;
    }
    setState(() {
      _locationPermissionGranted = true;
    });
  }

  // Update markers based on the bus data and the search query.
  void _updateMarkers() {
    Set<Marker> newMarkers = {};

    // Add bus markers.
    for (Bus bus in buses) {
      if (_searchQuery.isEmpty || bus.busNumber.contains(_searchQuery)) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(bus.busNumber),
            position: bus.location,
            infoWindow: InfoWindow(title: 'Bus ${bus.busNumber}'),
          ),
        );
      }
    }
    // Preserve the user marker if it already exists.
    final existingUserMarker = _markers.firstWhere(
      (marker) => marker.markerId.value == 'user',
      orElse: () => Marker(markerId: const MarkerId('user'), position: const LatLng(0, 0)),
    );
    if (existingUserMarker.markerId.value == 'user' &&
        existingUserMarker.position.latitude != 0) {
      newMarkers.add(existingUserMarker);
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  // Get the user's current location and add a marker for it.
  Future<void> _updateUserLocation() async {
    try {
      final userLocationData = await _location.getLocation();
      if (userLocationData.latitude != null && userLocationData.longitude != null) {
        LatLng userLocation = LatLng(userLocationData.latitude!, userLocationData.longitude!);
        setState(() {
          // Add or update the user marker (blue marker).
          _markers.add(
            Marker(
              markerId: const MarkerId('user'),
              position: userLocation,
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          );
        });
        // Optionally, animate camera to the user's location.
        _mapController.animateCamera(CameraUpdate.newLatLng(userLocation));
      }
    } catch (e) {
      debugPrint('Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Bus Tracking (Mumbai)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by Bus Number',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _updateMarkers();
              },
            ),
          ),
        ),
      ),
      body: _locationPermissionGranted
          ? GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
                // Once the map is created, update the user's location.
                _updateUserLocation();
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
