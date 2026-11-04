import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safedriver_passenger_app/data/models/notification_model.dart';

class NotificationRepository {
  static final NotificationRepository _instance =
      NotificationRepository._internal();
  factory NotificationRepository() => _instance;
  NotificationRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _notificationsCollection = 'notifications';

  /// Create a notification for a user.
  Future<String> createUserNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    NotificationPriority priority = NotificationPriority.normal,
    Map<String, dynamic>? data,
    String? actionUrl,
    String? documentId,
  }) {
    return addNotification(
      NotificationModel(
        id: documentId ?? '',
        userId: userId,
        type: type,
        title: title,
        body: body,
        priority: priority,
        status: NotificationStatus.sent,
        sentAt: DateTime.now(),
        data: data,
        actionUrl: actionUrl,
      ),
      documentId: documentId,
    );
  }

  /// Add notification to Firestore
  Future<String> addNotification(
    NotificationModel notification, {
    String? documentId,
  }) async {
    try {
      if (documentId != null && documentId.isNotEmpty) {
        final docRef =
            _firestore.collection(_notificationsCollection).doc(documentId);
        await docRef.set(notification.toJson(), SetOptions(merge: true));
        return docRef.id;
      }

      final docRef = await _firestore.collection(_notificationsCollection).add(
            notification.toJson(),
          );
      return docRef.id;
    } catch (e) {
      print('Error adding notification: $e');
      throw _handleException(e);
    }
  }

  /// Get a single notification by document ID
  Future<NotificationModel?> getNotificationById(String notificationId) async {
    try {
      final doc = await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return NotificationModel.fromFirestore(doc);
    } catch (e) {
      print('Error getting notification by id: $e');
      throw _handleException(e);
    }
  }

  /// Get all notifications for a user
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    try {
      return _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting user notifications: $e');
      throw _handleException(e);
    }
  }

  /// Get unread notifications count
  Stream<int> getUnreadNotificationCount(String userId) {
    try {
      return _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        // Count notifications that are NOT read
        return snapshot.docs.where((doc) {
          final data = doc.data();
          final status = data['status'] ?? 'sent';
          return status != 'read';
        }).length;
      }).handleError((error) {
        print('Error in getUnreadNotificationCount stream: $error');
        return 0;
      });
    } catch (e) {
      print('Error setting up unread notification count stream: $e');
      return Stream.error(e);
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({
        'status': 'read',
        'readAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error marking notification as read: $e');
      throw _handleException(e);
    }
  }

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] ?? 'sent';
        if (status != 'read') {
          batch.update(doc.reference, {
            'status': 'read',
            'readAt': Timestamp.now(),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      throw _handleException(e);
    }
  }

  /// Mark notification as delivered
  Future<void> markAsDelivered(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({
        'status': 'delivered',
        'deliveredAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error marking notification as delivered: $e');
      throw _handleException(e);
    }
  }

  /// Get notifications by type
  Stream<List<NotificationModel>> getUserNotificationsByType(
    String userId,
    NotificationType type,
  ) {
    try {
      return _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.toString().split('.').last)
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting notifications by type: $e');
      throw _handleException(e);
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .delete();
    } catch (e) {
      print('Error deleting notification: $e');
      throw _handleException(e);
    }
  }

  /// Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting all notifications: $e');
      throw _handleException(e);
    }
  }

  /// Get recent notifications (last 7 days)
  Stream<List<NotificationModel>> getRecentNotifications(String userId) {
    try {
      final sevenDaysAgo = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(days: 7)),
      );

      return _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('sentAt', isGreaterThanOrEqualTo: sevenDaysAgo)
          .orderBy('sentAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting recent notifications: $e');
      throw _handleException(e);
    }
  }

  /// Handle exceptions
  Exception _handleException(dynamic error) {
    if (error is FirebaseException) {
      return Exception('Firestore error: ${error.message}');
    }
    return Exception('Unknown error: $error');
  }
}
