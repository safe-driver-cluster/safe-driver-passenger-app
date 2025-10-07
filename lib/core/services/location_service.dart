import 'package:geolocator/geolocator.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await checkLocationPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException();
      }

      // Check and request permission
      LocationPermission permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedException();
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      return _currentPosition;
    } catch (e) {
      throw LocationException('Failed to get current location: $e');
    }
  }

  // Get location stream for real-time tracking
  Stream<Position> getLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Minimum distance (in meters) to trigger update
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // Calculate distance between two positions
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calculate bearing between two positions
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if user is within a certain distance of a location
  bool isWithinDistance(
    Position userPosition,
    double targetLatitude,
    double targetLongitude,
    double radiusInMeters,
  ) {
    double distance = calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      targetLatitude,
      targetLongitude,
    );
    return distance <= radiusInMeters;
  }

  // Get location updates with error handling
  Stream<LocationUpdate> getLocationUpdatesWithErrorHandling() async* {
    try {
      await for (Position position in getLocationStream()) {
        yield LocationUpdate.success(position);
      }
    } catch (e) {
      yield LocationUpdate.error(e.toString());
    }
  }

  // Convert position to a readable address (requires geocoding package)
  Future<String?> getAddressFromPosition(Position position) async {
    try {
      // This would require the geocoding package
      // For now, return a formatted string with coordinates
      return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    } catch (e) {
      return null;
    }
  }

  // Enable background location tracking
  Future<void> enableBackgroundLocationTracking() async {
    // This would require platform-specific implementation
    // For now, just ensure permissions are granted
    await requestLocationPermission();
  }

  // Disable background location tracking
  Future<void> disableBackgroundLocationTracking() async {
    // Platform-specific implementation would go here
  }
}

// Helper classes for location updates
class LocationUpdate {
  final Position? position;
  final String? error;
  final bool isSuccess;

  LocationUpdate.success(this.position)
      : error = null,
        isSuccess = true;

  LocationUpdate.error(this.error)
      : position = null,
        isSuccess = false;
}

// Custom exceptions
class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}

class LocationServiceDisabledException extends LocationException {
  LocationServiceDisabledException() : super('Location services are disabled');
}

class LocationPermissionDeniedException extends LocationException {
  LocationPermissionDeniedException() : super('Location permission denied');
}

// Location utility functions
class LocationUtils {
  // Check if coordinates are valid
  static bool isValidCoordinate(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  // Format coordinates for display
  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  // Convert degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  // Convert radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * (180.0 / 3.141592653589793);
  }

  // Calculate area of a polygon (in square meters)
  static double calculatePolygonArea(List<Position> vertices) {
    if (vertices.length < 3) return 0;

    double area = 0;
    int j = vertices.length - 1;

    for (int i = 0; i < vertices.length; i++) {
      area += (vertices[j].longitude + vertices[i].longitude) *
          (vertices[j].latitude - vertices[i].latitude);
      j = i;
    }

    return (area.abs() / 2) *
        111319.9; // Convert to square meters (approximate)
  }

  // Check if point is inside polygon
  static bool isPointInPolygon(Position point, List<Position> polygon) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }
}
