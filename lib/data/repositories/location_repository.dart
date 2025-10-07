import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/location_model.dart';

/// Repository for location-related operations
class LocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save location
  Future<void> saveLocation(LocationModel location) async {
    try {
      await _firestore.collection('locations').add(location.toJson());
    } catch (e) {
      throw Exception('Failed to save location: $e');
    }
  }

  /// Get locations by user ID
  Future<List<LocationModel>> getLocationsByUser(String userId) async {
    try {
      final query = await _firestore
          .collection('locations')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs
          .map((doc) => LocationModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user locations: $e');
    }
  }

  /// Get current location by user ID
  Future<LocationModel?> getCurrentLocation(String userId) async {
    try {
      final query = await _firestore
          .collection('locations')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return LocationModel.fromJson({
          'id': query.docs.first.id,
          ...query.docs.first.data(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  /// Update location
  Future<void> updateLocation(String locationId, LocationModel location) async {
    try {
      await _firestore
          .collection('locations')
          .doc(locationId)
          .update(location.toJson());
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  /// Delete location
  Future<void> deleteLocation(String locationId) async {
    try {
      await _firestore.collection('locations').doc(locationId).delete();
    } catch (e) {
      throw Exception('Failed to delete location: $e');
    }
  }

  /// Get nearby locations
  Future<List<LocationModel>> getNearbyLocations(
      double latitude, double longitude,
      {double radiusKm = 5.0}) async {
    try {
      // For simplicity, get all locations and filter by distance
      // In a real app, you'd use a geospatial query
      final query = await _firestore.collection('locations').get();

      final locations = query.docs
          .map((doc) => LocationModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Filter by distance
      final nearbyLocations = <LocationModel>[];
      final center = LocationModel(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
      );

      for (final location in locations) {
        final distance = center.distanceTo(location);
        if (distance <= radiusKm * 1000) {
          // Convert km to meters
          nearbyLocations.add(location);
        }
      }

      return nearbyLocations;
    } catch (e) {
      throw Exception('Failed to get nearby locations: $e');
    }
  }

  /// Get location history for a user
  Future<List<LocationModel>> getLocationHistory(String userId,
      {DateTime? startDate, DateTime? endDate, int limit = 100}) async {
    try {
      Query query = _firestore
          .collection('locations')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true);

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      query = query.limit(limit);

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => LocationModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get location history: $e');
    }
  }

  /// Track location updates
  Stream<LocationModel?> trackLocation(String userId) {
    return _firestore
        .collection('locations')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return LocationModel.fromJson({
          'id': snapshot.docs.first.id,
          ...snapshot.docs.first.data(),
        });
      }
      return null;
    });
  }

  /// Batch save locations
  Future<void> saveLocations(List<LocationModel> locations) async {
    try {
      final batch = _firestore.batch();

      for (final location in locations) {
        final docRef = _firestore.collection('locations').doc();
        batch.set(docRef, location.toJson());
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to save locations: $e');
    }
  }

  /// Clear old locations (cleanup)
  Future<void> clearOldLocations({int daysOld = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final query = await _firestore
          .collection('locations')
          .where('timestamp', isLessThan: cutoffDate)
          .get();

      final batch = _firestore.batch();

      for (final doc in query.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear old locations: $e');
    }
  }
}
