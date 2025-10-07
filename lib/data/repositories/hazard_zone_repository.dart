import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../models/hazard_zone_model.dart';

class HazardZoneRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all active hazard zones
  Future<List<HazardZone>> getAllActiveHazardZones() async {
    try {
      final querySnapshot = await _firestore
          .collection('hazardZones')
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HazardZone.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hazard zones: $e');
    }
  }

  // Get hazard zones near location
  Future<List<HazardZone>> getHazardZonesNearLocation(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    try {
      final allHazards = await getAllActiveHazardZones();
      final nearbyHazards = <HazardZone>[];

      for (final hazard in allHazards) {
        if (hazard.coordinates.isNotEmpty) {
          final hazardLat = hazard.coordinates.first.latitude;
          final hazardLng = hazard.coordinates.first.longitude;

          final distance = geo.Geolocator.distanceBetween(
            latitude,
            longitude,
            hazardLat,
            hazardLng,
          );

          // Convert distance to kilometers
          final distanceKm = distance / 1000;

          if (distanceKm <= radiusKm) {
            nearbyHazards.add(hazard);
          }
        }
      }

      // Sort by distance
      nearbyHazards.sort((a, b) {
        final distanceA = geo.Geolocator.distanceBetween(
          latitude,
          longitude,
          a.coordinates.first.latitude,
          a.coordinates.first.longitude,
        );
        final distanceB = geo.Geolocator.distanceBetween(
          latitude,
          longitude,
          b.coordinates.first.latitude,
          b.coordinates.first.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return nearbyHazards;
    } catch (e) {
      throw Exception('Failed to get nearby hazard zones: $e');
    }
  }

  // Create new hazard zone
  Future<void> createHazardZone(HazardZone hazardZone) async {
    try {
      await _firestore
          .collection('hazardZones')
          .doc(hazardZone.id)
          .set(hazardZone.toJson());
    } catch (e) {
      throw Exception('Failed to create hazard zone: $e');
    }
  }

  // Update hazard zone
  Future<void> updateHazardZone(HazardZone hazardZone) async {
    try {
      await _firestore
          .collection('hazardZones')
          .doc(hazardZone.id)
          .update(hazardZone.toJson());
    } catch (e) {
      throw Exception('Failed to update hazard zone: $e');
    }
  }

  // Delete hazard zone (set inactive)
  Future<void> deactivateHazardZone(String hazardZoneId) async {
    try {
      await _firestore.collection('hazardZones').doc(hazardZoneId).update({
        'isActive': false,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to deactivate hazard zone: $e');
    }
  }

  // Get hazard zone by ID
  Future<HazardZone?> getHazardZoneById(String hazardZoneId) async {
    try {
      final doc =
          await _firestore.collection('hazardZones').doc(hazardZoneId).get();

      if (doc.exists) {
        return HazardZone.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get hazard zone: $e');
    }
  }

  // Stream hazard zones for real-time updates
  Stream<List<HazardZone>> streamActiveHazardZones() {
    return _firestore
        .collection('hazardZones')
        .where('isActive', isEqualTo: true)
        .orderBy('severity', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => HazardZone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  // Get hazard alerts for driver
  Future<List<HazardAlert>> getHazardAlertsForDriver(String driverId) async {
    try {
      final querySnapshot = await _firestore
          .collection('hazardAlerts')
          .where('driverId', isEqualTo: driverId)
          .where('isAcknowledged', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HazardAlert.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hazard alerts: $e');
    }
  }

  // Create hazard alert
  Future<void> createHazardAlert(HazardAlert alert) async {
    try {
      await _firestore
          .collection('hazardAlerts')
          .doc(alert.id)
          .set(alert.toJson());
    } catch (e) {
      throw Exception('Failed to create hazard alert: $e');
    }
  }

  // Acknowledge hazard alert
  Future<void> acknowledgeHazardAlert(String alertId) async {
    try {
      await _firestore.collection('hazardAlerts').doc(alertId).update({
        'isAcknowledged': true,
        'acknowledgedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to acknowledge hazard alert: $e');
    }
  }

  // Check if location is in hazard zone
  bool isLocationInHazardZone(
    double latitude,
    double longitude,
    HazardZone hazardZone,
  ) {
    if (hazardZone.coordinates.isEmpty) return false;

    // For single point hazards, check if within radius
    if (hazardZone.coordinates.length == 1) {
      final distance = geo.Geolocator.distanceBetween(
        latitude,
        longitude,
        hazardZone.coordinates.first.latitude,
        hazardZone.coordinates.first.longitude,
      );
      return distance <= hazardZone.radius;
    }

    // For polygon hazards, use point-in-polygon algorithm
    return _isPointInPolygon(
      latitude,
      longitude,
      hazardZone.coordinates,
    );
  }

  // Point in polygon algorithm (ray casting)
  bool _isPointInPolygon(
    double latitude,
    double longitude,
    List<GeoPoint> polygon,
  ) {
    int intersections = 0;
    final int n = polygon.length;

    for (int i = 0, j = n - 1; i < n; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;
      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      if (((yi > latitude) != (yj > latitude)) &&
          (longitude < (xj - xi) * (latitude - yi) / (yj - yi) + xi)) {
        intersections++;
      }
    }

    return intersections % 2 != 0;
  }

  // Get hazard zones by type
  Future<List<HazardZone>> getHazardZonesByType(HazardType type) async {
    try {
      final querySnapshot = await _firestore
          .collection('hazardZones')
          .where('type', isEqualTo: type.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HazardZone.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hazard zones by type: $e');
    }
  }

  // Get hazard zones by severity
  Future<List<HazardZone>> getHazardZonesBySeverity(
      SeverityLevel severity) async {
    try {
      final querySnapshot = await _firestore
          .collection('hazardZones')
          .where('severity', isEqualTo: severity.toString().split('.').last)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => HazardZone.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get hazard zones by severity: $e');
    }
  }
}
