import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bus_model.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/bus_repository.dart';

/// Controller for bus-related operations and state management
class BusController extends StateNotifier<AsyncValue<void>> {
  final BusRepository _busRepository;

  BusController({
    required BusRepository busRepository,
  })  : _busRepository = busRepository,
        super(const AsyncValue.data(null));

  // State management
  final ValueNotifier<List<BusModel>> _buses = ValueNotifier([]);
  final ValueNotifier<BusModel?> _selectedBus = ValueNotifier(null);
  final ValueNotifier<BusModel?> _activeBus = ValueNotifier(null);
  final ValueNotifier<LocationModel?> _userLocation = ValueNotifier(null);

  // Getters
  List<BusModel> get buses => _buses.value;
  BusModel? get selectedBus => _selectedBus.value;
  BusModel? get activeBus => _activeBus.value;
  LocationModel? get userLocation => _userLocation.value;

  // Listeners
  ValueNotifier<List<BusModel>> get busesNotifier => _buses;
  ValueNotifier<BusModel?> get selectedBusNotifier => _selectedBus;
  ValueNotifier<BusModel?> get activeBusNotifier => _activeBus;
  ValueNotifier<LocationModel?> get userLocationNotifier => _userLocation;

  /// Get all available buses
  Future<void> loadAllBuses() async {
    try {
      state = const AsyncValue.loading();
      final busList = await _busRepository.getAllBuses();
      _buses.value = busList;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load buses: $e', stack);
    }
  }

  /// Get nearby buses based on user location
  Future<void> loadNearbyBuses(double latitude, double longitude,
      {double radiusKm = 5.0}) async {
    try {
      state = const AsyncValue.loading();
      final nearbyBuses = await _busRepository
          .getNearbyBuses(latitude, longitude, radiusKm: radiusKm);
      _buses.value = nearbyBuses;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load nearby buses: $e', stack);
    }
  }

  /// Get bus by ID
  Future<void> loadBusById(String busId) async {
    try {
      state = const AsyncValue.loading();
      final bus = await _busRepository.getBusById(busId);
      if (bus != null) {
        _selectedBus.value = bus;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Bus not found', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load bus: $e', stack);
    }
  }

  /// Get bus by QR code
  Future<void> loadBusByQrCode(String qrCode) async {
    try {
      state = const AsyncValue.loading();
      final bus = await _busRepository.getBusByQrCode(qrCode);
      if (bus != null) {
        _selectedBus.value = bus;
        state = const AsyncValue.data(null);
      } else {
        state =
            AsyncValue.error('Bus not found for QR code', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load bus by QR code: $e', stack);
    }
  }

  /// Get user's active journey
  Future<void> loadActiveJourney(String userId) async {
    try {
      state = const AsyncValue.loading();
      final activeBus = await _busRepository.getActiveJourney(userId);
      _activeBus.value = activeBus;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load active journey: $e', stack);
    }
  }

  /// Update user location
  void updateUserLocation(LocationModel location) {
    _userLocation.value = location;
  }

  /// Select a specific bus
  void selectBus(BusModel bus) {
    _selectedBus.value = bus;
  }

  /// Clear selected bus
  void clearSelection() {
    _selectedBus.value = null;
  }

  /// Filter buses by status
  List<BusModel> getBusesByStatus(BusStatus status) {
    return _buses.value.where((bus) => bus.status == status).toList();
  }

  /// Get buses sorted by distance (requires user location)
  List<BusModel> getBusesByDistance() {
    if (_userLocation.value == null) return _buses.value;

    final userLoc = _userLocation.value!;
    final busesList = List<BusModel>.from(_buses.value);

    busesList.sort((a, b) {
      if (a.currentLocation == null && b.currentLocation == null) return 0;
      if (a.currentLocation == null) return 1;
      if (b.currentLocation == null) return -1;

      final distanceA = userLoc.distanceTo(a.currentLocation!);
      final distanceB = userLoc.distanceTo(b.currentLocation!);

      return distanceA.compareTo(distanceB);
    });

    return busesList;
  }

  /// Get available buses (online and active)
  List<BusModel> getAvailableBuses() {
    return _buses.value
        .where((bus) =>
            bus.status == BusStatus.online || bus.status == BusStatus.inTransit)
        .toList();
  }

  /// Search buses by number or route
  List<BusModel> searchBuses(String query) {
    if (query.isEmpty) return _buses.value;

    final lowerQuery = query.toLowerCase();
    return _buses.value
        .where((bus) =>
            bus.busNumber.toLowerCase().contains(lowerQuery) ||
            bus.routeNumber.toLowerCase().contains(lowerQuery) ||
            (bus.driverName?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  /// Refresh bus data
  Future<void> refresh() async {
    if (_userLocation.value != null) {
      await loadNearbyBuses(
        _userLocation.value!.latitude,
        _userLocation.value!.longitude,
      );
    } else {
      await loadAllBuses();
    }
  }

  @override
  void dispose() {
    _buses.dispose();
    _selectedBus.dispose();
    _activeBus.dispose();
    _userLocation.dispose();
    super.dispose();
  }
}

/// Provider for BusController
final busControllerProvider =
    StateNotifierProvider<BusController, AsyncValue<void>>((ref) {
  final busRepository = ref.read(busRepositoryProvider);
  return BusController(busRepository: busRepository);
});

/// Provider for BusRepository
final busRepositoryProvider = Provider<BusRepository>((ref) {
  return BusRepository();
});

/// Provider for buses list
final busesProvider = Provider<List<BusModel>>((ref) {
  final controller = ref.watch(busControllerProvider.notifier);
  return controller.buses;
});

/// Provider for selected bus
final selectedBusProvider = Provider<BusModel?>((ref) {
  final controller = ref.watch(busControllerProvider.notifier);
  return controller.selectedBus;
});

/// Provider for active journey
final activeJourneyProvider = Provider<BusModel?>((ref) {
  final controller = ref.watch(busControllerProvider.notifier);
  return controller.activeBus;
});
