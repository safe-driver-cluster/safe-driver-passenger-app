import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
// import '../controllers/dashboard_controller.dart'; // Commented out - using simple_providers instead
import '../core/services/firebase_service.dart';
import '../core/services/location_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';
import '../data/repositories/bus_repository.dart';
// import '../data/repositories/safety_alert_repository.dart'; // Commented out - unused
import '../data/repositories/user_repository.dart';

// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

// Location Service Provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService.instance;
});

// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

// Repository Providers
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return UserRepository(firebaseService: firebaseService);
});

final busRepositoryProvider = Provider<BusRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return BusRepository(firebaseService: firebaseService);
});

// Commented out SafetyAlertRepository provider to fix compilation
// final safetyAlertRepositoryProvider = Provider<SafetyAlertRepository>((ref) {
//   final firebaseService = ref.watch(firebaseServiceProvider);
//   return SafetyAlertRepository(firebaseService: firebaseService);
// });

// Auth Controller Provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final firebaseService = ref.watch(firebaseServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  return AuthController(
    userRepository: userRepository,
    firebaseService: firebaseService,
    storageService: storageService,
    notificationService: notificationService,
  );
});

// Dashboard Controller Provider - Commented out, using simple_providers instead
// final dashboardControllerProvider =
//     StateNotifierProvider<DashboardController, DashboardState>((ref) {
//   final busRepository = ref.watch(busRepositoryProvider);
//   final safetyAlertRepository = ref.watch(safetyAlertRepositoryProvider);
//   final locationService = ref.watch(locationServiceProvider);
//   final firebaseService = ref.watch(firebaseServiceProvider);
//   final storageService = ref.watch(storageServiceProvider);
//
//   return DashboardController(
//     busRepository: busRepository,
//     alertRepository: safetyAlertRepository,
//     locationService: locationService,
//     firebaseService: firebaseService,
//     storageService: storageService,
//     ref: ref,
//   );
// });

// Current User Provider
final currentUserProvider = Provider((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.user;
});

// Is Authenticated Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.state == AuthState.authenticated;
});

// Auth Loading Provider
final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.isLoading;
});

// Dashboard related providers commented out - using simple_providers instead
// // Nearby Buses Provider
// final nearbyBusesProvider = Provider((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.nearbyBuses;
// });

// // Active Safety Alerts Provider
// final activeSafetyAlertsProvider = Provider((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.activeAlerts;
// });

// // Current Location Provider
// final currentLocationProvider = Provider((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.userLocation;
// });

// // Dashboard Loading Provider
// final dashboardLoadingProvider = Provider<bool>((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.isLoading;
// });

// // Connectivity State Provider
// final connectivityStateProvider = Provider<bool>((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.isConnected;
// });

// // Location Permission Provider
// final locationPermissionProvider = Provider<bool>((ref) {
//   final dashboardState = ref.watch(dashboardControllerProvider);
//   return dashboardState.isLocationEnabled;
// });

// Error State Provider
final errorStateProvider = Provider<String?>((ref) {
  final authState = ref.watch(authControllerProvider);
  // final dashboardState = ref.watch(dashboardControllerProvider); // Commented out

  // Return auth error for now
  return authState.error;
});

// Bus Search Provider (for searching specific buses)
final busSearchProvider =
    FutureProvider.family<List<dynamic>, String>((ref, searchQuery) async {
  final busRepository = ref.watch(busRepositoryProvider);

  if (searchQuery.isEmpty) {
    return [];
  }

  try {
    return await busRepository.searchBusesByNumber(searchQuery);
  } catch (e) {
    throw Exception('Failed to search buses: $e');
  }
});

// Safety Alert providers commented out - SafetyAlertRepository needs fixing
// // Safety Alert by Location Provider
// final safetyAlertsByLocationProvider =
//     FutureProvider.family<List<dynamic>, Map<String, double>>(
//         (ref, location) async {
//   final safetyAlertRepository = ref.watch(safetyAlertRepositoryProvider);

//   try {
//     return await safetyAlertRepository.getSafetyAlertsByLocation(
//       latitude: location['latitude']!,
//       longitude: location['longitude']!,
//       radiusKm: location['radius'] ?? 10.0,
//     );
//   } catch (e) {
//     throw Exception('Failed to get safety alerts: $e');
//   }
// });

// // User Safety Alerts Provider
// final userSafetyAlertsProvider =
//     FutureProvider.family<List<dynamic>, String>((ref, userId) async {
//   final safetyAlertRepository = ref.watch(safetyAlertRepositoryProvider);

//   try {
//     return await safetyAlertRepository.getUserSafetyAlerts(userId);
//   } catch (e) {
//     throw Exception('Failed to get user safety alerts: $e');
//   }
// });

// // Safety Alert Statistics Provider
// final safetyAlertStatsProvider =
//     FutureProvider<Map<String, dynamic>>((ref) async {
//   final safetyAlertRepository = ref.watch(safetyAlertRepositoryProvider);

//   try {
//     return await safetyAlertRepository.getSafetyAlertStats();
//   } catch (e) {
//     throw Exception('Failed to get safety alert statistics: $e');
//   }
// });

class ThemeModeController extends StateNotifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  ThemeModeController() : super(ThemeMode.system) {
    _loadSavedThemeMode();
  }

  Future<void> _loadSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themeModeKey);

      if (savedThemeMode != null) {
        state = _themeModeFromString(savedThemeMode);
      }
    } catch (e) {
      debugPrint('Error loading saved theme mode: $e');
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    try {
      state = themeMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, _themeModeToString(themeMode));
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  static ThemeMode _themeModeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

// Theme Mode Provider (for app theming)
final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController();
});

// Language Provider (for localization)
final languageProvider = StateProvider<String>((ref) {
  // Default to English
  return 'en';
});

// App Lifecycle Provider (for handling app state changes)
final appLifecycleProvider = StateProvider<String>((ref) {
  return 'resumed';
});
