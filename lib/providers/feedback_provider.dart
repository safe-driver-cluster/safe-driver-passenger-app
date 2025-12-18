import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/feedback_extended.dart';
import '../data/models/feedback_model.dart';
import '../data/repositories/extended_feedback_repository.dart';
import '../presentation/controllers/enhanced_feedback_controller.dart';
import '../services/media_service.dart';
import 'app_providers.dart';

// Media Service Provider
final mediaServiceProvider = Provider((ref) => MediaService());

// Extended Feedback Repository Provider
final extendedFeedbackRepositoryProvider = Provider((ref) {
  return ExtendedFeedbackRepository();
});

// Enhanced Feedback Controller Provider
final enhancedFeedbackControllerProvider =
    StateNotifierProvider<EnhancedFeedbackController, AsyncValue<void>>((ref) {
  return EnhancedFeedbackController(
    extendedRepository: ref.watch(extendedFeedbackRepositoryProvider),
    mediaService: ref.watch(mediaServiceProvider),
    ref: ref,
  );
});

// User Feedback History Provider
final userFeedbackHistoryProvider =
    FutureProvider.family<List<FeedbackModel>, String>((ref, userId) async {
  final repository = ref.watch(extendedFeedbackRepositoryProvider);
  return repository.getUserFeedbackHistory(userId);
});

// Feedback Analytics Provider
final feedbackAnalyticsProvider = FutureProvider
    .family<Map<String, dynamic>, String?>((ref, userId) async {
  final repository = ref.watch(extendedFeedbackRepositoryProvider);
  return repository.getDetailedStatistics(userId: userId);
});

// Feedback Status Tracking Provider
final feedbackStatusTrackingProvider =
    FutureProvider.family<FeedbackModel?, String>((ref, feedbackId) async {
  final repository = ref.watch(extendedFeedbackRepositoryProvider);
  return repository.getFeedbackWithDetails(feedbackId);
});

// Feedback Audit Logs Provider
final feedbackAuditLogsProvider = FutureProvider.family<List<FeedbackAuditLog>, String>((ref, feedbackId) async {
  final repository = ref.watch(extendedFeedbackRepositoryProvider);
  return repository.getFeedbackAuditLogs(feedbackId);
});

// Stream User Feedback History
final streamUserFeedbackHistoryProvider =
    StreamProvider.family<List<FeedbackModel>, String>((ref, userId) {
  final repository = ref.watch(extendedFeedbackRepositoryProvider);
  return repository.streamUserFeedbackHistory(userId);
});

// Upload Progress Notifier
final uploadProgressNotifierProvider =
    StateNotifierProvider<_UploadProgressNotifier, Map<String, AttachmentProgress>>(
  (ref) => _UploadProgressNotifier(),
);

class _UploadProgressNotifier
    extends StateNotifier<Map<String, AttachmentProgress>> {
  _UploadProgressNotifier() : super({});

  void updateProgress(String attachmentId, double progress) {
    state = {
      ...state,
      attachmentId: state[attachmentId]?.copyWith(progress: progress) ??
          AttachmentProgress(
            attachmentId: attachmentId,
            fileName: attachmentId,
            progress: progress,
          ),
    };
  }

  void setCompleted(String attachmentId, String? fileUrl) {
    state = {
      ...state,
      attachmentId: state[attachmentId]?.copyWith(
            status: UploadStatus.completed,
            progress: 1.0,
            fileUrl: fileUrl,
          ) ??
          AttachmentProgress(
            attachmentId: attachmentId,
            fileName: attachmentId,
            status: UploadStatus.completed,
            progress: 1.0,
            fileUrl: fileUrl,
          ),
    };
  }

  void setFailed(String attachmentId, String errorMessage) {
    state = {
      ...state,
      attachmentId: state[attachmentId]?.copyWith(
            status: UploadStatus.failed,
            errorMessage: errorMessage,
          ) ??
          AttachmentProgress(
            attachmentId: attachmentId,
            fileName: attachmentId,
            status: UploadStatus.failed,
            errorMessage: errorMessage,
          ),
    };
  }

  void clearProgress() {
    state = {};
  }
}

// Feedback Statistics Cache Provider
final feedbackStatisticsCacheProvider =
    StateNotifierProvider<_FeedbackStatisticsNotifier, Map<String, dynamic>>(
  (ref) => _FeedbackStatisticsNotifier(),
);

class _FeedbackStatisticsNotifier
    extends StateNotifier<Map<String, dynamic>> {
  _FeedbackStatisticsNotifier() : super({});

  void updateStatistics(Map<String, dynamic> stats) {
    state = stats;
  }

  void clearCache() {
    state = {};
  }
}

// QR Code Feedback Session Provider
final qrFeedbackSessionProvider =
    StateNotifierProvider<_QRFeedbackSessionNotifier, QRFeedbackSession>(
  (ref) => _QRFeedbackSessionNotifier(),
);

class QRFeedbackSession {
  final String? scannedBusNumber;
  final String? selectedFeedbackType;
  final int? rating;
  final String? comments;
  final List<String> uploadedMediaUrls;
  final DateTime createdAt;

  QRFeedbackSession({
    this.scannedBusNumber,
    this.selectedFeedbackType,
    this.rating,
    this.comments,
    this.uploadedMediaUrls = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  QRFeedbackSession copyWith({
    String? scannedBusNumber,
    String? selectedFeedbackType,
    int? rating,
    String? comments,
    List<String>? uploadedMediaUrls,
    DateTime? createdAt,
  }) {
    return QRFeedbackSession(
      scannedBusNumber: scannedBusNumber ?? this.scannedBusNumber,
      selectedFeedbackType:
          selectedFeedbackType ?? this.selectedFeedbackType,
      rating: rating ?? this.rating,
      comments: comments ?? this.comments,
      uploadedMediaUrls: uploadedMediaUrls ?? this.uploadedMediaUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class _QRFeedbackSessionNotifier
    extends StateNotifier<QRFeedbackSession> {
  _QRFeedbackSessionNotifier() : super(QRFeedbackSession());

  void setBusNumber(String busNumber) {
    state = state.copyWith(scannedBusNumber: busNumber);
  }

  void setFeedbackType(String type) {
    state = state.copyWith(selectedFeedbackType: type);
  }

  void setRating(int rating) {
    state = state.copyWith(rating: rating);
  }

  void setComments(String comments) {
    state = state.copyWith(comments: comments);
  }

  void addMediaUrl(String url) {
    state = state.copyWith(
      uploadedMediaUrls: [...state.uploadedMediaUrls, url],
    );
  }

  void removeMediaUrl(String url) {
    state = state.copyWith(
      uploadedMediaUrls: [
        ...state.uploadedMediaUrls.where((u) => u != url),
      ],
    );
  }

  void reset() {
    state = QRFeedbackSession();
  }
}

// Feedback Filters Provider
final feedbackFiltersProvider =
    StateNotifierProvider<_FeedbackFiltersNotifier, FeedbackFilters>(
  (ref) => _FeedbackFiltersNotifier(),
);

class FeedbackFilters {
  final String? searchQuery;
  final FeedbackStatus? statusFilter;
  final FeedbackCategory? categoryFilter;
  final DateTimeRange? dateRange;
  final bool showWithAttachmentsOnly;
  final int limit;

  FeedbackFilters({
    this.searchQuery,
    this.statusFilter,
    this.categoryFilter,
    this.dateRange,
    this.showWithAttachmentsOnly = false,
    this.limit = 20,
  });

  FeedbackFilters copyWith({
    String? searchQuery,
    FeedbackStatus? statusFilter,
    FeedbackCategory? categoryFilter,
    DateTimeRange? dateRange,
    bool? showWithAttachmentsOnly,
    int? limit,
  }) {
    return FeedbackFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      dateRange: dateRange ?? this.dateRange,
      showWithAttachmentsOnly:
          showWithAttachmentsOnly ?? this.showWithAttachmentsOnly,
      limit: limit ?? this.limit,
    );
  }

  bool get hasActiveFilters =>
      searchQuery != null ||
      statusFilter != null ||
      categoryFilter != null ||
      dateRange != null ||
      showWithAttachmentsOnly;

  void clear() {}
}

class _FeedbackFiltersNotifier extends StateNotifier<FeedbackFilters> {
  _FeedbackFiltersNotifier() : super(FeedbackFilters());

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void setStatusFilter(FeedbackStatus? status) {
    state = state.copyWith(statusFilter: status);
  }

  void setCategoryFilter(FeedbackCategory? category) {
    state = state.copyWith(categoryFilter: category);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void setAttachmentsOnly(bool value) {
    state = state.copyWith(showWithAttachmentsOnly: value);
  }

  void setLimit(int limit) {
    state = state.copyWith(limit: limit);
  }

  void clearFilters() {
    state = FeedbackFilters();
  }
}
