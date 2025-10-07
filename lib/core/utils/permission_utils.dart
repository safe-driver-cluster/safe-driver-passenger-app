import 'package:permission_handler/permission_handler.dart';

/// Utility class for handling device permissions
class PermissionUtils {
  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status == PermissionStatus.granted;
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status == PermissionStatus.granted;
  }

  /// Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status == PermissionStatus.granted;
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  /// Check if storage permission is granted
  static Future<bool> isStoragePermissionGranted() async {
    final status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  /// Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  /// Check if microphone permission is granted
  static Future<bool> isMicrophonePermissionGranted() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  /// Request phone permission
  static Future<bool> requestPhonePermission() async {
    final status = await Permission.phone.request();
    return status == PermissionStatus.granted;
  }

  /// Check if phone permission is granted
  static Future<bool> isPhonePermissionGranted() async {
    final status = await Permission.phone.status;
    return status == PermissionStatus.granted;
  }

  /// Request contacts permission
  static Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status == PermissionStatus.granted;
  }

  /// Check if contacts permission is granted
  static Future<bool> isContactsPermissionGranted() async {
    final status = await Permission.contacts.status;
    return status == PermissionStatus.granted;
  }

  /// Request all necessary permissions for the app
  static Future<Map<Permission, PermissionStatus>>
      requestAllPermissions() async {
    final permissions = [
      Permission.location,
      Permission.camera,
      Permission.notification,
      Permission.storage,
    ];

    return await permissions.request();
  }

  /// Check all permissions status
  static Future<Map<Permission, PermissionStatus>> checkAllPermissions() async {
    final permissions = [
      Permission.location,
      Permission.camera,
      Permission.notification,
      Permission.storage,
    ];

    final Map<Permission, PermissionStatus> statuses = {};
    for (final permission in permissions) {
      statuses[permission] = await permission.status;
    }

    return statuses;
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied(
      Permission permission) async {
    final status = await permission.status;
    return status == PermissionStatus.permanentlyDenied;
  }

  /// Get permission status as readable string
  static String getPermissionStatusString(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.provisional:
        return 'Provisional';
      default:
        return 'Unknown';
    }
  }

  /// Handle permission denial with user-friendly message
  static String getPermissionDeniedMessage(Permission permission) {
    switch (permission) {
      case Permission.location:
        return 'Location permission is required to track buses and provide accurate arrival times. Please enable it in settings.';
      case Permission.camera:
        return 'Camera permission is required to scan QR codes for bus information. Please enable it in settings.';
      case Permission.notification:
        return 'Notification permission is required to receive important safety alerts and bus updates. Please enable it in settings.';
      case Permission.storage:
        return 'Storage permission is required to save trip history and offline data. Please enable it in settings.';
      case Permission.microphone:
        return 'Microphone permission is required for voice commands and emergency calls. Please enable it in settings.';
      case Permission.phone:
        return 'Phone permission is required for emergency calling features. Please enable it in settings.';
      case Permission.contacts:
        return 'Contacts permission is required to add emergency contacts. Please enable it in settings.';
      default:
        return 'This permission is required for the app to function properly. Please enable it in settings.';
    }
  }

  /// Check if all critical permissions are granted
  static Future<bool> areAllCriticalPermissionsGranted() async {
    final locationGranted = await isLocationPermissionGranted();
    final cameraGranted = await isCameraPermissionGranted();
    final notificationGranted = await isNotificationPermissionGranted();

    return locationGranted && cameraGranted && notificationGranted;
  }

  /// Request permission with retry option
  static Future<bool> requestPermissionWithRetry(
    Permission permission, {
    int maxRetries = 3,
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      final status = await permission.request();

      if (status == PermissionStatus.granted) {
        return true;
      }

      if (status == PermissionStatus.permanentlyDenied) {
        return false;
      }

      attempts++;

      // Wait before retry
      if (attempts < maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return false;
  }
}
