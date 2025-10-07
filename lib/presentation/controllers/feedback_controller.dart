import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/feedback_model.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/feedback_repository.dart';

/// Controller for feedback operations and state management
class FeedbackController extends StateNotifier<AsyncValue<void>> {
  final FeedbackRepository _feedbackRepository;

  FeedbackController({
    required FeedbackRepository feedbackRepository,
  })  : _feedbackRepository = feedbackRepository,
        super(const AsyncValue.data(null));

  // State management
  final ValueNotifier<List<FeedbackModel>> _feedbacks = ValueNotifier([]);
  final ValueNotifier<FeedbackModel?> _selectedFeedback = ValueNotifier(null);
  final ValueNotifier<Map<String, dynamic>> _statistics = ValueNotifier({});

  // Getters
  List<FeedbackModel> get feedbacks => _feedbacks.value;
  FeedbackModel? get selectedFeedback => _selectedFeedback.value;
  Map<String, dynamic> get statistics => _statistics.value;

  // Listeners
  ValueNotifier<List<FeedbackModel>> get feedbacksNotifier => _feedbacks;
  ValueNotifier<FeedbackModel?> get selectedFeedbackNotifier =>
      _selectedFeedback;
  ValueNotifier<Map<String, dynamic>> get statisticsNotifier => _statistics;

  /// Load all feedback
  Future<void> loadFeedbacks() async {
    try {
      state = const AsyncValue.loading();
      final feedbackList = await _feedbackRepository.getAllFeedback();
      _feedbacks.value = feedbackList;
      await _updateStatistics();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load feedback: $e', stack);
    }
  }

  /// Load feedback by user ID
  Future<void> loadUserFeedback(String userId) async {
    try {
      state = const AsyncValue.loading();
      final userFeedback = await _feedbackRepository.getFeedbackByUser(userId);
      _feedbacks.value = userFeedback;
      await _updateStatistics();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load user feedback: $e', stack);
    }
  }

  /// Load feedback by bus ID
  Future<void> loadBusFeedback(String busId) async {
    try {
      state = const AsyncValue.loading();
      final busFeedback = await _feedbackRepository.getFeedbackByBus(busId);
      _feedbacks.value = busFeedback;
      await _updateStatistics();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load bus feedback: $e', stack);
    }
  }

  /// Submit new feedback
  Future<void> submitFeedback({
    required String userId,
    required String userName,
    String? busId,
    String? busNumber,
    String? driverId,
    String? driverName,
    required int rating,
    String? title,
    required String comment,
    required FeedbackCategory category,
    FeedbackType type = FeedbackType.general,
    LocationModel? location,
    List<String>? images,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      state = const AsyncValue.loading();

      final feedback = FeedbackModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        busId: busId,
        busNumber: busNumber,
        driverId: driverId,
        driverName: driverName,
        category: category,
        type: type,
        title: title ?? 'Feedback',
        description: comment,
        rating:
            FeedbackRating(overall: rating), // Convert int to FeedbackRating
        tags: [],
        attachments: [],
        location: location,
        timestamp: DateTime.now(),
        status: FeedbackStatus.submitted,
        priority: FeedbackPriority.medium,
        metadata: metadata ?? {},
        relatedFeedbackIds: [],
        comment: comment,
        images: images ?? [],
        submittedAt: DateTime.now(),
      );

      await _feedbackRepository.submitFeedback(feedback);

      // Add to local state
      _feedbacks.value = [..._feedbacks.value, feedback];
      await _updateStatistics();

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to submit feedback: $e', stack);
    }
  }

  /// Update feedback status
  Future<void> updateFeedbackStatus(
      String feedbackId, FeedbackStatus status) async {
    try {
      state = const AsyncValue.loading();
      await _feedbackRepository.updateFeedbackStatus(feedbackId, status);

      // Update local state
      _feedbacks.value = _feedbacks.value.map((feedback) {
        if (feedback.id == feedbackId) {
          return feedback.copyWith(
            status: status,
          );
        }
        return feedback;
      }).toList();

      await _updateStatistics();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to update feedback status: $e', stack);
    }
  }

  /// Delete feedback
  Future<void> deleteFeedback(String feedbackId) async {
    try {
      state = const AsyncValue.loading();
      await _feedbackRepository.deleteFeedback(feedbackId);

      // Remove from local state
      _feedbacks.value = _feedbacks.value
          .where((feedback) => feedback.id != feedbackId)
          .toList();

      await _updateStatistics();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error('Failed to delete feedback: $e', stack);
    }
  }

  /// Select feedback
  void selectFeedback(FeedbackModel feedback) {
    _selectedFeedback.value = feedback;
  }

  /// Clear selection
  void clearSelection() {
    _selectedFeedback.value = null;
  }

  /// Get feedback by category
  List<FeedbackModel> getFeedbackByCategory(FeedbackCategory category) {
    return _feedbacks.value
        .where((feedback) => feedback.category == category)
        .toList();
  }

  /// Get feedback by rating
  List<FeedbackModel> getFeedbackByRating(int rating) {
    return _feedbacks.value
        .where((feedback) => feedback.rating == rating)
        .toList();
  }

  /// Get high-rated feedback (4-5 stars)
  List<FeedbackModel> getHighRatedFeedback() {
    return _feedbacks.value
        .where((feedback) => feedback.rating.overall >= 4)
        .toList();
  }

  /// Get low-rated feedback (1-2 stars)
  List<FeedbackModel> getLowRatedFeedback() {
    return _feedbacks.value
        .where((feedback) => feedback.rating.overall <= 2)
        .toList();
  }

  /// Get recent feedback (last 7 days)
  List<FeedbackModel> getRecentFeedback() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _feedbacks.value
        .where((feedback) => feedback.submittedAt.isAfter(weekAgo))
        .toList();
  }

  /// Get feedback by status
  List<FeedbackModel> getFeedbackByStatus(FeedbackStatus status) {
    return _feedbacks.value
        .where((feedback) => feedback.status == status)
        .toList();
  }

  /// Search feedback
  List<FeedbackModel> searchFeedback(String query) {
    if (query.isEmpty) return _feedbacks.value;

    final lowerQuery = query.toLowerCase();
    return _feedbacks.value
        .where((feedback) =>
            feedback.title.toLowerCase().contains(lowerQuery) ||
            feedback.comment.toLowerCase().contains(lowerQuery) ||
            (feedback.userName?.toLowerCase().contains(lowerQuery) ?? false) ||
            (feedback.busNumber?.toLowerCase().contains(lowerQuery) ?? false) ||
            (feedback.driverName?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  /// Update statistics
  Future<void> _updateStatistics() async {
    final stats = <String, dynamic>{
      'total': _feedbacks.value.length,
      'byStatus': <String, int>{},
      'byCategory': <String, int>{},
      'byRating': <String, int>{},
      'averageRating': 0.0,
      'totalRating': 0,
    };

    // Count by status
    for (final status in FeedbackStatus.values) {
      stats['byStatus'][status.toString().split('.').last] =
          _feedbacks.value.where((f) => f.status == status).length;
    }

    // Count by category
    for (final category in FeedbackCategory.values) {
      stats['byCategory'][category.toString().split('.').last] =
          _feedbacks.value.where((f) => f.category == category).length;
    }

    // Count by rating
    for (int rating = 1; rating <= 5; rating++) {
      stats['byRating'][rating.toString()] =
          _feedbacks.value.where((f) => f.rating.overall == rating).length;
    }

    // Calculate average rating
    if (_feedbacks.value.isNotEmpty) {
      final totalRating = _feedbacks.value
          .fold<int>(0, (sum, feedback) => sum + feedback.rating.overall);
      stats['totalRating'] = totalRating;
      stats['averageRating'] = totalRating / _feedbacks.value.length;
    }

    _statistics.value = stats;
  }

  /// Get feedback trends (last 30 days)
  Map<String, List<int>> getFeedbackTrends() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final recentFeedback = _feedbacks.value
        .where((feedback) => feedback.submittedAt.isAfter(thirtyDaysAgo))
        .toList();

    final dailyCount = <int>[];
    final dailyRating = <double>[];

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayFeedback = recentFeedback
          .where((feedback) =>
              feedback.submittedAt.isAfter(dayStart) &&
              feedback.submittedAt.isBefore(dayEnd))
          .toList();

      dailyCount.add(dayFeedback.length);

      if (dayFeedback.isNotEmpty) {
        final avgRating = dayFeedback.fold<int>(
                0, (sum, feedback) => sum + feedback.rating.overall) /
            dayFeedback.length;
        dailyRating.add(avgRating);
      } else {
        dailyRating.add(0.0);
      }
    }

    return {
      'count': dailyCount.reversed.map((e) => e).toList(),
      'rating': dailyRating.reversed.map((e) => e.round()).toList(),
    };
  }

  /// Refresh feedback data
  Future<void> refresh() async {
    await loadFeedbacks();
  }

  @override
  void dispose() {
    _feedbacks.dispose();
    _selectedFeedback.dispose();
    _statistics.dispose();
    super.dispose();
  }
}

/// Provider for FeedbackController
final feedbackControllerProvider =
    StateNotifierProvider<FeedbackController, AsyncValue<void>>((ref) {
  final feedbackRepository = ref.read(feedbackRepositoryProvider);
  return FeedbackController(feedbackRepository: feedbackRepository);
});

/// Provider for FeedbackRepository
final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository();
});

/// Provider for feedback list
final feedbacksProvider = Provider<List<FeedbackModel>>((ref) {
  final controller = ref.watch(feedbackControllerProvider.notifier);
  return controller.feedbacks;
});

/// Provider for feedback statistics
final feedbackStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final controller = ref.watch(feedbackControllerProvider.notifier);
  return controller.statistics;
});
