import 'package:geolocator/geolocator.dart';

class GpsService {
  static Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return false;
    }

    // Permissions are granted
    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      // Handle errors here, e.g., log the error or show a message to the user
      print('Error getting current location: $e');
      return null;
    }
  }

// Other location-related methods can be added here, such as:

// - Getting the distance between two points:
//   static Future<double> getDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) async {
//     return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
//   }

// - Getting the address from coordinates (geocoding)
// - Getting the coordinates from an address (reverse geocoding)
// - Listening for location updates (using streams)
}