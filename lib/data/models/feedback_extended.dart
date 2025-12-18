/// Extension classes for enhanced feedback model functionality
/// Supports advanced attachment tracking and multimedia handling
library;

import 'feedback_model.dart';

/// Extended feedback with enhanced attachment capabilities
class FeedbackWithAttachments extends FeedbackModel {
  final List<AttachmentProgress> uploadProgress;
  final bool isUploading;

  FeedbackWithAttachments({
    required super.id,
    required super.userId,
    super.userName,
    super.busId,
    super.busNumber,
    super.driverId,
    super.driverName,
    super.routeId,
    super.routeNumber,
    required super.category,
    required super.type,
    required super.title,
    required super.description,
    required super.rating,
    required super.tags,
    required super.attachments,
    super.location,
    required super.timestamp,
    required super.status,
    super.isAnonymous = false,
    required super.priority,
    super.response,
    super.respondedBy,
    super.respondedAt,
    required super.metadata,
    super.isPublic = false,
    super.helpfulCount = 0,
    required super.relatedFeedbackIds,
    required super.comment,
    required super.images,
    required super.submittedAt,
    this.uploadProgress = const [],
    this.isUploading = false,
  });

  int get attachmentCount => attachments.length;
  int get totalFileSize =>
      attachments.fold(0, (sum, attachment) => sum + attachment.fileSize);
  int get imageCount => attachments.where((a) => a.isImage).length;
  int get videoCount => attachments.where((a) => a.isVideo).length;
  int get documentCount =>
      attachments.where((a) => !a.isImage && !a.isVideo && !a.isAudio).length;

  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasImages => imageCount > 0;
  bool get hasVideos => videoCount > 0;

  double get overallUploadProgress {
    if (uploadProgress.isEmpty) return 0.0;
    final totalProgress =
        uploadProgress.fold<double>(0, (sum, p) => sum + p.progress);
    return totalProgress / uploadProgress.length;
  }

  List<AttachmentProgress> get pendingUploads =>
      uploadProgress.where((p) => p.status == UploadStatus.pending).toList();
  List<AttachmentProgress> get failedUploads =>
      uploadProgress.where((p) => p.status == UploadStatus.failed).toList();
}

/// Tracks progress of a single attachment upload
class AttachmentProgress {
  final String attachmentId;
  final String fileName;
  final double progress; // 0.0 to 1.0
  final UploadStatus status;
  final String? errorMessage;
  final DateTime startTime;
  final String? fileUrl;

  AttachmentProgress({
    required this.attachmentId,
    required this.fileName,
    this.progress = 0.0,
    this.status = UploadStatus.pending,
    this.errorMessage,
    DateTime? startTime,
    this.fileUrl,
  }) : startTime = startTime ?? DateTime.now();

  Duration get elapsedTime => DateTime.now().difference(startTime);

  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';

  bool get isCompleted => status == UploadStatus.completed;
  bool get isFailed => status == UploadStatus.failed;
  bool get isUploading => status == UploadStatus.uploading;

  AttachmentProgress copyWith({
    String? attachmentId,
    String? fileName,
    double? progress,
    UploadStatus? status,
    String? errorMessage,
    DateTime? startTime,
    String? fileUrl,
  }) {
    return AttachmentProgress(
      attachmentId: attachmentId ?? this.attachmentId,
      fileName: fileName ?? this.fileName,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      startTime: startTime ?? this.startTime,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}

enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
  cancelled,
}

/// Batch attachment upload configuration
class BatchAttachmentConfig {
  final int maxConcurrentUploads;
  final int maxFileSize; // in bytes
  final List<String> allowedMimeTypes;
  final bool retryOnFailure;
  final int retryAttempts;

  BatchAttachmentConfig({
    this.maxConcurrentUploads = 3,
    this.maxFileSize = 10485760, // 10 MB
    this.allowedMimeTypes = const [
      'image/jpeg',
      'image/png',
      'image/gif',
      'image/webp',
      'video/mp4',
      'video/quicktime',
      'video/x-msvideo',
      'video/x-matroska',
      'application/pdf',
    ],
    this.retryOnFailure = true,
    this.retryAttempts = 3,
  });
}

/// Feedback with audit trail for status changes
class FeedbackAuditLog {
  final String feedbackId;
  final String userId;
  final FeedbackStatus fromStatus;
  final FeedbackStatus toStatus;
  final String? reason;
  final DateTime timestamp;
  final String? actionPerformedBy;
  final Map<String, dynamic> metadata;

  FeedbackAuditLog({
    required this.feedbackId,
    required this.userId,
    required this.fromStatus,
    required this.toStatus,
    this.reason,
    DateTime? timestamp,
    this.actionPerformedBy,
    this.metadata = const {},
  }) : timestamp = timestamp ?? DateTime.now();

  factory FeedbackAuditLog.fromJson(Map<String, dynamic> json) {
    return FeedbackAuditLog(
      feedbackId: json['feedbackId'] ?? '',
      userId: json['userId'] ?? '',
      fromStatus: FeedbackStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['fromStatus'],
        orElse: () => FeedbackStatus.submitted,
      ),
      toStatus: FeedbackStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['toStatus'],
        orElse: () => FeedbackStatus.submitted,
      ),
      reason: json['reason'],
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      actionPerformedBy: json['actionPerformedBy'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedbackId': feedbackId,
      'userId': userId,
      'fromStatus': fromStatus.toString().split('.').last,
      'toStatus': toStatus.toString().split('.').last,
      'reason': reason,
      'timestamp': timestamp.toIso8601String(),
      'actionPerformedBy': actionPerformedBy,
      'metadata': metadata,
    };
  }
}
