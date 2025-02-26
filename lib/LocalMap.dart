import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:collection/collection.dart'; // optional if needed

/// Model for Bus Data.
class Bus {
  final String busNumber;
  LatLng location;

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
  // Polylines (for drawing route from user to selected bus).
  Set<Polyline> _polylines = {};

  // The currently selected bus (if any).
  Bus? _selectedBus;

  // Search query to filter bus markers.
  String _searchQuery = '';

  // Timer for simulating bus movement.
  Timer? _busMovementTimer;

  // Timer for periodic user location refresh.
  Timer? _userLocationTimer;

  // Average speed (in m/s) for travel time estimate (e.g., 30 km/h ≈ 8.33 m/s).
  static const double averageSpeed = 8.33;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _updateMarkers();
    // Simulate bus movement every 10 seconds.
    _busMovementTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _simulateBusMovement();
    });
  }

  @override
  void dispose() {
    _busMovementTimer?.cancel();
    _userLocationTimer?.cancel();
    super.dispose();
  }

  /// Check and request location permissions.
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

  /// Update markers based on bus data and search query.
  void _updateMarkers() {
    Set<Marker> newMarkers = {};

    // Add bus markers.
    for (Bus bus in buses) {
      if (_searchQuery.isEmpty || bus.busNumber.contains(_searchQuery)) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(bus.busNumber),
            position: bus.location,
            infoWindow: InfoWindow(
              title: 'Bus ${bus.busNumber}',
              snippet: _selectedBus?.busNumber == bus.busNumber ? 'Selected Bus' : '',
            ),
            onTap: () {
              setState(() {
                _selectedBus = bus;
              });
              _updatePolyline();
              _showBusDetails(bus);
            },
          ),
        );
      }
    }
    // Preserve the user marker if it already exists.
    Marker? userMarker = _markers.firstWhereOrNull((marker) => marker.markerId.value == 'user');
    if (userMarker != null && userMarker.position.latitude != 0) {
      newMarkers.add(userMarker);
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  /// Update the polyline connecting the user and the selected bus.
  void _updatePolyline() {
    Marker? userMarker = _markers.firstWhereOrNull((marker) => marker.markerId.value == 'user');
    if (_selectedBus == null || userMarker == null) {
      setState(() {
        _polylines.clear();
      });
      return;
    }
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [userMarker.position, _selectedBus!.location],
          color: Colors.blue,
          width: 5,
        )
      };
    });
  }

  /// Simulate bus movement by randomly jittering bus locations.
  void _simulateBusMovement() {
    final random = math.Random();
    setState(() {
      for (var bus in buses) {
        // Change latitude and longitude by a small random delta.
        double deltaLat = (random.nextDouble() - 0.5) / 100;
        double deltaLng = (random.nextDouble() - 0.5) / 100;
        bus.location = LatLng(
          bus.location.latitude + deltaLat,
          bus.location.longitude + deltaLng,
        );
      }
      _updateMarkers();
      _updatePolyline();
    });
  }

  /// Get the user's current location and add a marker for it.
  Future<void> _updateUserLocation() async {
    try {
      final userLocationData = await _location.getLocation();
      if (userLocationData.latitude != null && userLocationData.longitude != null) {
        LatLng userLocation = LatLng(userLocationData.latitude!, userLocationData.longitude!);
        setState(() {
          // Remove any existing user marker and add a new one.
          _markers.removeWhere((marker) => marker.markerId.value == 'user');
          _markers.add(
            Marker(
              markerId: const MarkerId('user'),
              position: userLocation,
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),
          );
        });
        _mapController.animateCamera(CameraUpdate.newLatLng(userLocation));
        _updatePolyline();
      }
    } catch (e) {
      debugPrint('Error getting user location: $e');
    }
  }

  /// Calculate distance (in meters) between two LatLng points using the Haversine formula.
  double _calculateDistance(LatLng pos1, LatLng pos2) {
    const double R = 6371000; // Earth's radius in meters.
    double dLat = (pos2.latitude - pos1.latitude) * math.pi / 180;
    double dLon = (pos2.longitude - pos1.longitude) * math.pi / 180;
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(pos1.latitude * math.pi / 180) * math.cos(pos2.latitude * math.pi / 180) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  /// Show bus details in a bottom sheet including distance, estimated time, and scheduled arrival.
  void _showBusDetails(Bus bus) {
    // Try to get the user's current location from the user marker.
    Marker? userMarker = _markers.firstWhereOrNull((marker) => marker.markerId.value == 'user');
    double distance = 0;
    String distanceStr = "Unknown";
    String timeStr = "Unknown";
    String scheduledArrival = "Unknown";

    if (userMarker != null && userMarker.position.latitude != 0) {
      distance = _calculateDistance(userMarker.position, bus.location);
      // Convert distance to kilometers.
      double distanceKm = distance / 1000;
      distanceStr = "${distanceKm.toStringAsFixed(2)} km";

      // Estimate time (in seconds) using average speed.
      double estimatedTimeSeconds = distance / averageSpeed;
      int minutes = (estimatedTimeSeconds / 60).round();
      timeStr = "$minutes min";

      // Calculate scheduled arrival time.
      DateTime arrivalTime = DateTime.now().add(Duration(seconds: estimatedTimeSeconds.round()));
      scheduledArrival = "${arrivalTime.hour.toString().padLeft(2, '0')}:${arrivalTime.minute.toString().padLeft(2, '0')}";
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bus Number: ${bus.busNumber}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Current Location: ${bus.location.latitude.toStringAsFixed(5)}, ${bus.location.longitude.toStringAsFixed(5)}'),
              const SizedBox(height: 8),
              Text('Distance to you: $distanceStr'),
              const SizedBox(height: 8),
              Text('Estimated time: $timeStr'),
              const SizedBox(height: 8),
              Text('Scheduled arrival: $scheduledArrival'),
            ],
          ),
        );
      },
    );
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
              polylines: _polylines,
              onMapCreated: (controller) {
                _mapController = controller;
                _updateUserLocation();
                _userLocationTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
                  _updateUserLocation();
                });
              },
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateUserLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
