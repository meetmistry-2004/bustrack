// sharedlocation.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedLocationData {
  static LatLng driverLocation = LatLng(0, 0);
  static LatLng studentLocation = LatLng(0, 0);
  static bool routeStarted = false;
  static List<String> notifications = [];
  static bool isDriverLocationEnabled = false; // new flag
}
