import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver_model.dart';
import '../models/safety_incident_model.dart';

class DriverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get driver by ID
  Future<DriverModel?> getDriverById(String driverId) async {
    try {
      final doc = await _firestore.collection('drivers').doc(driverId).get();
      if (doc.exists) {
        return DriverModel.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get driver: $e');
    }
  }

  // Get all drivers
  Future<List<DriverModel>> getAllDrivers() async {
    try {
      final querySnapshot = await _firestore.collection('drivers').get();
      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get drivers: $e');
    }
  }

  // Search drivers
  Future<List<DriverModel>> searchDrivers(String query) async {
    try {
      final querySnapshot = await _firestore.collection('drivers').get();
      final drivers = querySnapshot.docs
          .map((doc) => DriverModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      return drivers.where((driver) {
        return driver.name.toLowerCase().contains(query.toLowerCase()) ||
            driver.licenseNumber.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search drivers: $e');
    }
  }

  // Get driver performance history
  Future<List<DriverPerformance>> getDriverPerformanceHistory(
      String driverId) async {
    try {
      final querySnapshot = await _firestore
          .collection('driverPerformance')
          .where('driverId', isEqualTo: driverId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverPerformance.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get driver performance: $e');
    }
  }

  // Get driver safety incidents
  Future<List<SafetyIncident>> getDriverIncidents(String driverId) async {
    try {
      final querySnapshot = await _firestore
          .collection('safetyIncidents')
          .where('driverId', isEqualTo: driverId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => SafetyIncident.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get driver incidents: $e');
    }
  }

  // Get top performing drivers
  Future<List<DriverModel>> getTopPerformingDrivers({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection('drivers')
          .orderBy('safetyScore', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get top drivers: $e');
    }
  }

  // Update driver status
  Future<void> updateDriverStatus(String driverId, DriverStatus status) async {
    try {
      await _firestore.collection('drivers').doc(driverId).update({
        'status': status.toString().split('.').last,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update driver status: $e');
    }
  }

  // Update driver alertness level
  Future<void> updateDriverAlertness(
      String driverId, AlertnessLevel level) async {
    try {
      await _firestore.collection('drivers').doc(driverId).update({
        'alertnessLevel': level.toString().split('.').last,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update driver alertness: $e');
    }
  }

  // Get driver by bus ID
  Future<DriverModel?> getDriverByBusId(String busId) async {
    try {
      final querySnapshot = await _firestore
          .collection('drivers')
          .where('assignedBuses', arrayContains: busId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return DriverModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get driver by bus: $e');
    }
  }

  // Add driver performance record
  Future<void> addDriverPerformance(
      String driverId, DriverPerformance performance) async {
    try {
      await _firestore.collection('driverPerformance').add({
        'driverId': driverId,
        ...performance.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to add driver performance: $e');
    }
  }

  // Add safety incident
  Future<void> addSafetyIncident(
      String driverId, SafetyIncident incident) async {
    try {
      await _firestore.collection('safetyIncidents').add({
        'driverId': driverId,
        ...incident.toJson(),
      });
    } catch (e) {
      throw Exception('Failed to add safety incident: $e');
    }
  }

  // Missing methods needed by driver_controller

  /// Get available drivers
  Future<List<DriverModel>> getAvailableDrivers() async {
    try {
      final querySnapshot = await _firestore
          .collection('drivers')
          .where('status',
              isEqualTo: DriverStatus.available.toString().split('.').last)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get available drivers: $e');
    }
  }

  /// Get drivers by bus
  Future<List<DriverModel>> getDriversByBus(String busId) async {
    try {
      final querySnapshot = await _firestore
          .collection('drivers')
          .where('currentBusId', isEqualTo: busId)
          .get();

      return querySnapshot.docs
          .map((doc) => DriverModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get drivers by bus: $e');
    }
  }

  /// Get driver performance
  Future<DriverPerformance?> getDriverPerformance(String driverId) async {
    try {
      final driver = await getDriverById(driverId);
      return driver?.performance;
    } catch (e) {
      throw Exception('Failed to get driver performance: $e');
    }
  }
}
