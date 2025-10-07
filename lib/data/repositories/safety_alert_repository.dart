import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/firebase_service.dart';
import '../models/safety_alert_model.dart';

class SafetyAlertRepository {
  final FirebaseService _firebaseService;
  final String _collection = 'safety_alerts';

  SafetyAlertRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  /// Get safety alert by ID
  Future<SafetyAlertModel?> getSafetyAlertById(String alertId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(_collection)
          .doc(alertId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return SafetyAlertModel.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw SafetyAlertRepositoryException('Failed to get safety alert: $e');
    }
  }

  /// Get active safety alerts
  Stream<List<SafetyAlertModel>> getActiveSafetyAlerts() {
    try {
      return _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('expiresAt', isGreaterThan: Timestamp.now())
          .orderBy('expiresAt')
          .orderBy('severity', descending: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return SafetyAlertModel.fromJson({...data, 'id': doc.id});
        }).toList();
      });
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get active safety alerts: $e');
    }
  }

  /// Get safety alerts by location (within radius)
  Future<List<SafetyAlertModel>> getSafetyAlertsByLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      // Calculate bounds for geospatial query
      final bounds = _calculateGeoBounds(latitude, longitude, radiusKm);

      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('location.latitude', isGreaterThanOrEqualTo: bounds['minLat'])
          .where('location.latitude', isLessThanOrEqualTo: bounds['maxLat'])
          .where('location.longitude', isGreaterThanOrEqualTo: bounds['minLng'])
          .where('location.longitude', isLessThanOrEqualTo: bounds['maxLng'])
          .get();

      final alerts = query.docs
          .map((doc) {
            final data = doc.data();
            return SafetyAlertModel.fromJson({...data, 'id': doc.id});
          })
          .where((alert) =>
              alert.location != null) // Filter out alerts without location
          .where((alert) {
            // Filter by exact radius
            final distance = _calculateDistance(
              latitude,
              longitude,
              alert.location!.latitude,
              alert.location!.longitude,
            );
            return distance <= radiusKm;
          })
          .toList();

      // Sort by distance
      alerts.sort((a, b) {
        final distanceA = _calculateDistance(
          latitude,
          longitude,
          a.location!.latitude,
          a.location!.longitude,
        );
        final distanceB = _calculateDistance(
          latitude,
          longitude,
          b.location!.latitude,
          b.location!.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return alerts;
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get safety alerts by location: $e');
    }
  }

  /// Get safety alerts by severity
  Future<List<SafetyAlertModel>> getSafetyAlertsBySeverity(
      String severity) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('severity', isEqualTo: severity)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return SafetyAlertModel.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get safety alerts by severity: $e');
    }
  }

  /// Create a new safety alert
  Future<String> createSafetyAlert(SafetyAlertModel alert) async {
    try {
      final alertData = alert.toJson();
      alertData.remove('id'); // Remove ID as it will be auto-generated

      final docRef = await _firebaseService.firestore
          .collection(_collection)
          .add(alertData);

      return docRef.id;
    } catch (e) {
      throw SafetyAlertRepositoryException('Failed to create safety alert: $e');
    }
  }

  /// Update safety alert
  Future<void> updateSafetyAlert(
      String alertId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.now();

      await _firebaseService.firestore
          .collection(_collection)
          .doc(alertId)
          .update(updates);
    } catch (e) {
      throw SafetyAlertRepositoryException('Failed to update safety alert: $e');
    }
  }

  /// Deactivate safety alert
  Future<void> deactivateSafetyAlert(String alertId) async {
    try {
      await updateSafetyAlert(alertId, {
        'isActive': false,
        'resolvedAt': Timestamp.now(),
      });
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to deactivate safety alert: $e');
    }
  }

  /// Delete safety alert
  Future<void> deleteSafetyAlert(String alertId) async {
    try {
      await _firebaseService.firestore
          .collection(_collection)
          .doc(alertId)
          .delete();
    } catch (e) {
      throw SafetyAlertRepositoryException('Failed to delete safety alert: $e');
    }
  }

  /// Get safety alerts created by user
  Future<List<SafetyAlertModel>> getUserSafetyAlerts(String userId) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('reportedBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return SafetyAlertModel.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get user safety alerts: $e');
    }
  }

  /// Get safety alerts by type
  Future<List<SafetyAlertModel>> getSafetyAlertsByType(String alertType) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('type', isEqualTo: alertType)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) {
        final data = doc.data();
        return SafetyAlertModel.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get safety alerts by type: $e');
    }
  }

  /// Mark safety alert as acknowledged by user
  Future<void> acknowledgeSafetyAlert(String alertId, String userId) async {
    try {
      await _firebaseService.firestore
          .collection(_collection)
          .doc(alertId)
          .update({
        'acknowledgedBy': FieldValue.arrayUnion([userId]),
        'acknowledgedAt': Timestamp.now(),
      });
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to acknowledge safety alert: $e');
    }
  }

  /// Get safety alert statistics
  Future<Map<String, dynamic>> getSafetyAlertStats() async {
    try {
      final now = Timestamp.now();
      final oneWeekAgo = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 7)),
      );

      // Get total active alerts
      final activeQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      // Get alerts from last week
      final weeklyQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: oneWeekAgo)
          .get();

      // Get alerts by severity
      final criticalQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('severity', isEqualTo: 'critical')
          .where('isActive', isEqualTo: true)
          .get();

      final highQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('severity', isEqualTo: 'high')
          .where('isActive', isEqualTo: true)
          .get();

      return {
        'totalActive': activeQuery.docs.length,
        'weeklyAlerts': weeklyQuery.docs.length,
        'criticalAlerts': criticalQuery.docs.length,
        'highAlerts': highQuery.docs.length,
        'lastUpdated': now,
      };
    } catch (e) {
      throw SafetyAlertRepositoryException(
          'Failed to get safety alert stats: $e');
    }
  }

  /// Helper method to calculate geographic bounds
  Map<String, double> _calculateGeoBounds(
      double lat, double lng, double radiusKm) {
    final double latRadian = lat * (pi / 180);
    const double degLatKm = 110.54; // Approximate km per degree latitude
    final double degLngKm =
        111.32 * cos(latRadian); // Approximate km per degree longitude

    final double deltaLat = radiusKm / degLatKm;
    final double deltaLng = radiusKm / degLngKm;

    return {
      'minLat': lat - deltaLat,
      'maxLat': lat + deltaLat,
      'minLng': lng - deltaLng,
      'maxLng': lng + deltaLng,
    };
  }

  /// Helper method to calculate distance between two points
  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Helper method to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}

// Custom exception class
class SafetyAlertRepositoryException implements Exception {
  final String message;
  SafetyAlertRepositoryException(this.message);

  @override
  String toString() => 'SafetyAlertRepositoryException: $message';
}
