import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/location_model.dart';
import '../../data/models/safety_alert_model.dart';
import '../../data/repositories/safety_repository.dart';

/// Controller for safety-related operations and monitoring
class SafetyController extends StateNotifier<AsyncValue<void>> {
  final SafetyRepository _safetyRepository;

  SafetyController({
    required SafetyRepository safetyRepository,
  })  : _safetyRepository = safetyRepository,
        super(const AsyncValue.data(null));

  // State management
  final ValueNotifier<List<SafetyAlertModel>> _alerts = ValueNotifier([]);
  final ValueNotifier<List<SafetyAlertModel>> _activeAlerts = ValueNotifier([]);
  final ValueNotifier<bool> _emergencyMode = ValueNotifier(false);
  final ValueNotifier<LocationModel?> _emergencyLocation = ValueNotifier(null);

  // Getters
  List<SafetyAlertModel> get alerts => _alerts.value;
  List<SafetyAlertModel> get activeAlerts => _activeAlerts.value;
  bool get emergencyMode => _emergencyMode.value;
  LocationModel? get emergencyLocation => _emergencyLocation.value;

  // Listeners
  ValueNotifier<List<SafetyAlertModel>> get alertsNotifier => _alerts;
  ValueNotifier<List<SafetyAlertModel>> get activeAlertsNotifier =>
      _activeAlerts;
  ValueNotifier<bool> get emergencyModeNotifier => _emergencyMode;
  ValueNotifier<LocationModel?> get emergencyLocationNotifier =>
      _emergencyLocation;

  /// Load all safety alerts
  Future<void> loadAlerts() async {
    try {
      state = const AsyncValue.loading();
      final alertsList = await _safetyRepository.getAllAlerts();
      _alerts.value = alertsList;

      // Filter active alerts
      _activeAlerts.value = alertsList
          .where((alert) => alert.status == AlertStatus.active)
          .toList();

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load alerts: $e', stack);
    }
  }

  /// Load alerts by bus ID
  Future<void> loadAlertsByBus(String busId) async {
    try {
      state = const AsyncValue.loading();
      final busAlerts = await _safetyRepository.getAlertsByBus(busId);
      _alerts.value = busAlerts;

      // Filter active alerts
      _activeAlerts.value = busAlerts
          .where((alert) => alert.status == AlertStatus.active)
          .toList();

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load bus alerts: $e', stack);
    }
  }

  /// Create emergency alert
  Future<void> createEmergencyAlert({
    required String userId,
    required String busId,
    required LocationModel location,
    required String description,
    AlertType? alertType,
  }) async {
    try {
      state = const AsyncValue.loading();

      final alert = SafetyAlertModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: alertType ?? AlertType.emergency,
        priority: AlertPriority.emergency,
        title: 'Emergency Alert',
        description: description,
        busId: busId,
        location: location,
        timestamp: DateTime.now(),
        status: AlertStatus.active,
        severity: AlertSeverity.high,
        affectedAreas: [],
        additionalData: {},
        tags: [],
        recommendedActions: [],
      );

      await _safetyRepository.createAlert(alert);

      // Add to local state
      _alerts.value = [..._alerts.value, alert];
      _activeAlerts.value = [..._activeAlerts.value, alert];

      // Activate emergency mode
      _emergencyMode.value = true;
      _emergencyLocation.value = location;

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to create emergency alert: $e', stack);
    }
  }

  /// Create safety alert
  Future<void> createSafetyAlert({
    required String userId,
    required String busId,
    required AlertType alertType,
    required String title,
    required String description,
    LocationModel? location,
    int severity = AlertSeverity.medium, // Use int instead of AlertSeverity
    Map<String, dynamic>? metadata,
  }) async {
    try {
      state = const AsyncValue.loading();

      final alert = SafetyAlertModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: alertType,
        priority: AlertPriority.high,
        title: title,
        description: description,
        busId: busId,
        location: location,
        timestamp: DateTime.now(),
        status: AlertStatus.active,
        severity: severity,
        affectedAreas: [],
        additionalData: metadata ?? {},
        tags: [],
        recommendedActions: [],
      );

      await _safetyRepository.createAlert(alert);

      // Add to local state
      _alerts.value = [..._alerts.value, alert];
      _activeAlerts.value = [..._activeAlerts.value, alert];

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to create safety alert: $e', stack);
    }
  }

  /// Acknowledge alert
  Future<void> acknowledgeAlert(String alertId) async {
    try {
      state = const AsyncValue.loading();
      await _safetyRepository.acknowledgeAlert(
          alertId, 'current_user_id'); // Replace with actual user ID

      // Update local state
      _updateAlertStatus(alertId, AlertStatus.acknowledged);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to acknowledge alert: $e', stack);
    }
  }

  /// Resolve alert
  Future<void> resolveAlert(String alertId) async {
    try {
      state = const AsyncValue.loading();
      await _safetyRepository.resolveAlert(alertId);

      // Update local state
      _updateAlertStatus(alertId, AlertStatus.resolved);

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to resolve alert: $e', stack);
    }
  }

  /// Toggle emergency mode
  void toggleEmergencyMode() {
    _emergencyMode.value = !_emergencyMode.value;
    if (!_emergencyMode.value) {
      _emergencyLocation.value = null;
    }
  }

  /// Set emergency location
  void setEmergencyLocation(LocationModel location) {
    _emergencyLocation.value = location;
  }

  /// Get alerts by severity
  List<SafetyAlertModel> getAlertsBySeverity(AlertSeverity severity) {
    return _alerts.value.where((alert) => alert.severity == severity).toList();
  }

  /// Get high priority alerts
  List<SafetyAlertModel> getHighPriorityAlerts() {
    return _alerts.value
        .where((alert) =>
            alert.severity == AlertSeverity.high &&
            alert.status == AlertStatus.active)
        .toList();
  }

  /// Get alerts by type
  List<SafetyAlertModel> getAlertsByType(AlertType type) {
    return _alerts.value.where((alert) => alert.type == type).toList();
  }

  /// Get recent alerts (last 24 hours)
  List<SafetyAlertModel> getRecentAlerts() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _alerts.value
        .where((alert) => alert.timestamp.isAfter(yesterday))
        .toList();
  }

  /// Clear resolved alerts
  void clearResolvedAlerts() {
    _alerts.value = _alerts.value
        .where((alert) => alert.status != AlertStatus.resolved)
        .toList();

    _activeAlerts.value = _activeAlerts.value
        .where((alert) => alert.status == AlertStatus.active)
        .toList();
  }

  /// Get safety statistics
  Map<String, int> getSafetyStatistics() {
    final stats = <String, int>{
      'total': _alerts.value.length,
      'active': 0,
      'acknowledged': 0,
      'resolved': 0,
      'high': 0,
      'medium': 0,
      'low': 0,
    };

    for (final alert in _alerts.value) {
      // Count by status
      switch (alert.status) {
        case AlertStatus.active:
          stats['active'] = stats['active']! + 1;
          break;
        case AlertStatus.acknowledged:
          stats['acknowledged'] = stats['acknowledged']! + 1;
          break;
        case AlertStatus.resolved:
          stats['resolved'] = stats['resolved']! + 1;
          break;
        case AlertStatus.inProgress:
          stats['inProgress'] = (stats['inProgress'] ?? 0) + 1;
          break;
        case AlertStatus.dismissed:
          stats['dismissed'] = (stats['dismissed'] ?? 0) + 1;
          break;
        case AlertStatus.escalated:
          stats['escalated'] = (stats['escalated'] ?? 0) + 1;
          break;
      }

      // Count by severity
      switch (alert.severity) {
        case AlertSeverity.high:
          stats['high'] = stats['high']! + 1;
          break;
        case AlertSeverity.medium:
          stats['medium'] = stats['medium']! + 1;
          break;
        case AlertSeverity.low:
          stats['low'] = stats['low']! + 1;
          break;
      }
    }

    return stats;
  }

  /// Update alert status in local state
  void _updateAlertStatus(String alertId, AlertStatus newStatus) {
    _alerts.value = _alerts.value.map((alert) {
      if (alert.id == alertId) {
        return alert.copyWith(status: newStatus);
      }
      return alert;
    }).toList();

    // Update active alerts
    _activeAlerts.value = _alerts.value
        .where((alert) => alert.status == AlertStatus.active)
        .toList();
  }

  /// Refresh safety data
  Future<void> refresh() async {
    await loadAlerts();
  }

  @override
  void dispose() {
    _alerts.dispose();
    _activeAlerts.dispose();
    _emergencyMode.dispose();
    _emergencyLocation.dispose();
    super.dispose();
  }
}

/// Provider for SafetyController
final safetyControllerProvider =
    StateNotifierProvider<SafetyController, AsyncValue<void>>((ref) {
  final safetyRepository = ref.read(safetyRepositoryProvider);
  return SafetyController(safetyRepository: safetyRepository);
});

/// Provider for SafetyRepository
final safetyRepositoryProvider = Provider<SafetyRepository>((ref) {
  return SafetyRepository();
});

/// Provider for safety alerts
final safetyAlertsProvider = Provider<List<SafetyAlertModel>>((ref) {
  final controller = ref.watch(safetyControllerProvider.notifier);
  return controller.alerts;
});

/// Provider for active alerts
final activeAlertsProvider = Provider<List<SafetyAlertModel>>((ref) {
  final controller = ref.watch(safetyControllerProvider.notifier);
  return controller.activeAlerts;
});

/// Provider for emergency mode
final emergencyModeProvider = Provider<bool>((ref) {
  final controller = ref.watch(safetyControllerProvider.notifier);
  return controller.emergencyMode;
});
