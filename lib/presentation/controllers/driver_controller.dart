import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/driver_model.dart';
import '../../data/repositories/driver_repository.dart';

/// Controller for driver-related operations and state management
class DriverController extends StateNotifier<AsyncValue<void>> {
  final DriverRepository _driverRepository;

  DriverController({
    required DriverRepository driverRepository,
  })  : _driverRepository = driverRepository,
        super(const AsyncValue.data(null));

  // State management
  final ValueNotifier<List<DriverModel>> _drivers = ValueNotifier([]);
  final ValueNotifier<DriverModel?> _selectedDriver = ValueNotifier(null);
  final ValueNotifier<DriverModel?> _activeDriver = ValueNotifier(null);

  // Getters
  List<DriverModel> get drivers => _drivers.value;
  DriverModel? get selectedDriver => _selectedDriver.value;
  DriverModel? get activeDriver => _activeDriver.value;

  // Listeners
  ValueNotifier<List<DriverModel>> get driversNotifier => _drivers;
  ValueNotifier<DriverModel?> get selectedDriverNotifier => _selectedDriver;
  ValueNotifier<DriverModel?> get activeDriverNotifier => _activeDriver;

  /// Get all drivers
  Future<void> loadAllDrivers() async {
    try {
      state = const AsyncValue.loading();
      final driversList = await _driverRepository.getAllDrivers();
      _drivers.value = driversList;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load drivers: $e', stack);
    }
  }

  /// Get driver by ID
  Future<void> loadDriverById(String driverId) async {
    try {
      state = const AsyncValue.loading();
      final driver = await _driverRepository.getDriverById(driverId);
      if (driver != null) {
        _selectedDriver.value = driver;
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Driver not found', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load driver: $e', stack);
    }
  }

  /// Get available drivers
  Future<void> loadAvailableDrivers() async {
    try {
      state = const AsyncValue.loading();
      final availableDrivers = await _driverRepository.getAvailableDrivers();
      _drivers.value = availableDrivers;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load available drivers: $e', stack);
    }
  }

  /// Get drivers by bus ID
  Future<void> loadDriversByBus(String busId) async {
    try {
      state = const AsyncValue.loading();
      final busDrivers = await _driverRepository.getDriversByBus(busId);
      _drivers.value = busDrivers;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load bus drivers: $e', stack);
    }
  }

  /// Get driver performance metrics
  Future<Map<String, dynamic>?> getDriverPerformance(String driverId) async {
    try {
      final performance =
          await _driverRepository.getDriverPerformance(driverId);
      return performance?.toJson();
    } catch (e) {
      state = AsyncValue.error(
          'Failed to get driver performance: $e', StackTrace.current);
      return null;
    }
  }

  /// Select a specific driver
  void selectDriver(DriverModel driver) {
    _selectedDriver.value = driver;
  }

  /// Set active driver
  void setActiveDriver(DriverModel driver) {
    _activeDriver.value = driver;
  }

  /// Clear selected driver
  void clearSelection() {
    _selectedDriver.value = null;
  }

  /// Filter drivers by status
  List<DriverModel> getDriversByStatus(DriverStatus status) {
    return _drivers.value.where((driver) => driver.status == status).toList();
  }

  /// Get top rated drivers
  List<DriverModel> getTopRatedDrivers({int limit = 10}) {
    final sortedDrivers = List<DriverModel>.from(_drivers.value);
    sortedDrivers.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedDrivers.take(limit).toList();
  }

  /// Get drivers with high safety scores
  List<DriverModel> getSafeDrivers({double minSafetyScore = 80.0}) {
    return _drivers.value
        .where((driver) => driver.safetyScore >= minSafetyScore)
        .toList();
  }

  /// Search drivers by name or ID
  List<DriverModel> searchDrivers(String query) {
    if (query.isEmpty) return _drivers.value;

    final lowerQuery = query.toLowerCase();
    return _drivers.value
        .where((driver) =>
            driver.id.toLowerCase().contains(lowerQuery) ||
            '${driver.firstName} ${driver.lastName}'
                .toLowerCase()
                .contains(lowerQuery) ||
            driver.licenseNumber.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get experienced drivers
  List<DriverModel> getExperiencedDrivers({int minYears = 5}) {
    return _drivers.value
        .where((driver) => driver.experience.totalYears >= minYears)
        .toList();
  }

  /// Get drivers by license type
  List<DriverModel> getDriversByLicenseType(String licenseType) {
    return _drivers.value
        .where((driver) => driver.licenseType == licenseType)
        .toList();
  }

  /// Refresh driver data
  Future<void> refresh() async {
    await loadAllDrivers();
  }

  /// Get driver statistics
  Map<String, int> getDriverStatistics() {
    final stats = <String, int>{
      'total': _drivers.value.length,
      'available': 0,
      'onDuty': 0,
      'offDuty': 0,
      'break': 0,
    };

    for (final driver in _drivers.value) {
      switch (driver.status) {
        case DriverStatus.available:
          stats['available'] = stats['available']! + 1;
          break;
        case DriverStatus.onDuty:
          stats['onDuty'] = stats['onDuty']! + 1;
          break;
        case DriverStatus.offDuty:
          stats['offDuty'] = stats['offDuty']! + 1;
          break;
        case DriverStatus.onBreak:
          stats['break'] = stats['break']! + 1;
          break;
        case DriverStatus.active:
          stats['available'] = stats['available']! + 1;
          break;
        case DriverStatus.driving:
          stats['onDuty'] = stats['onDuty']! + 1;
          break;
        case DriverStatus.resting:
          stats['break'] = stats['break']! + 1;
          break;
        case DriverStatus.unavailable:
          stats['offDuty'] = stats['offDuty']! + 1;
          break;
        case DriverStatus.emergency:
          stats['onDuty'] = stats['onDuty']! + 1;
          break;
      }
    }

    return stats;
  }

  @override
  void dispose() {
    _drivers.dispose();
    _selectedDriver.dispose();
    _activeDriver.dispose();
    super.dispose();
  }
}

/// Provider for DriverController
final driverControllerProvider =
    StateNotifierProvider<DriverController, AsyncValue<void>>((ref) {
  final driverRepository = ref.read(driverRepositoryProvider);
  return DriverController(driverRepository: driverRepository);
});

/// Provider for DriverRepository
final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository();
});

/// Provider for drivers list
final driversProvider = Provider<List<DriverModel>>((ref) {
  final controller = ref.watch(driverControllerProvider.notifier);
  return controller.drivers;
});

/// Provider for selected driver
final selectedDriverProvider = Provider<DriverModel?>((ref) {
  final controller = ref.watch(driverControllerProvider.notifier);
  return controller.selectedDriver;
});

/// Provider for active driver
final activeDriverProvider = Provider<DriverModel?>((ref) {
  final controller = ref.watch(driverControllerProvider.notifier);
  return controller.activeDriver;
});
