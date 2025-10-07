import 'location_model.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String? userName;
  final String? busId;
  final String? busNumber;
  final String? driverId;
  final String? driverName;
  final String? routeId;
  final String? routeNumber;
  final FeedbackCategory category;
  final FeedbackType type;
  final String title;
  final String description;
  final FeedbackRating rating;
  final List<String> tags;
  final List<FeedbackAttachment> attachments;
  final LocationModel? location;
  final DateTime timestamp;
  final FeedbackStatus status;
  final bool isAnonymous;
  final FeedbackPriority priority;
  final String? response;
  final String? respondedBy;
  final DateTime? respondedAt;
  final Map<String, dynamic> metadata;
  final bool isPublic;
  final int helpfulCount;
  final List<String> relatedFeedbackIds;
  // Missing properties used in controller
  final String comment;
  final List<String> images;
  final DateTime submittedAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    this.userName,
    this.busId,
    this.busNumber,
    this.driverId,
    this.driverName,
    this.routeId,
    this.routeNumber,
    required this.category,
    required this.type,
    required this.title,
    required this.description,
    required this.rating,
    required this.tags,
    required this.attachments,
    this.location,
    required this.timestamp,
    required this.status,
    this.isAnonymous = false,
    required this.priority,
    this.response,
    this.respondedBy,
    this.respondedAt,
    required this.metadata,
    this.isPublic = false,
    this.helpfulCount = 0,
    required this.relatedFeedbackIds,
    // New required properties
    required this.comment,
    required this.images,
    required this.submittedAt,
  });

  String get categoryDisplay {
    switch (category) {
      case FeedbackCategory.safety:
        return 'Safety';
      case FeedbackCategory.service:
        return 'Service';
      case FeedbackCategory.comfort:
        return 'Comfort';
      case FeedbackCategory.driver:
        return 'Driver';
      case FeedbackCategory.vehicle:
        return 'Vehicle';
      case FeedbackCategory.route:
        return 'Route';
      case FeedbackCategory.general:
        return 'General';
      case FeedbackCategory.suggestion:
        return 'Suggestion';
      case FeedbackCategory.complaint:
        return 'Complaint';
      case FeedbackCategory.compliment:
        return 'Compliment';
    }
  }

  String get typeDisplay {
    switch (type) {
      case FeedbackType.positive:
        return 'Positive';
      case FeedbackType.negative:
        return 'Negative';
      case FeedbackType.neutral:
        return 'Neutral';
      case FeedbackType.suggestion:
        return 'Suggestion';
      case FeedbackType.inquiry:
        return 'Inquiry';
      case FeedbackType.urgent:
        return 'Urgent';
      case FeedbackType.general:
        return 'General';
    }
  }

  String get statusDisplay {
    switch (status) {
      case FeedbackStatus.submitted:
        return 'Submitted';
      case FeedbackStatus.received:
        return 'Received';
      case FeedbackStatus.inReview:
        return 'In Review';
      case FeedbackStatus.responded:
        return 'Responded';
      case FeedbackStatus.resolved:
        return 'Resolved';
      case FeedbackStatus.closed:
        return 'Closed';
      case FeedbackStatus.escalated:
        return 'Escalated';
    }
  }

  String get priorityDisplay {
    switch (priority) {
      case FeedbackPriority.low:
        return 'Low';
      case FeedbackPriority.medium:
        return 'Medium';
      case FeedbackPriority.high:
        return 'High';
      case FeedbackPriority.urgent:
        return 'Urgent';
    }
  }

  String get ratingDisplay {
    switch (rating.overall) {
      case 5:
        return 'Excellent';
      case 4:
        return 'Good';
      case 3:
        return 'Average';
      case 2:
        return 'Poor';
      case 1:
        return 'Very Poor';
      default:
        return 'Not Rated';
    }
  }

  bool get hasResponse => response != null && response!.isNotEmpty;

  bool get isResolved =>
      status == FeedbackStatus.resolved || status == FeedbackStatus.closed;

  Duration get timeSinceSubmission => DateTime.now().difference(timestamp);

  String get timeAgo {
    final duration = timeSinceSubmission;
    if (duration.inMinutes < 1) return 'Just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    if (duration.inDays < 7) return '${duration.inDays}d ago';
    if (duration.inDays < 30) return '${(duration.inDays / 7).floor()}w ago';
    return '${(duration.inDays / 30).floor()}mo ago';
  }

  String get authorDisplay => isAnonymous ? 'Anonymous' : (userName ?? 'User');

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'],
      busId: json['busId'],
      busNumber: json['busNumber'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      routeId: json['routeId'],
      routeNumber: json['routeNumber'],
      category: FeedbackCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => FeedbackCategory.general,
      ),
      type: FeedbackType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => FeedbackType.neutral,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      rating: FeedbackRating.fromJson(json['rating'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => FeedbackAttachment.fromJson(e))
              .toList() ??
          [],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      status: FeedbackStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => FeedbackStatus.submitted,
      ),
      isAnonymous: json['isAnonymous'] ?? false,
      priority: FeedbackPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => FeedbackPriority.medium,
      ),
      response: json['response'],
      respondedBy: json['respondedBy'],
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isPublic: json['isPublic'] ?? false,
      helpfulCount: json['helpfulCount'] ?? 0,
      relatedFeedbackIds: List<String>.from(json['relatedFeedbackIds'] ?? []),
      // New required properties
      comment: json['comment'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      submittedAt: DateTime.parse(
          json['submittedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'busId': busId,
      'busNumber': busNumber,
      'driverId': driverId,
      'driverName': driverName,
      'routeId': routeId,
      'routeNumber': routeNumber,
      'category': category.toString().split('.').last,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'rating': rating.toJson(),
      'tags': tags,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'location': location?.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
      'isAnonymous': isAnonymous,
      'priority': priority.toString().split('.').last,
      'response': response,
      'respondedBy': respondedBy,
      'respondedAt': respondedAt?.toIso8601String(),
      'metadata': metadata,
      'isPublic': isPublic,
      'helpfulCount': helpfulCount,
      'relatedFeedbackIds': relatedFeedbackIds,
      // New properties
      'comment': comment,
      'images': images,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? busId,
    String? busNumber,
    String? driverId,
    String? driverName,
    String? routeId,
    String? routeNumber,
    FeedbackCategory? category,
    FeedbackType? type,
    String? title,
    String? description,
    FeedbackRating? rating,
    List<String>? tags,
    List<FeedbackAttachment>? attachments,
    LocationModel? location,
    DateTime? timestamp,
    FeedbackStatus? status,
    bool? isAnonymous,
    FeedbackPriority? priority,
    String? response,
    String? respondedBy,
    DateTime? respondedAt,
    Map<String, dynamic>? metadata,
    bool? isPublic,
    int? helpfulCount,
    List<String>? relatedFeedbackIds,
    // New parameters
    String? comment,
    List<String>? images,
    DateTime? submittedAt,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      busId: busId ?? this.busId,
      busNumber: busNumber ?? this.busNumber,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      routeId: routeId ?? this.routeId,
      routeNumber: routeNumber ?? this.routeNumber,
      category: category ?? this.category,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      priority: priority ?? this.priority,
      response: response ?? this.response,
      respondedBy: respondedBy ?? this.respondedBy,
      respondedAt: respondedAt ?? this.respondedAt,
      metadata: metadata ?? this.metadata,
      isPublic: isPublic ?? this.isPublic,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      relatedFeedbackIds: relatedFeedbackIds ?? this.relatedFeedbackIds,
      // New required properties
      comment: comment ?? this.comment,
      images: images ?? this.images,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FeedbackModel(id: $id, category: $category, type: $type, status: $status)';
  }
}

enum FeedbackCategory {
  safety,
  service,
  comfort,
  driver,
  vehicle,
  route,
  general,
  suggestion,
  complaint,
  compliment,
}

enum FeedbackType {
  positive,
  negative,
  neutral,
  suggestion,
  inquiry,
  urgent,
  general, // Missing constant used in feedback_controller
}

enum FeedbackStatus {
  submitted,
  received,
  inReview,
  responded,
  resolved,
  closed,
  escalated,
}

enum FeedbackPriority {
  low,
  medium,
  high,
  urgent,
}

class FeedbackRating {
  final int overall;
  final int? safety;
  final int? comfort;
  final int? cleanliness;
  final int? punctuality;
  final int? driverBehavior;
  final int? vehicleCondition;

  FeedbackRating({
    required this.overall,
    this.safety,
    this.comfort,
    this.cleanliness,
    this.punctuality,
    this.driverBehavior,
    this.vehicleCondition,
  });

  // Static enum-like values for compatibility
  static final List<FeedbackRating> values = [
    FeedbackRating(overall: 1), // terrible
    FeedbackRating(overall: 2), // poor
    FeedbackRating(overall: 3), // average
    FeedbackRating(overall: 4), // good
    FeedbackRating(overall: 5), // excellent
  ];

  static FeedbackRating get terrible => values[0];
  static FeedbackRating get poor => values[1];
  static FeedbackRating get average => values[2];
  static FeedbackRating get good => values[3];
  static FeedbackRating get excellent => values[4];

  double get averageRating {
    final ratings = [
      safety,
      comfort,
      cleanliness,
      punctuality,
      driverBehavior,
      vehicleCondition
    ].where((rating) => rating != null).cast<int>();

    if (ratings.isEmpty) return overall.toDouble();

    final sum = ratings.reduce((a, b) => a + b);
    return sum / ratings.length;
  }

  bool get hasDetailedRatings =>
      safety != null ||
      comfort != null ||
      cleanliness != null ||
      punctuality != null ||
      driverBehavior != null ||
      vehicleCondition != null;

  factory FeedbackRating.fromJson(Map<String, dynamic> json) {
    return FeedbackRating(
      overall: json['overall'] ?? 0,
      safety: json['safety'],
      comfort: json['comfort'],
      cleanliness: json['cleanliness'],
      punctuality: json['punctuality'],
      driverBehavior: json['driverBehavior'],
      vehicleCondition: json['vehicleCondition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'safety': safety,
      'comfort': comfort,
      'cleanliness': cleanliness,
      'punctuality': punctuality,
      'driverBehavior': driverBehavior,
      'vehicleCondition': vehicleCondition,
    };
  }

  FeedbackRating copyWith({
    int? overall,
    int? safety,
    int? comfort,
    int? cleanliness,
    int? punctuality,
    int? driverBehavior,
    int? vehicleCondition,
  }) {
    return FeedbackRating(
      overall: overall ?? this.overall,
      safety: safety ?? this.safety,
      comfort: comfort ?? this.comfort,
      cleanliness: cleanliness ?? this.cleanliness,
      punctuality: punctuality ?? this.punctuality,
      driverBehavior: driverBehavior ?? this.driverBehavior,
      vehicleCondition: vehicleCondition ?? this.vehicleCondition,
    );
  }
}

class FeedbackAttachment {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;
  final String? thumbnail;
  final Map<String, dynamic> metadata;

  FeedbackAttachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    this.thumbnail,
    required this.metadata,
  });

  bool get isImage => fileType.startsWith('image/');
  bool get isVideo => fileType.startsWith('video/');
  bool get isAudio => fileType.startsWith('audio/');

  String get fileSizeDisplay {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  factory FeedbackAttachment.fromJson(Map<String, dynamic> json) {
    return FeedbackAttachment(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      uploadedAt: DateTime.parse(
          json['uploadedAt'] ?? DateTime.now().toIso8601String()),
      thumbnail: json['thumbnail'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toIso8601String(),
      'thumbnail': thumbnail,
      'metadata': metadata,
    };
  }
}

// Helper class for feedback statistics
class FeedbackStatistics {
  final int totalFeedback;
  final int positiveFeedback;
  final int negativeFeedback;
  final int neutralFeedback;
  final double averageRating;
  final Map<FeedbackCategory, int> feedbackByCategory;
  final Map<FeedbackStatus, int> feedbackByStatus;
  final Map<int, int> ratingDistribution;

  FeedbackStatistics({
    required this.totalFeedback,
    required this.positiveFeedback,
    required this.negativeFeedback,
    required this.neutralFeedback,
    required this.averageRating,
    required this.feedbackByCategory,
    required this.feedbackByStatus,
    required this.ratingDistribution,
  });

  factory FeedbackStatistics.fromFeedback(List<FeedbackModel> feedback) {
    final feedbackByCategory = <FeedbackCategory, int>{};
    final feedbackByStatus = <FeedbackStatus, int>{};
    final ratingDistribution = <int, int>{};

    double totalRating = 0;
    int ratedFeedback = 0;

    for (final item in feedback) {
      feedbackByCategory[item.category] =
          (feedbackByCategory[item.category] ?? 0) + 1;
      feedbackByStatus[item.status] = (feedbackByStatus[item.status] ?? 0) + 1;

      if (item.rating.overall > 0) {
        ratingDistribution[item.rating.overall] =
            (ratingDistribution[item.rating.overall] ?? 0) + 1;
        totalRating += item.rating.overall;
        ratedFeedback++;
      }
    }

    return FeedbackStatistics(
      totalFeedback: feedback.length,
      positiveFeedback:
          feedback.where((f) => f.type == FeedbackType.positive).length,
      negativeFeedback:
          feedback.where((f) => f.type == FeedbackType.negative).length,
      neutralFeedback:
          feedback.where((f) => f.type == FeedbackType.neutral).length,
      averageRating: ratedFeedback > 0 ? totalRating / ratedFeedback : 0.0,
      feedbackByCategory: feedbackByCategory,
      feedbackByStatus: feedbackByStatus,
      ratingDistribution: ratingDistribution,
    );
  }

  double get satisfactionRate {
    return totalFeedback > 0 ? positiveFeedback / totalFeedback : 0.0;
  }

  double get resolutionRate {
    final resolved = feedbackByStatus[FeedbackStatus.resolved] ?? 0;
    final closed = feedbackByStatus[FeedbackStatus.closed] ?? 0;
    return totalFeedback > 0 ? (resolved + closed) / totalFeedback : 0.0;
  }
}
