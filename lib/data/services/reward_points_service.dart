import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/feedback_model.dart';
import '../models/passenger_model.dart';

/// Service for managing reward points
class RewardPointsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _passengersCollection = 'passenger_details';

  /// Point values
  static const int initialFeedbackPoints = 1;
  static const int approvedFeedbackAdditionalPoints = 2; // Total 3 with initial
  static const int rejectedFeedbackPenalty = 1;

  /// Add points for feedback submission (initial +1 point)
  Future<void> addFeedbackSubmissionPoints(
      String userId, FeedbackCategory category, FeedbackType type) async {
    try {
      debugPrint(
          '🎁 RewardPointsService: Adding feedback submission points for user: $userId');
      debugPrint(
          '   Category: $category, Type: $type, Points: +$initialFeedbackPoints');

      await _updateUserPoints(userId, initialFeedbackPoints,
          'Feedback submission - ${category.toString().split('.').last}');
    } catch (e) {
      debugPrint('❌ RewardPointsService: Error adding feedback points: $e');
      throw Exception('Failed to add reward points: $e');
    }
  }

  /// Add bonus points when feedback is approved/resolved
  Future<void> addFeedbackApprovalBonus(String userId, String feedbackId) async {
    try {
      debugPrint(
          '✅ RewardPointsService: Adding feedback approval bonus for user: $userId');
      debugPrint('   FeedbackId: $feedbackId, Bonus Points: +$approvedFeedbackAdditionalPoints');

      await _updateUserPoints(userId, approvedFeedbackAdditionalPoints,
          'Feedback approved - $feedbackId');
    } catch (e) {
      debugPrint(
          '❌ RewardPointsService: Error adding approval bonus: $e');
      throw Exception('Failed to add approval bonus: $e');
    }
  }

  /// Deduct points for fake/rejected feedback
  Future<void> deductFakeFeedbackPenalty(String userId, String feedbackId) async {
    try {
      debugPrint(
          '⚠️ RewardPointsService: Deducting penalty for fake feedback - User: $userId');
      debugPrint(
          '   FeedbackId: $feedbackId, Penalty Points: -$rejectedFeedbackPenalty');

      await _updateUserPoints(userId, -rejectedFeedbackPenalty,
          'Fake feedback penalty - $feedbackId');
    } catch (e) {
      debugPrint('❌ RewardPointsService: Error deducting penalty: $e');
      throw Exception('Failed to deduct penalty: $e');
    }
  }

  /// Get current user reward points
  Future<int> getUserRewardPoints(String userId) async {
    try {
      debugPrint(
          '🔍 RewardPointsService: Fetching reward points for user: $userId');

      final docSnapshot =
          await _firestore.collection(_passengersCollection).doc(userId).get();

      if (!docSnapshot.exists) {
        debugPrint('⚠️  RewardPointsService: User not found: $userId');
        return 0;
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final stats = data['stats'] as Map<String, dynamic>? ?? {};
      final points = stats['pointsEarned'] as int? ?? 0;

      debugPrint('📊 RewardPointsService: User $userId has $points points');
      return points;
    } catch (e) {
      debugPrint('❌ RewardPointsService: Error fetching points: $e');
      return 0;
    }
  }

  /// Get reward points history/breakdown
  Future<Map<String, dynamic>> getUserRewardSummary(String userId) async {
    try {
      debugPrint(
          '📈 RewardPointsService: Fetching reward summary for user: $userId');

      final feedbackRef =
          _firestore.collection('feedback').where('userId', isEqualTo: userId);
      final feedbackSnapshot = await feedbackRef.get();

      int totalPoints = await getUserRewardPoints(userId);
      int submittedCount = 0;
      int approvedCount = 0;
      int rejectedCount = 0;

      for (var doc in feedbackSnapshot.docs) {
        final status = doc['status'] as String? ?? '';

        if (status == 'submitted' || status == 'inReview') {
          submittedCount++;
        } else if (status == 'resolved' || status == 'closed') {
          approvedCount++;
        } else if (status == 'escalated') {
          // Could be treated as suspicious
          rejectedCount++;
        }
      }

      final summary = {
        'totalPoints': totalPoints,
        'submittedFeedback': submittedCount,
        'approvedFeedback': approvedCount,
        'rejectedFeedback': rejectedCount,
        'estimatedPointsFromSubmissions': submittedCount * initialFeedbackPoints,
        'estimatedPointsFromApprovals':
            approvedCount * approvedFeedbackAdditionalPoints,
        'estimatedPointsFromPenalties': rejectedCount * rejectedFeedbackPenalty,
      };

      debugPrint(
          '✅ RewardPointsService: Summary - $summary');
      return summary;
    } catch (e) {
      debugPrint('❌ RewardPointsService: Error fetching summary: $e');
      return {
        'totalPoints': 0,
        'submittedFeedback': 0,
        'approvedFeedback': 0,
        'rejectedFeedback': 0,
      };
    }
  }

  /// Update user points
  Future<void> _updateUserPoints(
      String userId, int pointsDelta, String reason) async {
    try {
      debugPrint(
          '💾 RewardPointsService: Updating points for user: $userId, Delta: $pointsDelta, Reason: $reason');

      final userRef =
          _firestore.collection(_passengersCollection).doc(userId);

      // Get current points
      final currentPoints = await getUserRewardPoints(userId);
      final newPoints = (currentPoints + pointsDelta).clamp(0, 999999);

      // Update user stats
      await userRef.update({
        'stats.pointsEarned': newPoints,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Log point transaction
      await _logPointTransaction(userId, pointsDelta, reason, newPoints);

      debugPrint(
          '✅ RewardPointsService: Updated points - Old: $currentPoints, New: $newPoints, Delta: $pointsDelta');
    } catch (e) {
      debugPrint('❌ RewardPointsService: Error updating points: $e');
      throw Exception('Failed to update points: $e');
    }
  }

  /// Log point transaction for audit trail
  Future<void> _logPointTransaction(
      String userId, int pointsDelta, String reason, int newBalance) async {
    try {
      await _firestore.collection('point_transactions').add({
        'userId': userId,
        'delta': pointsDelta,
        'newBalance': newBalance,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint(
          '⚠️  RewardPointsService: Could not log transaction: $e');
      // Don't throw - this is non-critical
    }
  }

  /// Check if feedback appears to be fake (anti-fraud)
  bool checkIfFakeFeedback(FeedbackModel feedback) {
    // Simple heuristics for detecting potentially fake feedback
    // These can be expanded based on business rules

    // 1. Very short feedback
    if (feedback.description.length < 5) {
      debugPrint('⚠️  Anti-fraud: Feedback too short (${feedback.description.length} chars)');
      return true;
    }

    // 2. Feedback with only spaces or numbers
    if (feedback.description.trim().isEmpty ||
        feedback.description.replaceAll(RegExp(r'\d+\s+'), '').isEmpty) {
      debugPrint('⚠️  Anti-fraud: Feedback appears empty or only numbers');
      return true;
    }

    // 3. Repeated submissions in short time (would need to be checked against database)
    // 4. Same feedback text repeated (would need to be checked against database)

    return false;
  }
}
