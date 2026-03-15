import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification types
enum NotificationType {
  registration,      // Account created
  login,            // First login - welcome
  feedback,         // Feedback submitted
  feedbackStatus,   // Feedback status update
  profile,          // Profile updated
  journey,          // Active journey notification
  general,          // General app notification
}

/// Notification priorities
enum NotificationPriority {
  low,
  normal,
  high,
}

/// Notification status
enum NotificationStatus {
  sent,
  delivered,
  read,
  failed,
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final NotificationPriority priority;
  final NotificationStatus status;
  final DateTime sentAt;
  final DateTime? readAt;
  final DateTime? deliveredAt;
  final bool isSilent;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    this.data,
    this.priority = NotificationPriority.normal,
    this.status = NotificationStatus.sent,
    required this.sentAt,
    this.readAt,
    this.deliveredAt,
    this.isSilent = false,
    this.actionUrl,
  });

  /// Get notification emoji based on type
  String get typeEmoji {
    switch (type) {
      case NotificationType.registration:
        return '🎉';
      case NotificationType.login:
        return '👋';
      case NotificationType.feedback:
        return '💬';
      case NotificationType.feedbackStatus:
        return '📝';
      case NotificationType.profile:
        return '👤';
      case NotificationType.journey:
        return '🚌';
      case NotificationType.general:
        return '📢';
    }
  }

  /// Check if notification is read
  bool get isRead => status == NotificationStatus.read;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == (json['type'] ?? ''),
        orElse: () => NotificationType.general,
      ),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      imageUrl: json['imageUrl'],
      data: json['data'],
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == (json['priority'] ?? 'normal'),
        orElse: () => NotificationPriority.normal,
      ),
      status: NotificationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'sent'),
        orElse: () => NotificationStatus.sent,
      ),
      sentAt: json['sentAt'] != null
          ? (json['sentAt'] is Timestamp
              ? (json['sentAt'] as Timestamp).toDate()
              : DateTime.parse(json['sentAt']))
          : DateTime.now(),
      readAt: json['readAt'] != null
          ? (json['readAt'] is Timestamp
              ? (json['readAt'] as Timestamp).toDate()
              : DateTime.parse(json['readAt']))
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? (json['deliveredAt'] is Timestamp
              ? (json['deliveredAt'] as Timestamp).toDate()
              : DateTime.parse(json['deliveredAt']))
          : null,
      isSilent: json['isSilent'] ?? false,
      actionUrl: json['actionUrl'],
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type.toString().split('.').last,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'data': data,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'sentAt': Timestamp.fromDate(sentAt),
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
      'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'isSilent': isSilent,
      'actionUrl': actionUrl,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, dynamic>? data,
    NotificationPriority? priority,
    NotificationStatus? status,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? deliveredAt,
    bool? isSilent,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      isSilent: isSilent ?? this.isSilent,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}
