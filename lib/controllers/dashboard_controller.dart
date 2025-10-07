import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../controllers/auth_controller.dart';
import '../core/services/firebase_service.dart';
import '../core/services/location_service.dart';
import '../core/services/storage_service.dart';
import '../data/models/bus_model.dart' hide LocationModel;
import '../data/models/safety_alert_model.dart';
import '../data/models/user_model.dart';
import '../data/repositories/bus_repository.dart';

// Dashboard state
class DashboardState {
  final bool isLoading;
  final Position? userLocation;
  final String? locationAddress;
  final List<BusModel> nearbyBuses;
  final List<SafetyAlertModel> activeAlerts;
  final UserModel? currentUser;
  final bool isLocationEnabled;
  final bool isConnected;
  final String? error;
  final int todayTrips;
  final double carbonSaved;
  final int pointsEarned;
  final List<BusModel> favoriteBuses;
  final List<String> recentSearches;
  final Map<String, dynamic> preferences;

  const DashboardState({
    this.isLoading = false,
    this.userLocation,
    this.locationAddress,
    this.nearbyBuses = const [],
    this.activeAlerts = const [],
    this.currentUser,
    this.isLocationEnabled = false,
    this.isConnected = true,
    this.error,
    this.todayTrips = 0,
    this.carbonSaved = 0.0,
    this.pointsEarned = 0,
    this.favoriteBuses = const [],
    this.recentSearches = const [],
    this.preferences = const {},
  });

  DashboardState copyWith({
    bool? isLoading,
    Position? userLocation,
    String? locationAddress,
    List<BusModel>? nearbyBuses,
    List<SafetyAlertModel>? activeAlerts,
    UserModel? currentUser,
    bool? isLocationEnabled,
    bool? isConnected,
    String? error,
    int? todayTrips,
    double? carbonSaved,
    int? pointsEarned,
    List<BusModel>? favoriteBuses,
    List<String>? recentSearches,
    Map<String, dynamic>? preferences,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      userLocation: userLocation ?? this.userLocation,
      locationAddress: locationAddress ?? this.locationAddress,
      nearbyBuses: nearbyBuses ?? this.nearbyBuses,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      currentUser: currentUser ?? this.currentUser,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      todayTrips: todayTrips ?? this.todayTrips,
      carbonSaved: carbonSaved ?? this.carbonSaved,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      favoriteBuses: favoriteBuses ?? this.favoriteBuses,
      recentSearches: recentSearches ?? this.recentSearches,
      preferences: preferences ?? this.preferences,
    );
  }
}

// Dashboard controller
class DashboardController extends StateNotifier<DashboardState> {
  final LocationService _locationService;
  final FirebaseService _firebaseService;
  final StorageService _storageService;
  final BusRepository _busRepository;
  final Ref _ref;

  Timer? _dataRefreshTimer;
  StreamSubscription<Position>? _locationSubscription;
  StreamSubscription<String>? _addressSubscription;

  DashboardController({
    required LocationService locationService,
    required FirebaseService firebaseService,
    required StorageService storageService,
    required BusRepository busRepository,
    required Ref ref,
  })  : _locationService = locationService,
        _firebaseService = firebaseService,
        _storageService = storageService,
        _busRepository = busRepository,
        _ref = ref,
        super(const DashboardState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserData();
    await _checkLocationPermissions();
    await _startLocationTracking();
    await _startDataRefresh();
  }

  Future<void> _loadUserData() async {
    try {
      state = state.copyWith(isLoading: true);

      final authState = _ref.read(authControllerProvider);
      final currentUser = authState.user; // Fixed: remove .value

      if (currentUser != null) {
        // final userData = await _storageService.getUserData(); // Commented out - method needs userId
        // final prefs = await _storageService.getUserPreferences(); // Commented out - method doesn't exist

        state = state.copyWith(
          currentUser: currentUser,
          preferences: {}, // prefs ?? {},
          isLoading: false,
        );
        await _loadTodayStats();
      }
    } catch (e) {
      print('Error loading user data: $e');
      state = state.copyWith(
        error: 'Failed to load user data',
        isLoading: false,
      );
    }
  }

  Future<void> _loadTodayStats() async {
    try {
      // Mock data for demo
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(
        todayTrips: 3,
        carbonSaved: 2.5,
        pointsEarned: 150,
      );
    } catch (e) {
      print('Error loading today stats: $e');
    }
  }

  Future<void> _checkLocationPermissions() async {
    try {
      // Mock location permission for demo
      state = state.copyWith(isLocationEnabled: true);
    } catch (e) {
      print('Error checking location permissions: $e');
      state = state.copyWith(error: 'Location permission error');
    }
  }

  Future<void> _startLocationTracking() async {
    if (!state.isLocationEnabled) return;

    try {
      print('Starting location tracking...');

      // Mock location for demo
      // _locationSubscription = _locationService.getLocationStream().listen(
      //   (position) {
      //     state = state.copyWith(
      //       userLocation: position,
      //       error: null,
      //     );
      //     _updateLocationAddress(position);
      //     _loadNearbyData();
      //   },
      //   onError: (error) {
      //     print('Location stream error: $error');
      //     state = state.copyWith(error: 'Location tracking failed');
      //   },
      // );
    } catch (e) {
      print('Error starting location tracking: $e');
      state = state.copyWith(error: 'Failed to start location tracking');
    }
  }

  Future<void> _updateLocationAddress(position) async {
    try {
      // Mock address for demo
      state = state.copyWith(locationAddress: 'Downtown Transit Hub');
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  Future<void> _loadNearbyData() async {
    final location = state.userLocation;
    // if (location == null) return;

    try {
      // Mock data for demo
      final buses = <BusModel>[];
      final alerts = <SafetyAlertModel>[];

      state = state.copyWith(
        nearbyBuses: buses,
        activeAlerts: alerts,
      );
    } catch (e) {
      print('Error loading nearby data: $e');
      state = state.copyWith(error: 'Failed to load nearby data');
    }
  }

  Future<void> _startDataRefresh() async {
    _dataRefreshTimer = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _loadNearbyData(),
    );
  }

  Future<void> refreshData() async {
    await _loadUserData();
    await _loadNearbyData();
  }

  Future<void> requestLocationPermission() async {
    try {
      // Mock permission request for demo
      state = state.copyWith(isLocationEnabled: true);

      if (state.isLocationEnabled) {
        await _startLocationTracking();
      }
    } catch (e) {
      print('Error requesting location permission: $e');
      state = state.copyWith(error: 'Failed to request location permission');
    }
  }

  Future<void> addToFavorites(BusModel bus) async {
    try {
      final currentFavorites = List<BusModel>.from(state.favoriteBuses);
      if (!currentFavorites.any((b) => b.id == bus.id)) {
        currentFavorites.add(bus);
        state = state.copyWith(favoriteBuses: currentFavorites);

        // Mock storage save
        // await _storageService.saveFavoriteBuses(currentFavorites);
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      state = state.copyWith(error: 'Failed to add to favorites');
    }
  }

  Future<void> removeFromFavorites(String busId) async {
    try {
      final currentFavorites = List<BusModel>.from(state.favoriteBuses);
      currentFavorites.removeWhere((b) => b.id == busId);
      state = state.copyWith(favoriteBuses: currentFavorites);

      // Mock storage save
      // await _storageService.saveFavoriteBuses(currentFavorites);
    } catch (e) {
      print('Error removing from favorites: $e');
      state = state.copyWith(error: 'Failed to remove from favorites');
    }
  }

  Future<void> addRecentSearch(String query) async {
    try {
      final currentSearches = List<String>.from(state.recentSearches);
      currentSearches.remove(query); // Remove if exists
      currentSearches.insert(0, query); // Add to beginning

      // Keep only last 10 searches
      if (currentSearches.length > 10) {
        currentSearches.removeRange(10, currentSearches.length);
      }

      state = state.copyWith(recentSearches: currentSearches);
      // Mock storage save
      // await _storageService.saveRecentSearches(currentSearches);
    } catch (e) {
      print('Error adding recent search: $e');
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> newPreferences) async {
    try {
      final updatedPrefs = Map<String, dynamic>.from(state.preferences);
      updatedPrefs.addAll(newPreferences);

      state = state.copyWith(preferences: updatedPrefs);
      // Mock storage save
      // await _storageService.saveUserPreferences(updatedPrefs);
    } catch (e) {
      print('Error updating preferences: $e');
      state = state.copyWith(error: 'Failed to update preferences');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _dataRefreshTimer?.cancel();
    _locationSubscription?.cancel();
    _addressSubscription?.cancel();
    super.dispose();
  }
}

// Providers
final busRepositoryProvider = Provider<BusRepository>((ref) {
  return BusRepository();
});

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  return DashboardController(
    locationService: LocationService.instance,
    firebaseService: ref.read(firebaseServiceProvider),
    storageService: ref.read(storageServiceProvider),
    busRepository: ref.read(busRepositoryProvider),
    ref: ref,
  );
});

// Helper providers
final userLocationProvider = Provider<Position?>((ref) {
  return ref.watch(dashboardControllerProvider).userLocation;
});

final nearbyBusesProvider = Provider<List<BusModel>>((ref) {
  return ref.watch(dashboardControllerProvider).nearbyBuses;
});

final activeAlertsProvider = Provider<List<SafetyAlertModel>>((ref) {
  return ref.watch(dashboardControllerProvider).activeAlerts;
});

final isLocationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(dashboardControllerProvider).isLocationEnabled;
});

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(dashboardControllerProvider).isConnected;
});
