import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/bus_repository.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/repositories/safety_repository.dart';
import '../../data/models/bus_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/safety_alert_model.dart';

// Dashboard State
class DashboardState {
  final bool isLoading;
  final double fleetSafetyScore;
  final int activeIncidents;
  final int totalBuses;
  final int activeBuses;
  final List<SafetyAlertModel> recentAlerts;
  final List<BusModel> nearbyBuses;
  final BusModel? activeJourney;
  final List<String> recentActivity;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.fleetSafetyScore = 0.0,
    this.activeIncidents = 0,
    this.totalBuses = 0,
    this.activeBuses = 0,
    this.recentAlerts = const [],
    this.nearbyBuses = const [],
    this.activeJourney,
    this.recentActivity = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    double? fleetSafetyScore,
    int? activeIncidents,
    int? totalBuses,
    int? activeBuses,
    List<SafetyAlertModel>? recentAlerts,
    List<BusModel>? nearbyBuses,
    BusModel? activeJourney,
    List<String>? recentActivity,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      fleetSafetyScore: fleetSafetyScore ?? this.fleetSafetyScore,
      activeIncidents: activeIncidents ?? this.activeIncidents,
      totalBuses: totalBuses ?? this.totalBuses,
      activeBuses: activeBuses ?? this.activeBuses,
      recentAlerts: recentAlerts ?? this.recentAlerts,
      nearbyBuses: nearbyBuses ?? this.nearbyBuses,
      activeJourney: activeJourney ?? this.activeJourney,
      recentActivity: recentActivity ?? this.recentActivity,
      error: error,
    );
  }
}

// Dashboard Controller
class DashboardController extends StateNotifier<DashboardState> {
  final BusRepository _busRepository;
  final DriverRepository _driverRepository;
  final SafetyRepository _safetyRepository;

  DashboardController(
    this._busRepository,
    this._driverRepository,
    this._safetyRepository,
  ) : super(const DashboardState());

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load data in parallel
      final results = await Future.wait([
        _loadFleetData(),
        _loadSafetyData(),
        _loadNearbyBuses(),
        _loadActiveJourney(),
        _loadRecentActivity(),
      ]);

      // No state updates needed here as each method updates state individually
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _loadFleetData() async {
    try {
      final buses = await _busRepository.getAllBuses();
      final activeBuses = buses
          .where((bus) =>
              bus.status == BusStatus.active || bus.status == BusStatus.enRoute)
          .toList();

      state = state.copyWith(
        totalBuses: buses.length,
        activeBuses: activeBuses.length,
      );
    } catch (e) {
      // Handle error
      print('Error loading fleet data: $e');
    }
  }

  Future<void> _loadSafetyData() async {
    try {
      final alerts = await _safetyRepository.getRecentAlerts();
      final activeIncidents = alerts
          .where((alert) =>
              alert.isActive &&
              (alert.severity == AlertSeverity.high ||
                  alert.severity == AlertSeverity.critical))
          .length;

      // Calculate fleet safety score
      final buses = await _busRepository.getAllBuses();
      final totalScore =
          buses.fold<double>(0.0, (sum, bus) => sum + bus.safetyScore);
      final averageScore = buses.isNotEmpty ? totalScore / buses.length : 0.0;

      state = state.copyWith(
        fleetSafetyScore: averageScore,
        activeIncidents: activeIncidents,
        recentAlerts: alerts.take(5).toList(),
      );
    } catch (e) {
      print('Error loading safety data: $e');
    }
  }

  Future<void> _loadNearbyBuses() async {
    try {
      // In a real app, this would use user's location
      final buses = await _busRepository.getNearbyBuses(
        0.0, // latitude - Replace with actual user location
        0.0, // longitude
        radiusKm: 5.0,
      );

      state = state.copyWith(nearbyBuses: buses.take(10).toList());
    } catch (e) {
      print('Error loading nearby buses: $e');
    }
  }

  Future<void> _loadActiveJourney() async {
    try {
      // Check if user has an active journey
      final activeJourney = await _busRepository.getActiveJourney('current_user_id'); // Replace with actual user ID
      state = state.copyWith(activeJourney: activeJourney);
    } catch (e) {
      print('Error loading active journey: $e');
    }
  }

  Future<void> _loadRecentActivity() async {
    try {
      // Mock recent activity data
      final activities = [
        'Boarded Bus #123 on Route A',
        'Submitted feedback for Trip #456',
        'Safety alert resolved for Route B',
        'New route notification received',
      ];

      state = state.copyWith(recentActivity: activities);
    } catch (e) {
      print('Error loading recent activity: $e');
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void updateActiveJourney(BusModel? journey) {
    state = state.copyWith(activeJourney: journey);
  }

  void addRecentActivity(String activity) {
    final updatedActivity = [activity, ...state.recentActivity];
    state = state.copyWith(
      recentActivity: updatedActivity.take(10).toList(),
    );
  }
}

// Providers
final busRepositoryProvider = Provider<BusRepository>((ref) {
  return BusRepository();
});

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository();
});

final safetyRepositoryProvider = Provider<SafetyRepository>((ref) {
  return SafetyRepository();
});

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
  final busRepository = ref.read(busRepositoryProvider);
  final driverRepository = ref.read(driverRepositoryProvider);
  final safetyRepository = ref.read(safetyRepositoryProvider);

  return DashboardController(
    busRepository,
    driverRepository,
    safetyRepository,
  );
});
