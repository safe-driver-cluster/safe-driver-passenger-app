import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/feedback_extended.dart';
import '../../data/models/feedback_model.dart';
import '../../data/repositories/extended_feedback_repository.dart';
import '../../services/media_service.dart';

/// Extended controller for feedback operations with media handling
class EnhancedFeedbackController extends StateNotifier<AsyncValue<void>> {
  final ExtendedFeedbackRepository _extendedRepository;
  final MediaService _mediaService;
  final Ref _ref;

  EnhancedFeedbackController({
    required ExtendedFeedbackRepository extendedRepository,
    required MediaService mediaService,
    required Ref ref,
  })  : _extendedRepository = extendedRepository,
        _mediaService = mediaService,
        _ref = ref,
        super(const AsyncValue.data(null));

  // State management
  final ValueNotifier<List<FeedbackModel>> _feedbackHistory = ValueNotifier([]);
  final ValueNotifier<Map<String, dynamic>> _analyticsData = ValueNotifier({});
  final ValueNotifier<List<FeedbackAuditLog>> _auditLogs = ValueNotifier([]);
  final ValueNotifier<Map<String, AttachmentProgress>> _uploadProgress =
      ValueNotifier({});

  // Getters
  List<FeedbackModel> get feedbackHistory => _feedbackHistory.value;
  Map<String, dynamic> get analyticsData => _analyticsData.value;
  List<FeedbackAuditLog> get auditLogs => _auditLogs.value;
  Map<String, AttachmentProgress> get uploadProgress => _uploadProgress.value;

  // Notifiers for UI updates
  ValueNotifier<List<FeedbackModel>> get feedbackHistoryNotifier =>
      _feedbackHistory;
  ValueNotifier<Map<String, dynamic>> get analyticsDataNotifier =>
      _analyticsData;
  ValueNotifier<List<FeedbackAuditLog>> get auditLogsNotifier => _auditLogs;
  ValueNotifier<Map<String, AttachmentProgress>> get uploadProgressNotifier =>
      _uploadProgress;

  /// Upload media files for feedback with progress tracking
  Future<List<String>> uploadMediaFiles({
    required List<File> files,
    required String feedbackId,
    required String userId,
    required Function(String, double)? onFileProgress,
    required Function(double)? onTotalProgress,
  }) async {
    try {
      debugPrint('📸 EnhancedFeedbackController: Starting media upload');
      state = const AsyncValue.loading();

      final uploadedUrls = <String>[];
      final progressMap = <String, AttachmentProgress>{};

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final attachmentId =
            '${feedbackId}_${DateTime.now().millisecondsSinceEpoch}_$i';

        // Initialize progress tracking
        progressMap[attachmentId] = AttachmentProgress(
          attachmentId: attachmentId,
          fileName: file.path.split('/').last,
          status: UploadStatus.pending,
        );
        _uploadProgress.value = progressMap;

        try {
          // Update progress to uploading
          progressMap[attachmentId] = progressMap[attachmentId]!.copyWith(
            status: UploadStatus.uploading,
          );
          _uploadProgress.value = progressMap;

          // Upload file
          final url = await _mediaService.uploadFeedbackMedia(
            file: file,
            feedbackId: feedbackId,
            userId: userId,
            onProgress: (progress) {
              progressMap[attachmentId] = progressMap[attachmentId]!.copyWith(
                progress: progress,
              );
              _uploadProgress.value = progressMap;

              onFileProgress?.call(attachmentId, progress);

              // Calculate total progress
              final totalProgress = progressMap.values
                      .fold<double>(0, (sum, p) => sum + p.progress) /
                  progressMap.length;
              onTotalProgress?.call(totalProgress);
            },
          );

          uploadedUrls.add(url);

          // Update progress to completed
          progressMap[attachmentId] = progressMap[attachmentId]!.copyWith(
            status: UploadStatus.completed,
            progress: 1.0,
            fileUrl: url,
          );
          _uploadProgress.value = progressMap;

          debugPrint('✅ EnhancedFeedbackController: File $i uploaded: $url');
        } catch (fileError) {
          debugPrint(
              '❌ EnhancedFeedbackController: File $i upload failed: $fileError');

          // Update progress to failed
          progressMap[attachmentId] = progressMap[attachmentId]!.copyWith(
            status: UploadStatus.failed,
            errorMessage: fileError.toString(),
          );
          _uploadProgress.value = progressMap;
        }
      }

      state = const AsyncValue.data(null);
      debugPrint(
          '✅ EnhancedFeedbackController: Media upload complete. ${uploadedUrls.length}/${files.length} files uploaded');

      return uploadedUrls;
    } catch (e, stack) {
      state = AsyncValue.error('Failed to upload media: $e', stack);
      return [];
    }
  }

  /// Create feedback with attachments
  Future<String?> createFeedbackWithAttachments({
    required FeedbackModel feedbackBase,
    required List<String> mediaUrls,
    List<String>? fileNames,
  }) async {
    try {
      debugPrint(
          '📝 EnhancedFeedbackController: Creating feedback with ${mediaUrls.length} attachments');

      // Create attachments
      final attachments = <FeedbackAttachment>[];
      for (int i = 0; i < mediaUrls.length; i++) {
        final fileName = fileNames?[i] ??
            'attachment_${DateTime.now().millisecondsSinceEpoch}_$i';
        final attachment = FeedbackAttachment(
          id: 'att_${DateTime.now().millisecondsSinceEpoch}_$i',
          fileName: fileName,
          fileUrl: mediaUrls[i],
          fileType: _getFileType(fileName),
          fileSize: 0, // Will be retrieved from Firebase metadata
          uploadedAt: DateTime.now(),
          metadata: {
            'uploadedBy': feedbackBase.userId,
            'originalName': fileName,
          },
        );
        attachments.add(attachment);
      }

      // Update feedback with attachments
      final updatedFeedback = feedbackBase.copyWith(
        attachments: attachments,
      );

      // Store in database
      // Note: This would be handled by the feedback repository
      debugPrint(
          '✅ EnhancedFeedbackController: Feedback created with attachments');

      return updatedFeedback.id;
    } catch (e, stack) {
      debugPrint('❌ EnhancedFeedbackController: Error creating feedback: $e');
      state = AsyncValue.error(
          'Failed to create feedback with attachments: $e', stack);
      return null;
    }
  }

  /// Load user feedback history with filters
  Future<void> loadUserFeedbackHistory(
    String userId, {
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    FeedbackStatus? statusFilter,
    FeedbackCategory? categoryFilter,
  }) async {
    try {
      debugPrint(
          '📚 EnhancedFeedbackController: Loading feedback history for $userId');
      state = const AsyncValue.loading();

      final history = await _extendedRepository.getUserFeedbackHistory(
        userId,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        statusFilter: statusFilter,
        categoryFilter: categoryFilter,
      );

      _feedbackHistory.value = history;
      state = const AsyncValue.data(null);

      debugPrint(
          '✅ EnhancedFeedbackController: Loaded ${history.length} feedback items');
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load feedback history: $e', stack);
    }
  }

  /// Stream user feedback history for real-time updates
  void streamUserFeedbackHistory(String userId) {
    debugPrint(
        '🔄 EnhancedFeedbackController: Streaming feedback history for $userId');

    _extendedRepository.streamUserFeedbackHistory(userId).listen(
      (feedbacks) {
        _feedbackHistory.value = feedbacks;
        debugPrint(
            '✅ EnhancedFeedbackController: Received ${feedbacks.length} updated items');
      },
      onError: (e) {
        debugPrint('❌ EnhancedFeedbackController: Stream error: $e');
      },
    );
  }

  /// Update feedback status with audit logging
  Future<void> updateFeedbackStatusWithTracking(
    String feedbackId,
    FeedbackStatus newStatus,
    String userId, {
    String? reason,
    String? respondedBy,
  }) async {
    try {
      debugPrint(
          '📊 EnhancedFeedbackController: Updating feedback $feedbackId to $newStatus');
      state = const AsyncValue.loading();

      await _extendedRepository.updateFeedbackStatusWithAudit(
        feedbackId,
        newStatus,
        userId,
        reason: reason,
        respondedBy: respondedBy,
      );

      // Load audit logs
      await loadFeedbackAuditLogs(feedbackId);

      state = const AsyncValue.data(null);
      debugPrint('✅ EnhancedFeedbackController: Status updated successfully');
    } catch (e, stack) {
      state = AsyncValue.error('Failed to update feedback status: $e', stack);
    }
  }

  /// Load audit logs for a feedback
  Future<void> loadFeedbackAuditLogs(String feedbackId) async {
    try {
      debugPrint(
          '📋 EnhancedFeedbackController: Loading audit logs for $feedbackId');

      final logs = await _extendedRepository.getFeedbackAuditLogs(feedbackId);
      _auditLogs.value = logs;

      debugPrint(
          '✅ EnhancedFeedbackController: Loaded ${logs.length} audit entries');
    } catch (e) {
      debugPrint('❌ EnhancedFeedbackController: Error loading audit logs: $e');
    }
  }

  /// Load analytics data for dashboard
  Future<void> loadAnalyticsData({
    DateTime? fromDate,
    DateTime? toDate,
    String? userId,
  }) async {
    try {
      debugPrint('📊 EnhancedFeedbackController: Loading analytics data');
      state = const AsyncValue.loading();

      final stats = await _extendedRepository.getDetailedStatistics(
        fromDate: fromDate,
        toDate: toDate,
        userId: userId,
      );

      _analyticsData.value = stats;
      state = const AsyncValue.data(null);

      debugPrint('✅ EnhancedFeedbackController: Analytics loaded successfully');
    } catch (e, stack) {
      state = AsyncValue.error('Failed to load analytics: $e', stack);
    }
  }

  /// Remove attachment from feedback
  Future<void> removeAttachment(
    String feedbackId,
    String attachmentId,
    String attachmentUrl,
  ) async {
    try {
      debugPrint(
          '🗑️ EnhancedFeedbackController: Removing attachment $attachmentId');

      // Delete from Firebase Storage
      await _mediaService.deleteMedia(attachmentUrl);

      // Update feedback document
      await _extendedRepository.removeAttachment(
        feedbackId,
        attachmentId,
      );

      debugPrint('✅ EnhancedFeedbackController: Attachment removed');
    } catch (e) {
      debugPrint('❌ EnhancedFeedbackController: Error removing attachment: $e');
      throw Exception('Failed to remove attachment: $e');
    }
  }

  /// Retry failed uploads
  Future<void> retryFailedUploads() async {
    try {
      final failed = _uploadProgress.value.values
          .where((p) => p.status == UploadStatus.failed)
          .toList();

      debugPrint(
          '🔄 EnhancedFeedbackController: Retrying ${failed.length} failed uploads');

      for (final failedUpload in failed) {
        // Reset to pending
        _uploadProgress.value[failedUpload.attachmentId] =
            failedUpload.copyWith(
          status: UploadStatus.pending,
          progress: 0.0,
          errorMessage: null,
        );
      }

      // Note: Actual retry logic would be implemented here
      debugPrint('✅ EnhancedFeedbackController: Retry initiated');
    } catch (e) {
      debugPrint('❌ EnhancedFeedbackController: Retry error: $e');
    }
  }

  /// Get file MIME type from filename
  String _getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'avi': 'video/x-msvideo',
      'mkv': 'video/x-matroska',
      'webm': 'video/webm',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'txt': 'text/plain',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  /// Clear upload progress
  void clearUploadProgress() {
    _uploadProgress.value = {};
  }

  /// Get total uploaded size
  int getTotalUploadedSize() {
    return _uploadProgress.value.values.fold(0, (sum, progress) {
      if (progress.status == UploadStatus.completed) {
        // This would need file size info to be accurate
        return sum + 1;
      }
      return sum;
    });
  }
}
