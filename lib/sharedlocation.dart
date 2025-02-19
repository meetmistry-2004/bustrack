import 'package:google_maps_flutter/google_maps_flutter.dart';

class SharedLocationData {
  static LatLng driverLocation = const LatLng(28.6353, 77.2250);
  static LatLng studentLocation = const LatLng(28.6375, 77.2275);

  // A flag to indicate if the route is active.
  static bool routeStarted = false;
  
  // A notification message to be shown in the notifications page.
  static String notification = "";
}
