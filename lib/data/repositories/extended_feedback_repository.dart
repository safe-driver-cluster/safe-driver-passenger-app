import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/feedback_extended.dart';
import '../models/feedback_model.dart';

/// Extended repository for advanced feedback operations including attachment management
class ExtendedFeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'feedback';
  final String _auditLogsCollection = 'feedback_audit_logs';

  /// Add attachment to feedback
  Future<void> addAttachment(
    String feedbackId,
    FeedbackAttachment attachment,
  ) async {
    try {
      debugPrint(
          '📎 ExtendedFeedbackRepository: Adding attachment to feedback $feedbackId');

      await _firestore.collection(_collection).doc(feedbackId).update({
        'attachments': FieldValue.arrayUnion([attachment.toJson()])
      });

      debugPrint('✅ ExtendedFeedbackRepository: Attachment added successfully');
    } catch (e) {
      debugPrint('❌ ExtendedFeedbackRepository: Error adding attachment: $e');
      throw Exception('Failed to add attachment: $e');
    }
  }

  /// Add multiple attachments in batch
  Future<void> addMultipleAttachments(
    String feedbackId,
    List<FeedbackAttachment> attachments,
  ) async {
    try {
      debugPrint(
          '📦 ExtendedFeedbackRepository: Adding ${attachments.length} attachments');

      await _firestore.collection(_collection).doc(feedbackId).update({
        'attachments': FieldValue.arrayUnion(
          attachments.map((a) => a.toJson()).toList(),
        )
      });

      debugPrint(
          '✅ ExtendedFeedbackRepository: Multiple attachments added successfully');
    } catch (e) {
      debugPrint(
          '❌ ExtendedFeedbackRepository: Error adding attachments: $e');
      throw Exception('Failed to add multiple attachments: $e');
    }
  }

  /// Remove attachment from feedback
  Future<void> removeAttachment(
    String feedbackId,
    String attachmentId,
  ) async {
    try {
      debugPrint(
          '🗑️ ExtendedFeedbackRepository: Removing attachment $attachmentId');

      final doc = await _firestore
          .collection(_collection)
          .doc(feedbackId)
          .get();

      if (doc.exists) {
        final attachments = List<Map<String, dynamic>>.from(
          (doc.data()?['attachments'] ?? []) as List<dynamic>,
        );

        attachments
            .removeWhere((a) => a['id'] == attachmentId);

        await _firestore.collection(_collection).doc(feedbackId).update({
          'attachments': attachments,
        });

        debugPrint(
            '✅ ExtendedFeedbackRepository: Attachment removed successfully');
      }
    } catch (e) {
      debugPrint('❌ ExtendedFeedbackRepository: Error removing attachment: $e');
      throw Exception('Failed to remove attachment: $e');
    }
  }

  /// Update feedback status with audit log
  Future<void> updateFeedbackStatusWithAudit(
    String feedbackId,
    FeedbackStatus newStatus,
    String userId, {
    String? reason,
    String? respondedBy,
  }) async {
    try {
      final batch = _firestore.batch();

      // Get current feedback to log the transition
      final currentDoc =
          await _firestore.collection(_collection).doc(feedbackId).get();
      final currentStatus = currentDoc.exists
          ? FeedbackStatus.values.firstWhere(
              (e) =>
                  e.toString().split('.').last ==
                  currentDoc.data()?['status'],
              orElse: () => FeedbackStatus.submitted,
            )
          : FeedbackStatus.submitted;

      // Update feedback
      batch.update(_firestore.collection(_collection).doc(feedbackId), {
        'status': newStatus.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
        if (respondedBy != null) 'respondedBy': respondedBy,
        if (respondedBy != null)
          'respondedAt': FieldValue.serverTimestamp(),
      });

      // Create audit log
      final auditLog = FeedbackAuditLog(
        feedbackId: feedbackId,
        userId: userId,
        fromStatus: currentStatus,
        toStatus: newStatus,
        reason: reason,
        actionPerformedBy: respondedBy,
      );

      batch.set(
        _firestore
            .collection(_auditLogsCollection)
            .doc(),
        auditLog.toJson(),
      );

      await batch.commit();
      debugPrint(
          '✅ ExtendedFeedbackRepository: Status updated with audit log');
    } catch (e) {
      debugPrint('❌ ExtendedFeedbackRepository: Error updating status: $e');
      throw Exception('Failed to update feedback status: $e');
    }
  }

  /// Get feedback history for a user with pagination
  Future<List<FeedbackModel>> getUserFeedbackHistory(
    String userId, {
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    FeedbackStatus? statusFilter,
    FeedbackCategory? categoryFilter,
  }) async {
    try {
      var query = _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId) as Query<Map<String, dynamic>>;

      if (statusFilter != null) {
        query = query.where('status',
            isEqualTo: statusFilter.toString().split('.').last);
      }

      if (categoryFilter != null) {
        query = query.where('category',
            isEqualTo: categoryFilter.toString().split('.').last);
      }

      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final results = await query
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return results.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      debugPrint('❌ ExtendedFeedbackRepository: Error getting history: $e');
      throw Exception('Failed to get user feedback history: $e');
    }
  }

  /// Get audit logs for a feedback
  Future<List<FeedbackAuditLog>> getFeedbackAuditLogs(String feedbackId) async {
    try {
      final query = await _firestore
          .collection(_auditLogsCollection)
          .where('feedbackId', isEqualTo: feedbackId)
          .orderBy('timestamp', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackAuditLog.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('❌ ExtendedFeedbackRepository: Error getting audit logs: $e');
      throw Exception('Failed to get audit logs: $e');
    }
  }

  /// Stream feedback status changes for a user
  Stream<List<FeedbackModel>> streamUserFeedbackHistory(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  /// Get feedback with complete details including all attachments
  Future<FeedbackModel?> getFeedbackWithDetails(String feedbackId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(feedbackId).get();

      if (doc.exists) {
        return FeedbackModel.fromJson({
          'id': doc.id,
          ...doc.data() ?? {},
        });
      }
      return null;
    } catch (e) {
      debugPrint(
          '❌ ExtendedFeedbackRepository: Error getting feedback details: $e');
      throw Exception('Failed to get feedback details: $e');
    }
  }

  /// Get feedback statistics for analytics dashboard
  Future<Map<String, dynamic>> getDetailedStatistics({
    DateTime? fromDate,
    DateTime? toDate,
    String? userId,
  }) async {
    try {
      var query = _firestore.collection(_collection) as Query<Map<String, dynamic>>;

      if (fromDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: fromDate);
      }

      if (toDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: toDate);
      }

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final querySnapshot = await query.get();
      final feedbacks = querySnapshot.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      return {
        'total': feedbacks.length,
        'withAttachments': feedbacks.where((f) => f.attachments.isNotEmpty).length,
        'averageRating': feedbacks.isEmpty
            ? 0.0
            : feedbacks.fold<double>(0, (sum, f) => sum + f.rating.overall) /
                feedbacks.length,
        'statusDistribution': {
          for (final status in FeedbackStatus.values)
            status.toString().split('.').last:
                feedbacks.where((f) => f.status == status).length,
        },
        'categoryDistribution': {
          for (final category in FeedbackCategory.values)
            category.toString().split('.').last:
                feedbacks.where((f) => f.category == category).length,
        },
        'typeDistribution': {
          for (final type in FeedbackType.values)
            type.toString().split('.').last:
                feedbacks.where((f) => f.type == type).length,
        },
        'attachmentStats': {
          'totalAttachments': feedbacks.fold<int>(
              0, (sum, f) => sum + f.attachments.length),
          'totalImages': feedbacks.fold<int>(
              0,
              (sum, f) =>
                  sum +
                  f.attachments.where((a) => a.isImage).length),
          'totalVideos': feedbacks.fold<int>(
              0,
              (sum, f) =>
                  sum +
                  f.attachments.where((a) => a.isVideo).length),
          'averageAttachmentsPerFeedback': feedbacks.isEmpty
              ? 0.0
              : feedbacks.fold<int>(
                      0, (sum, f) => sum + f.attachments.length) /
                  feedbacks.length,
        },
        'resolutionStats': {
          'resolved': feedbacks
              .where((f) => f.status == FeedbackStatus.resolved)
              .length,
          'pendingResponse': feedbacks
              .where((f) =>
                  f.status != FeedbackStatus.resolved &&
                  f.status != FeedbackStatus.closed)
              .length,
          'averageResolutionTimeHours':
              _calculateAverageResolutionTime(feedbacks),
        },
      };
    } catch (e) {
      debugPrint(
          '❌ ExtendedFeedbackRepository: Error getting detailed statistics: $e');
      throw Exception('Failed to get detailed statistics: $e');
    }
  }

  /// Calculate average resolution time in hours
  double _calculateAverageResolutionTime(List<FeedbackModel> feedbacks) {
    final resolvedFeedbacks = feedbacks
        .where((f) =>
            f.respondedAt != null && f.status == FeedbackStatus.resolved)
        .toList();

    if (resolvedFeedbacks.isEmpty) return 0.0;

    final totalHours = resolvedFeedbacks.fold<double>(
      0,
      (sum, f) => sum +
          f.respondedAt!
              .difference(f.timestamp)
              .inHours,
    );

    return totalHours / resolvedFeedbacks.length;
  }
}
