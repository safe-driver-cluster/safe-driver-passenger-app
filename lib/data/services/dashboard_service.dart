import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class DashboardService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get user profile data
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firebaseService.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firebaseService.firestore.collection('users').doc(user.id).update({
        ...user.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Get user's travel history
  Future<List<Map<String, dynamic>>> getTravelHistory(String userId) async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('travels')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get travel history: $e');
    }
  }

  /// Submit feedback
  Future<void> submitFeedback({
    required String userId,
    required String driverId,
    required String busId,
    required double rating,
    required String comment,
  }) async {
    try {
      await _firebaseService.firestore.collection('feedback').add({
        'userId': userId,
        'driverId': driverId,
        'busId': busId,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  /// Get nearby buses
  Future<List<Map<String, dynamic>>> getNearbyBuses({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      // Note: For production, you'd use GeoFirestore for proper geo queries
      // This is a simplified version
      final querySnapshot = await _firebaseService.firestore
          .collection('buses')
          .where('isActive', isEqualTo: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get nearby buses: $e');
    }
  }

  /// Get safety alerts
  Future<List<Map<String, dynamic>>> getSafetyAlerts() async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('safety_alerts')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to get safety alerts: $e');
    }
  }

  /// Stream user profile for real-time updates
  Stream<UserModel?> getUserProfileStream(String userId) {
    return _firebaseService.firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Stream safety alerts for real-time updates
  Stream<List<Map<String, dynamic>>> getSafetyAlertsStream() {
    return _firebaseService.firestore
        .collection('safety_alerts')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList());
  }
}
