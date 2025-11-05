import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/firebase_service.dart';
import '../models/bus_model.dart';
import '../models/feedback_model.dart';
import '../models/safety_alert_model.dart';
import '../models/user_model.dart';

/// Comprehensive data service that integrates all Firebase operations
/// Replaces hardcoded data with real Firebase data
class FirebaseDataService {
  final FirebaseService _firebaseService;
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  FirebaseDataService({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  /// Check if cached data is still valid
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Get cached data or null if expired
  T? _getCachedData<T>(String key) {
    if (_isCacheValid(key)) {
      return _cache[key] as T?;
    }
    return null;
  }

  /// Cache data with timestamp
  void _cacheData(String key, dynamic data) {
    _cache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  // ============ USER DATA ============

  /// Get user profile with preferences and stats
  Future<UserModel?> getUserProfile(String userId) async {
    final cacheKey = 'user_$userId';
    final cached = _getCachedData<UserModel>(cacheKey);
    if (cached != null) return cached;

    try {
      final doc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final user = UserModel.fromFirestore(doc);
        _cacheData(cacheKey, user);
        return user;
      }
      return null;
    } catch (e) {
      throw FirebaseDataException('Failed to get user profile: $e');
    }
  }

  /// Update user statistics (trips, carbon saved, points)
  Future<void> updateUserStats(
    String userId, {
    int? todayTrips,
    double? carbonSaved,
    int? pointsEarned,
    double? safetyScore,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (todayTrips != null) updateData['stats.todayTrips'] = todayTrips;
      if (carbonSaved != null) updateData['stats.carbonSaved'] = carbonSaved;
      if (pointsEarned != null) updateData['stats.pointsEarned'] = pointsEarned;
      if (safetyScore != null) updateData['stats.safetyScore'] = safetyScore;

      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .update(updateData);

      // Invalidate cache
      _cache.remove('user_$userId');
      _cacheTimestamps.remove('user_$userId');
    } catch (e) {
      throw FirebaseDataException('Failed to update user stats: $e');
    }
  }

  // ============ BUS DATA ============

  /// Get nearby buses with real-time location data
  Future<List<BusModel>> getNearbyBuses(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    try {
      // Get active buses (in production, use geospatial queries for better performance)
      final query = await _firebaseService.firestore
          .collection('buses')
          .where('isActive', isEqualTo: true)
          .where('status', whereIn: ['online', 'inTransit', 'atStop'])
          .orderBy('lastUpdated', descending: true)
          .limit(limit * 2) // Get more to filter by distance
          .get();

      final buses = query.docs
          .map((doc) => BusModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Filter by distance (Haversine formula)
      final nearbyBuses = buses
          .where((bus) {
            if (bus.currentLocation == null) return false;

            final distance = _calculateDistance(
              latitude,
              longitude,
              bus.currentLocation!.latitude,
              bus.currentLocation!.longitude,
            );

            return distance <= radiusKm;
          })
          .take(limit)
          .toList();

      return nearbyBuses;
    } catch (e) {
      throw FirebaseDataException('Failed to get nearby buses: $e');
    }
  }

  /// Get bus details by ID
  Future<BusModel?> getBusById(String busId) async {
    final cacheKey = 'bus_$busId';
    final cached = _getCachedData<BusModel>(cacheKey);
    if (cached != null) return cached;

    try {
      final doc =
          await _firebaseService.firestore.collection('buses').doc(busId).get();

      if (doc.exists) {
        final bus = BusModel.fromJson({...doc.data()!, 'id': doc.id});
        _cacheData(cacheKey, bus);
        return bus;
      }
      return null;
    } catch (e) {
      throw FirebaseDataException('Failed to get bus details: $e');
    }
  }

  /// Listen to real-time bus location updates
  Stream<BusModel> listenToBusUpdates(String busId) {
    return _firebaseService.firestore
        .collection('buses')
        .doc(busId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return BusModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      throw FirebaseDataException('Bus not found');
    });
  }

  // ============ SAFETY ALERTS ============

  /// Get active safety alerts for user
  Future<List<SafetyAlertModel>> getActiveSafetyAlerts({
    String? userId,
    String? busId,
    List<String>? favoriteRoutes,
    int limit = 10,
  }) async {
    try {
      Query query = _firebaseService.firestore
          .collection('safety_alerts')
          .where('status', whereIn: ['active', 'acknowledged', 'inProgress'])
          .orderBy('priority', descending: true)
          .orderBy('createdAt', descending: true);

      final querySnapshot = await query.limit(limit * 2).get();

      List<SafetyAlertModel> alerts = querySnapshot.docs
          .map((doc) => SafetyAlertModel.fromJson(
              {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      // Filter for user relevance
      if (userId != null || busId != null || favoriteRoutes != null) {
        alerts = alerts.where((alert) {
          // Include if user is affected
          if (userId != null && alert.affectedUsers.contains(userId))
            return true;

          // Include if alert is for current bus
          if (busId != null && alert.busId == busId) return true;

          // Include if alert is for favorite routes
          if (favoriteRoutes != null &&
              alert.routeId != null &&
              favoriteRoutes.contains(alert.routeId)) return true;

          // Include high priority alerts
          if (alert.severity >= 4) return true;

          return false;
        }).toList();
      }

      return alerts.take(limit).toList();
    } catch (e) {
      throw FirebaseDataException('Failed to get safety alerts: $e');
    }
  }

  /// Listen to real-time safety alerts
  Stream<List<SafetyAlertModel>> listenToSafetyAlerts({
    String? busId,
    String? routeId,
  }) {
    Query query = _firebaseService.firestore
        .collection('safety_alerts')
        .where('status', whereIn: ['active', 'acknowledged'])
        .orderBy('priority', descending: true)
        .orderBy('createdAt', descending: true);

    if (busId != null) {
      query = query.where('busId', isEqualTo: busId);
    }

    if (routeId != null) {
      query = query.where('routeId', isEqualTo: routeId);
    }

    return query.limit(20).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SafetyAlertModel.fromJson(
              {...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    });
  }

  // ============ USER ACTIVITY ============

  /// Get user's recent activity (journeys, feedback, etc.)
  Future<List<String>> getUserRecentActivity(String userId,
      {int limit = 10}) async {
    try {
      final activities = <String>[];

      // Get recent journeys
      final journeysQuery = await _firebaseService.firestore
          .collection('journeys')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      // Process journeys
      for (var doc in journeysQuery.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'unknown';
        final busNumber = data['busNumber'] ?? 'Unknown Bus';
        final routeNumber = data['routeNumber'] ?? 'Unknown Route';
        final timestamp = (data['createdAt'] as Timestamp?)?.toDate();
        final timeAgo = timestamp != null ? _getTimeAgo(timestamp) : '';

        if (status == 'completed') {
          activities.add(
              'Completed journey on $busNumber - Route $routeNumber $timeAgo');
        } else if (status == 'ongoing') {
          activities.add('Currently on $busNumber - Route $routeNumber');
        }
      }

      // Get recent feedback
      final feedbackQuery = await _firebaseService.firestore
          .collection('feedback')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(3)
          .get();

      // Process feedback
      for (var doc in feedbackQuery.docs) {
        final data = doc.data();
        final rating = data['rating']?['overall'] ?? 0;
        final busNumber = data['busNumber'] ?? 'Bus';
        final timestamp = (data['createdAt'] as Timestamp?)?.toDate();
        final timeAgo = timestamp != null ? _getTimeAgo(timestamp) : '';
        activities.add('Rated $busNumber: $rating/5 stars $timeAgo');
      }

      // If no activities, show welcome messages
      if (activities.isEmpty) {
        activities.addAll([
          'Welcome to SafeDriver!',
          'Start your first journey by searching for buses',
          'Scan QR codes on buses for quick access',
        ]);
      }

      return activities.take(limit).toList();
    } catch (e) {
      throw FirebaseDataException('Failed to get user activity: $e');
    }
  }

  // ============ DASHBOARD DATA ============

  /// Get comprehensive dashboard data for user
  Future<Map<String, dynamic>> getDashboardData(String userId) async {
    try {
      final futures = await Future.wait([
        getUserProfile(userId),
        getActiveSafetyAlerts(userId: userId, limit: 5),
        getUserRecentActivity(userId, limit: 5),
        _getFleetStatistics(),
      ]);

      final user = futures[0] as UserModel?;
      final alerts = futures[1] as List<SafetyAlertModel>;
      final activities = futures[2] as List<String>;
      final fleetStats = futures[3] as Map<String, dynamic>;

      return {
        'user': user,
        'safetyAlerts': alerts,
        'recentActivity': activities,
        'fleetStats': fleetStats,
        'timestamp': DateTime.now(),
      };
    } catch (e) {
      throw FirebaseDataException('Failed to get dashboard data: $e');
    }
  }

  /// Get fleet statistics for dashboard
  Future<Map<String, dynamic>> _getFleetStatistics() async {
    const cacheKey = 'fleet_stats';
    final cached = _getCachedData<Map<String, dynamic>>(cacheKey);
    if (cached != null) return cached;

    try {
      // Get bus statistics
      final busesQuery = await _firebaseService.firestore
          .collection('buses')
          .where('isActive', isEqualTo: true)
          .get();

      final totalBuses = busesQuery.docs.length;
      final activeBuses = busesQuery.docs.where((doc) {
        final status = doc.data()['status'] as String?;
        return status == 'online' || status == 'inTransit';
      }).length;

      // Calculate average safety score
      double totalSafetyScore = 0;
      for (var doc in busesQuery.docs) {
        totalSafetyScore +=
            (doc.data()['safetyScore'] as num?)?.toDouble() ?? 0;
      }
      final avgSafetyScore =
          totalBuses > 0 ? totalSafetyScore / totalBuses : 0.0;

      // Get active incidents count
      final incidentsQuery = await _firebaseService.firestore
          .collection('safety_alerts')
          .where('status', whereIn: ['active', 'acknowledged'])
          .where('severity', isGreaterThanOrEqualTo: 3)
          .get();

      final stats = {
        'totalBuses': totalBuses,
        'activeBuses': activeBuses,
        'fleetSafetyScore': avgSafetyScore,
        'activeIncidents': incidentsQuery.docs.length,
      };

      _cacheData(cacheKey, stats);
      return stats;
    } catch (e) {
      throw FirebaseDataException('Failed to get fleet statistics: $e');
    }
  }

  // ============ HELPER METHODS ============

  /// Calculate distance between two points using Haversine formula
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in km

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);

    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * (Math.pi / 180);

  /// Get human readable time ago string
  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Clear all cached data
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// Clear specific cache entry
  void clearCacheEntry(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }
}

/// Custom exception for Firebase data operations
class FirebaseDataException implements Exception {
  final String message;
  FirebaseDataException(this.message);

  @override
  String toString() => 'FirebaseDataException: $message';
}

/// Provider for FirebaseDataService
final firebaseDataServiceProvider = Provider<FirebaseDataService>((ref) {
  return FirebaseDataService();
});
