import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/safety_alert_model.dart';

class SafetyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get recent safety alerts
  Future<List<SafetyAlertModel>> getRecentAlerts({int limit = 20}) async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get safety alerts: $e');
    }
  }

  // Get active alerts
  Future<List<SafetyAlertModel>> getActiveAlerts() async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .where('isActive', isEqualTo: true)
          .orderBy('severity', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active alerts: $e');
    }
  }

  // Get alerts by bus ID
  Future<List<SafetyAlertModel>> getAlertsByBusId(String busId) async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .where('busId', isEqualTo: busId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get alerts by bus: $e');
    }
  }

  // Get alerts by driver ID
  Future<List<SafetyAlertModel>> getAlertsByDriverId(String driverId) async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .where('driverId', isEqualTo: driverId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get alerts by driver: $e');
    }
  }

  // Create new safety alert
  Future<void> createSafetyAlert(SafetyAlertModel alert) async {
    try {
      await _firestore.collection('safetyAlerts').add(alert.toJson());
    } catch (e) {
      throw Exception('Failed to create safety alert: $e');
    }
  }

  // Acknowledge alert
  Future<void> acknowledgeAlert(String alertId, String acknowledgedBy) async {
    try {
      await _firestore.collection('safetyAlerts').doc(alertId).update({
        'isAcknowledged': true,
        'acknowledgedAt': DateTime.now().toIso8601String(),
        'acknowledgedBy': acknowledgedBy,
      });
    } catch (e) {
      throw Exception('Failed to acknowledge alert: $e');
    }
  }

  // Resolve alert
  Future<void> resolveAlert(String alertId) async {
    try {
      await _firestore.collection('safetyAlerts').doc(alertId).update({
        'isActive': false,
        'resolvedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to resolve alert: $e');
    }
  }

  // Get hazard zones
  Future<List<Map<String, dynamic>>> getHazardZones() async {
    try {
      final querySnapshot = await _firestore.collection('hazardZones').get();
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get hazard zones: $e');
    }
  }

  // Get safety statistics
  Future<Map<String, dynamic>> getSafetyStatistics() async {
    try {
      final doc =
          await _firestore.collection('safetyStats').doc('current').get();
      return doc.data() ?? {};
    } catch (e) {
      throw Exception('Failed to get safety statistics: $e');
    }
  }

  // Stream safety alerts for real-time updates
  Stream<List<SafetyAlertModel>> streamActiveAlerts() {
    return _firestore
        .collection('safetyAlerts')
        .where('isActive', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SafetyAlertModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Get alerts by severity
  Future<List<SafetyAlertModel>> getAlertsBySeverity(int severity) async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .where('severity', isEqualTo: severity)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get alerts by severity: $e');
    }
  }

  // Get critical alerts
  Future<List<SafetyAlertModel>> getCriticalAlerts() async {
    return await getAlertsBySeverity(AlertSeverity.critical);
  }

  // Get emergency alerts
  Future<List<SafetyAlertModel>> getEmergencyAlerts() async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .where('type', isEqualTo: 'emergency')
          .where('isActive', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get emergency alerts: $e');
    }
  }

  // Missing methods needed by safety_controller.dart

  /// Get all alerts
  Future<List<SafetyAlertModel>> getAllAlerts() async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyAlerts')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all alerts: $e');
    }
  }

  /// Get alerts by bus ID
  Future<List<SafetyAlertModel>> getAlertsByBus(String busId) async {
    return await getAlertsByBusId(busId); // Use existing method
  }

  /// Create a new alert
  Future<void> createAlert(SafetyAlertModel alert) async {
    try {
      await _firestore
          .collection('safetyAlerts')
          .doc(alert.id)
          .set(alert.toJson());
    } catch (e) {
      throw Exception('Failed to create alert: $e');
    }
  }
}
