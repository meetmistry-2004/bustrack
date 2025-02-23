// sharedlocation.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedLocationData {
  // Private fields to store the locations.
  static LatLng _driverLocation = LatLng(0, 0);
  static LatLng _studentLocation = LatLng(0, 0);

  // Getter and setter for driver's location.
  static LatLng get driverLocation => _driverLocation;
  static set driverLocation(LatLng newLocation) {
    _driverLocation = newLocation;
  }

  // Getter and setter for student's location.
  static LatLng get studentLocation => _studentLocation;
  static set studentLocation(LatLng newLocation) {
    _studentLocation = newLocation;
  }

  // Indicates if the route has started.
  static bool routeStarted = false;

  // Stores notification messages.
  static List<String> notifications = [];

  // Flag to indicate whether the driver's location is enabled.
  static bool isDriverLocationEnabled = false;

  // Helper getter: Returns true if the student location is not at the default (0,0).
  static bool get isStudentLocationValid =>
      _studentLocation.latitude != 0.0 || _studentLocation.longitude != 0.0;
}
