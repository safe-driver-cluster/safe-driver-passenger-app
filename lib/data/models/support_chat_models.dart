import 'package:cloud_firestore/cloud_firestore.dart';

enum SupportConversationStatus {
  open,
  waitingOnSupport,
  waitingOnUser,
  resolved,
}

extension SupportConversationStatusX on SupportConversationStatus {
  String get value {
    switch (this) {
      case SupportConversationStatus.open:
        return 'open';
      case SupportConversationStatus.waitingOnSupport:
        return 'waiting_on_support';
      case SupportConversationStatus.waitingOnUser:
        return 'waiting_on_user';
      case SupportConversationStatus.resolved:
        return 'resolved';
    }
  }

  static SupportConversationStatus fromValue(String? value) {
    switch (value) {
      case 'waiting_on_support':
        return SupportConversationStatus.waitingOnSupport;
      case 'waiting_on_user':
        return SupportConversationStatus.waitingOnUser;
      case 'resolved':
        return SupportConversationStatus.resolved;
      case 'open':
      default:
        return SupportConversationStatus.open;
    }
  }
}

class SupportConversation {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final SupportConversationStatus status;
  final String lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCountForUser;
  final String? assignedAgentName;

  const SupportConversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.status,
    required this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCountForUser = 0,
    this.assignedAgentName,
  });

  factory SupportConversation.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return SupportConversation(
      id: doc.id,
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Passenger',
      userEmail: json['userEmail'] ?? '',
      status: SupportConversationStatusX.fromValue(json['status'] as String?),
      lastMessage: json['lastMessage'] ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      unreadCountForUser: (json['unreadCountForUser'] ?? 0) as int,
      assignedAgentName: json['assignedAgentName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'status': status.value,
      'lastMessage': lastMessage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'unreadCountForUser': unreadCountForUser,
      'assignedAgentName': assignedAgentName,
    };
  }
}

class SupportChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String text;
  final bool isFromUser;
  final DateTime createdAt;
  final String type;

  const SupportChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.isFromUser,
    required this.createdAt,
    this.type = 'text',
  });

  factory SupportChatMessage.fromFirestore(
    String conversationId,
    DocumentSnapshot doc,
  ) {
    final json = doc.data() as Map<String, dynamic>? ?? <String, dynamic>{};

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return SupportChatMessage(
      id: doc.id,
      conversationId: conversationId,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'Support',
      text: json['text'] ?? '',
      isFromUser: json['isFromUser'] ?? false,
      createdAt: parseDate(json['createdAt']),
      type: json['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'isFromUser': isFromUser,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
    };
  }
}
