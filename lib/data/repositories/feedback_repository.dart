import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/feedback_model.dart';

/// Repository for feedback operations
class FeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'feedback';

  /// Submit feedback
  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      await _firestore.collection(_collection).add(feedback.toJson());
    } catch (e) {
      throw Exception('Failed to submit feedback: $e');
    }
  }

  /// Get all feedback
  Future<List<FeedbackModel>> getAllFeedback() async {
    try {
      final query = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all feedback: $e');
    }
  }

  /// Get feedback by user ID
  Future<List<FeedbackModel>> getFeedbackByUser(String userId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user feedback: $e');
    }
  }

  /// Get feedback by bus ID
  Future<List<FeedbackModel>> getFeedbackByBus(String busId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('busId', isEqualTo: busId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bus feedback: $e');
    }
  }

  /// Get feedback by driver ID
  Future<List<FeedbackModel>> getFeedbackByDriver(String driverId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get driver feedback: $e');
    }
  }

  /// Update feedback status
  Future<void> updateFeedbackStatus(
      String feedbackId, FeedbackStatus status) async {
    try {
      await _firestore.collection(_collection).doc(feedbackId).update({
        'status': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update feedback status: $e');
    }
  }

  /// Delete feedback
  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await _firestore.collection(_collection).doc(feedbackId).delete();
    } catch (e) {
      throw Exception('Failed to delete feedback: $e');
    }
  }

  /// Get feedback by category
  Future<List<FeedbackModel>> getFeedbackByCategory(
      FeedbackCategory category) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get feedback by category: $e');
    }
  }

  /// Get feedback by rating
  Future<List<FeedbackModel>> getFeedbackByRating(FeedbackRating rating) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('rating', isEqualTo: rating.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get feedback by rating: $e');
    }
  }

  /// Get recent feedback (last N days)
  Future<List<FeedbackModel>> getRecentFeedback({int days = 7}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final query = await _firestore
          .collection(_collection)
          .where('createdAt', isGreaterThanOrEqualTo: cutoffDate)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recent feedback: $e');
    }
  }

  /// Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStatistics() async {
    try {
      final query = await _firestore.collection(_collection).get();

      final stats = <String, dynamic>{
        'total': query.size,
        'byCategory': <String, int>{},
        'byRating': <String, int>{},
        'byStatus': <String, int>{},
        'averageRating': 0.0,
      };

      final feedbacks = query.docs
          .map((doc) => FeedbackModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      // Count by category
      for (final category in FeedbackCategory.values) {
        final count = feedbacks.where((f) => f.category == category).length;
        stats['byCategory'][category.toString().split('.').last] = count;
      }

      // Count by rating
      for (final rating in FeedbackRating.values) {
        final count = feedbacks.where((f) => f.rating == rating).length;
        stats['byRating'][rating.toString().split('.').last] = count;
      }

      // Count by status
      for (final status in FeedbackStatus.values) {
        final count = feedbacks.where((f) => f.status == status).length;
        stats['byStatus'][status.toString().split('.').last] = count;
      }

      // Calculate average rating
      if (feedbacks.isNotEmpty) {
        final ratingValues = feedbacks.map((f) {
          if (f.rating == FeedbackRating.excellent) {
            return 5;
          } else if (f.rating == FeedbackRating.good) {
            return 4;
          } else if (f.rating == FeedbackRating.average) {
            return 3;
          } else if (f.rating == FeedbackRating.poor) {
            return 2;
          } else if (f.rating == FeedbackRating.terrible) {
            return 1;
          } else {
            return 3; // Default to average
          }
        });

        final sum = ratingValues.fold<int>(0, (sum, rating) => sum + rating);
        stats['averageRating'] = sum / feedbacks.length;
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to get feedback statistics: $e');
    }
  }

  /// Stream feedback updates
  Stream<List<FeedbackModel>> streamFeedback() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  /// Search feedback
  Future<List<FeedbackModel>> searchFeedback(String query) async {
    try {
      // Simple text search - in production, you'd use a search service
      final allFeedback = await getAllFeedback();

      final lowerQuery = query.toLowerCase();
      return allFeedback
          .where((feedback) =>
              feedback.title.toLowerCase().contains(lowerQuery) ||
              feedback.description.toLowerCase().contains(lowerQuery) ||
              (feedback.userName?.toLowerCase().contains(lowerQuery) ?? false))
          .toList();
    } catch (e) {
      throw Exception('Failed to search feedback: $e');
    }
  }
}
