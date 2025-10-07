import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/firebase_service.dart';
import '../models/bus_model.dart';

class BusRepository {
  final FirebaseService _firebaseService;
  final String _collection = 'buses';

  BusRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  /// Get bus by ID
  Future<BusModel?> getBusById(String busId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection(_collection)
          .doc(busId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return BusModel.fromJson({...data, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw BusRepositoryException('Failed to get bus: $e');
    }
  }

  /// Get nearby buses within a radius
  Future<List<BusModel>> getNearbyBuses(double latitude, double longitude,
      {double radiusKm = 5.0}) async {
    try {
      // For now, get all active buses and filter by distance
      // In a real app, you'd use a geospatial query or service like GeoFirestore
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('status', whereIn: ['online', 'inTransit'])
          .limit(50)
          .get();

      final buses = query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter by distance (simplified calculation)
      return buses.where((bus) {
        if (bus.currentLocation == null) return false;

        final distance = _calculateDistance(
          latitude,
          longitude,
          bus.currentLocation!.latitude,
          bus.currentLocation!.longitude,
        );

        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      throw BusRepositoryException('Failed to get nearby buses: $e');
    }
  }

  /// Get buses by route
  Future<List<BusModel>> getBusesByRoute(String routeNumber) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('routeNumber', isEqualTo: routeNumber)
          .where('isActive', isEqualTo: true)
          .get();

      return query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw BusRepositoryException('Failed to get buses by route: $e');
    }
  }

  /// Get bus stream for real-time updates
  Stream<BusModel?> getBusStream(String busId) {
    return _firebaseService.firestore
        .collection(_collection)
        .doc(busId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return BusModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }

  /// Get buses stream with real-time updates
  Stream<List<BusModel>> getBusesStream({
    String? routeNumber,
    int limit = 20,
  }) {
    Query query = _firebaseService.firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true);

    if (routeNumber != null) {
      query = query.where('routeNumber', isEqualTo: routeNumber);
    }

    query = query.orderBy('lastUpdated', descending: true).limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BusModel.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  /// Search buses by number
  Future<List<BusModel>> searchBusesByNumber(String busNumber) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('busNumber', isGreaterThanOrEqualTo: busNumber)
          .where('busNumber', isLessThanOrEqualTo: '$busNumber\uf8ff')
          .limit(20)
          .get();

      return query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw BusRepositoryException('Failed to search buses: $e');
    }
  }

  /// Get bus location history
  Future<List<Map<String, dynamic>>> getBusLocationHistory(
    String busId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final query = await _firebaseService.firestore
          .collection('bus_locations')
          .where('busId', isEqualTo: busId)
          .where('timestamp',
              isGreaterThanOrEqualTo: startTime.toIso8601String())
          .where('timestamp', isLessThanOrEqualTo: endTime.toIso8601String())
          .orderBy('timestamp')
          .get();

      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw BusRepositoryException('Failed to get location history: $e');
    }
  }

  /// Update bus location
  Future<void> updateBusLocation(
      String busId, double latitude, double longitude,
      {double? speed, double? heading}) async {
    try {
      await _firebaseService.updateDocument(_collection, busId, {
        'currentLocation': {
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'currentSpeed': speed,
        'heading': heading,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw BusRepositoryException('Failed to update bus location: $e');
    }
  }

  /// Update bus status
  Future<void> updateBusStatus(String busId, String status) async {
    try {
      await _firebaseService.updateDocument(_collection, busId, {
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw BusRepositoryException('Failed to update bus status: $e');
    }
  }

  /// Get buses by driver
  Future<List<BusModel>> getBusesByDriver(String driverId) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .get();

      return query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw BusRepositoryException('Failed to get buses by driver: $e');
    }
  }

  /// Get bus statistics
  Future<Map<String, dynamic>> getBusStatistics() async {
    try {
      final totalQuery =
          await _firebaseService.firestore.collection(_collection).get();

      final activeQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      final onlineQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('status', isEqualTo: 'online')
          .get();

      return {
        'total': totalQuery.docs.length,
        'active': activeQuery.docs.length,
        'online': onlineQuery.docs.length,
      };
    } catch (e) {
      throw BusRepositoryException('Failed to get bus statistics: $e');
    }
  }

  /// Calculate distance between two points (Haversine formula)
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Get all buses
  Future<List<BusModel>> getAllBuses() async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .orderBy('busNumber')
          .get();

      return query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw BusRepositoryException('Failed to get all buses: $e');
    }
  }

  /// Get active journey for a user
  Future<BusModel?> getActiveJourney(String userId) async {
    try {
      final query = await _firebaseService.firestore
          .collection('journeys')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final journeyData = query.docs.first.data();
        final busId = journeyData['busId'] as String?;

        if (busId != null) {
          return await getBusById(busId);
        }
      }
      return null;
    } catch (e) {
      throw BusRepositoryException('Failed to get active journey: $e');
    }
  }

  /// Get bus by QR code
  Future<BusModel?> getBusByQrCode(String qrCode) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('qrCode', isEqualTo: qrCode)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        return BusModel.fromJson({...doc.data(), 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw BusRepositoryException('Failed to get bus by QR code: $e');
    }
  }

  /// Get bus location stream for real-time tracking
  Stream<BusModel?> getBusLocationStream(String busId) {
    return _firebaseService.firestore
        .collection(_collection)
        .doc(busId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return BusModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }
}

// Custom exception class
class BusRepositoryException implements Exception {
  final String message;
  BusRepositoryException(this.message);

  @override
  String toString() => 'BusRepositoryException: $message';
}
