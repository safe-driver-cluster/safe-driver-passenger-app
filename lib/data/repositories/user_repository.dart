import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseService _firebaseService;
  final String _collection = 'users';

  UserRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  /// Create a new user
  Future<void> createUser(UserModel user) async {
    try {
      await _firebaseService.createUserDocument(user.id, user.toJson());
    } catch (e) {
      throw UserRepositoryException('Failed to create user: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firebaseService.getUserDocument(userId);
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw UserRepositoryException('Failed to get user: $e');
    }
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firebaseService.updateUserDocument(
        user.id,
        user.toJson()..remove('id'), // Remove ID from update data
      );
    } catch (e) {
      throw UserRepositoryException('Failed to update user: $e');
    }
  }

  /// Update user FCM token
  Future<void> updateUserFCMToken(String userId, String fcmToken) async {
    try {
      await _firebaseService.updateUserDocument(userId, {
        'fcmToken': fcmToken,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserRepositoryException('Failed to update FCM token: $e');
    }
  }

  /// Update user verification status
  Future<void> updateUserVerificationStatus(
      String userId, bool isVerified) async {
    try {
      await _firebaseService.updateUserDocument(userId, {
        'isVerified': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserRepositoryException('Failed to update verification status: $e');
    }
  }

  /// Update user active status
  Future<void> updateUserActiveStatus(String userId, bool isActive) async {
    try {
      await _firebaseService.updateUserDocument(userId, {
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw UserRepositoryException('Failed to update active status: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firebaseService.deleteUserData(userId);
    } catch (e) {
      throw UserRepositoryException('Failed to delete user: $e');
    }
  }

  /// Search users by email
  Future<List<UserModel>> searchUsersByEmail(String email) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('email', isEqualTo: email)
          .limit(10)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw UserRepositoryException('Failed to search users: $e');
    }
  }

  /// Search users by phone number
  Future<List<UserModel>> searchUsersByPhone(String phoneNumber) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(10)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw UserRepositoryException('Failed to search users by phone: $e');
    }
  }

  /// Get users by verification status
  Future<List<UserModel>> getUsersByVerificationStatus(bool isVerified) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('isVerified', isEqualTo: isVerified)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw UserRepositoryException('Failed to get users by verification: $e');
    }
  }

  /// Get user stream for real-time updates
  Stream<UserModel?> getUserStream(String userId) {
    return _firebaseService.getDocumentStream(_collection, userId).map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Get users stream with pagination
  Stream<List<UserModel>> getUsersStream({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) {
    Query query = _firebaseService.firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    });
  }

  /// Check if user exists by email
  Future<bool> userExistsByEmail(String email) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      throw UserRepositoryException('Failed to check user existence: $e');
    }
  }

  /// Check if user exists by phone
  Future<bool> userExistsByPhone(String phoneNumber) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      throw UserRepositoryException(
          'Failed to check user existence by phone: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, int>> getUserStatistics() async {
    try {
      final totalUsersQuery =
          await _firebaseService.firestore.collection(_collection).get();

      final verifiedUsersQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('isVerified', isEqualTo: true)
          .get();

      final activeUsersQuery = await _firebaseService.firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      return {
        'total': totalUsersQuery.docs.length,
        'verified': verifiedUsersQuery.docs.length,
        'active': activeUsersQuery.docs.length,
      };
    } catch (e) {
      throw UserRepositoryException('Failed to get user statistics: $e');
    }
  }

  /// Batch update users
  Future<void> batchUpdateUsers(List<UserModel> users) async {
    try {
      final batch = _firebaseService.firestore.batch();

      for (final user in users) {
        final docRef =
            _firebaseService.firestore.collection(_collection).doc(user.id);

        batch.update(docRef, user.toJson()..remove('id'));
      }

      await batch.commit();
    } catch (e) {
      throw UserRepositoryException('Failed to batch update users: $e');
    }
  }

  /// Get users created in date range
  Future<List<UserModel>> getUsersInDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final query = await _firebaseService.firestore
          .collection(_collection)
          .where('createdAt',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('createdAt', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw UserRepositoryException('Failed to get users in date range: $e');
    }
  }
}

// Custom exception class
class UserRepositoryException implements Exception {
  final String message;
  UserRepositoryException(this.message);

  @override
  String toString() => 'UserRepositoryException: $message';
}
