import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../core/services/device_permission_service.dart';
import '../core/services/location_service.dart';
import '../core/services/storage_service.dart';
import 'app_providers.dart';

class AppSettingsState {
  final bool locationUsageEnabled;
  final bool autoRefreshEnabled;
  final bool hapticFeedbackEnabled;
  final bool isLocationServiceEnabled;
  final LocationPermission locationPermission;
  final bool isLocationBusy;
  final String? error;

  const AppSettingsState({
    this.locationUsageEnabled = true,
    this.autoRefreshEnabled = true,
    this.hapticFeedbackEnabled = true,
    this.isLocationServiceEnabled = false,
    this.locationPermission = LocationPermission.denied,
    this.isLocationBusy = false,
    this.error,
  });

  bool get hasLocationPermission =>
      locationPermission == LocationPermission.always ||
      locationPermission == LocationPermission.whileInUse;

  bool get isLocationEnabled =>
      isLocationServiceEnabled && hasLocationPermission;

  bool get isLocationPermanentlyDenied =>
      locationPermission == LocationPermission.deniedForever;

  bool get canUseLocationFeatures => locationUsageEnabled && isLocationEnabled;

  String get locationDescription {
    if (!locationUsageEnabled) {
      if (hasLocationPermission || isLocationServiceEnabled) {
        return 'SafeDriver location features are turned off in the app. On some devices the system permission may still remain granted.';
      }

      return 'SafeDriver location features are turned off.';
    }

    if (!isLocationServiceEnabled) {
      return 'Device location services are off. Enable them in system settings for live routing and safety tools.';
    }

    if (isLocationPermanentlyDenied) {
      return 'Location permission is blocked for SafeDriver. Open app settings to allow access again.';
    }

    if (!hasLocationPermission) {
      return 'Location permission is currently off. Turn it on to use GPS-powered journey suggestions and safety features.';
    }

    return 'GPS-powered journey suggestions and safety tools are active on this device.';
  }

  String? get locationBadge {
    if (!locationUsageEnabled) {
      return hasLocationPermission ? 'In app off' : 'Off';
    }

    if (isLocationEnabled) {
      return 'Allowed';
    }

    if (!isLocationServiceEnabled) {
      return 'Device off';
    }

    if (isLocationPermanentlyDenied) {
      return 'Settings';
    }

    return 'Off';
  }

  AppSettingsState copyWith({
    bool? locationUsageEnabled,
    bool? autoRefreshEnabled,
    bool? hapticFeedbackEnabled,
    bool? isLocationServiceEnabled,
    LocationPermission? locationPermission,
    bool? isLocationBusy,
    String? error,
    bool clearError = false,
  }) {
    return AppSettingsState(
      locationUsageEnabled: locationUsageEnabled ?? this.locationUsageEnabled,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      isLocationServiceEnabled:
          isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      locationPermission: locationPermission ?? this.locationPermission,
      isLocationBusy: isLocationBusy ?? this.isLocationBusy,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettingsState> {
  AppSettingsController(this._ref) : super(const AppSettingsState()) {
    _storageService = _ref.read(storageServiceProvider);
    _locationService = _ref.read(locationServiceProvider);
    _devicePermissionService = _ref.read(devicePermissionServiceProvider);
    _initialize();
  }

  static const String _locationUsageKey = 'settings_location_usage_enabled';
  static const String _autoRefreshKey = 'settings_auto_refresh';
  static const String _hapticFeedbackKey = 'settings_haptic_feedback';

  final Ref _ref;
  late final StorageService _storageService;
  late final LocationService _locationService;
  late final DevicePermissionService _devicePermissionService;

  Future<void> _initialize() async {
    final locationUsage =
        _storageService.getBool(_locationUsageKey, defaultValue: true) ?? true;
    final autoRefresh =
        _storageService.getBool(_autoRefreshKey, defaultValue: true) ?? true;
    final hapticFeedback =
        _storageService.getBool(_hapticFeedbackKey, defaultValue: true) ?? true;

    state = state.copyWith(
      locationUsageEnabled: locationUsage,
      autoRefreshEnabled: autoRefresh,
      hapticFeedbackEnabled: hapticFeedback,
      clearError: true,
    );

    await refreshDeviceSettings();
  }

  Future<void> refreshDeviceSettings() async {
    try {
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      final permissionStatus = await _locationService.checkLocationPermission();

      state = state.copyWith(
        isLocationServiceEnabled: serviceEnabled,
        locationPermission: permissionStatus,
        isLocationBusy: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLocationBusy: false,
        error: 'Failed to refresh device permission status.',
      );
    }
  }

  Future<String> setLocationEnabled(bool enabled) async {
    state = state.copyWith(isLocationBusy: true, clearError: true);

    try {
      final message = enabled
          ? await _enableLocationAccess()
          : await _disableLocationAccess();
      await refreshDeviceSettings();
      return message;
    } catch (error) {
      state = state.copyWith(
        isLocationBusy: false,
        error: 'Unable to update location access right now.',
      );
      return 'Unable to update location access right now.';
    }
  }

  Future<void> setAutoRefreshEnabled(bool enabled) async {
    await _storageService.saveBool(_autoRefreshKey, enabled);
    state = state.copyWith(autoRefreshEnabled: enabled, clearError: true);
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    await _storageService.saveBool(_hapticFeedbackKey, enabled);
    state = state.copyWith(hapticFeedbackEnabled: enabled, clearError: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<String> _enableLocationAccess() async {
    var serviceEnabled = await _locationService.isLocationServiceEnabled();

    if (!serviceEnabled) {
      final openedLocationSettings = await Geolocator.openLocationSettings();
      if (!openedLocationSettings) {
        return 'Open device location settings to turn location services on.';
      }

      serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Turn on device location services, then return to SafeDriver.';
      }
    }

    var permissionStatus = await _locationService.checkLocationPermission();
    if (permissionStatus == LocationPermission.denied) {
      permissionStatus = await _locationService.requestLocationPermission();
    }

    if (_isLocationPermissionGranted(permissionStatus)) {
      await _storageService.saveBool(_locationUsageKey, true);
      state = state.copyWith(locationUsageEnabled: true, clearError: true);
      return 'Location access is now enabled for this device.';
    }

    await _storageService.saveBool(_locationUsageKey, false);
    state = state.copyWith(locationUsageEnabled: false, clearError: true);

    if (permissionStatus == LocationPermission.deniedForever) {
      final openedAppSettings = await permission.openAppSettings();
      if (openedAppSettings) {
        return 'Location permission is blocked. Enable it in app settings, then return to SafeDriver.';
      }

      return 'Location permission is blocked. Please enable it from device settings.';
    }

    return 'Location permission was not granted.';
  }

  Future<String> _disableLocationAccess() async {
    await _storageService.saveBool(_locationUsageKey, false);
    state = state.copyWith(locationUsageEnabled: false, clearError: true);

    if (!kIsWeb && Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt != null && sdkInt >= 33) {
        final revoked =
            await _devicePermissionService.revokeLocationPermissionOnAndroid();
        if (revoked) {
          return 'Location turned off. Android will revoke SafeDriver location permission after the app leaves the foreground.';
        }
      }
    }

    return 'Location turned off for SafeDriver. On this device, system location permission may still remain granted until the user changes it.';
  }

  bool _isLocationPermissionGranted(LocationPermission permissionStatus) {
    return permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse;
  }

  Future<int?> _getAndroidSdkInt() async {
    const channel =
        MethodChannel('com.codecrafters.safedriver/device_permissions');
    try {
      return await channel.invokeMethod<int>('getAndroidSdkInt');
    } on Object {
      return null;
    }
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettingsState>((ref) {
  return AppSettingsController(ref);
});
