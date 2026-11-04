import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/support_chat_models.dart';

class SupportChatService {
  static final SupportChatService _instance = SupportChatService._internal();
  static SupportChatService get instance => _instance;

  SupportChatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'support_conversations';
  final String _messagesCollection = 'messages';

  DocumentReference<Map<String, dynamic>> _conversationRef(String userId) {
    return _firestore.collection(_collection).doc(userId);
  }

  CollectionReference<Map<String, dynamic>> _messagesRef(String userId) {
    return _conversationRef(userId).collection(_messagesCollection);
  }

  Stream<SupportConversation?> watchConversation(String userId) {
    return _conversationRef(userId).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return SupportConversation.fromFirestore(doc);
    });
  }

  Stream<List<SupportChatMessage>> watchMessages(String userId) {
    return _messagesRef(userId).orderBy('createdAt').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => SupportChatMessage.fromFirestore(userId, doc))
            .toList());
  }

  Future<SupportConversation> ensureConversation({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    final conversationReference = _conversationRef(userId);
    final snapshot = await conversationReference.get();

    if (snapshot.exists) {
      return SupportConversation.fromFirestore(snapshot);
    }

    final now = DateTime.now();
    final conversation = SupportConversation(
      id: userId,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      status: SupportConversationStatus.open,
      lastMessage: 'Support conversation created',
      createdAt: now,
      updatedAt: now,
      assignedAgentName: 'SafeDriver Assistant',
    );

    final batch = _firestore.batch();
    batch.set(conversationReference, conversation.toJson());

    final welcomeMessages = [
      SupportChatMessage(
        id: '',
        conversationId: userId,
        senderId: 'support_assistant',
        senderName: 'SafeDriver Assistant',
        text: 'Welcome to SafeDriver Support.',
        isFromUser: false,
        createdAt: now,
      ),
      SupportChatMessage(
        id: '',
        conversationId: userId,
        senderId: 'support_assistant',
        senderName: 'SafeDriver Assistant',
        text:
            'Share your issue here and we will guide you right away. For emergencies, please call 0112123123 immediately.',
        isFromUser: false,
        createdAt: now.add(const Duration(seconds: 1)),
      ),
    ];

    for (final message in welcomeMessages) {
      batch.set(_messagesRef(userId).doc(), message.toJson());
    }

    await batch.commit();
    return conversation;
  }

  Future<void> sendMessage({
    required String userId,
    required String senderId,
    required String senderName,
    required String text,
    required bool isFromUser,
    SupportConversationStatus? status,
  }) async {
    final now = DateTime.now();
    final message = SupportChatMessage(
      id: '',
      conversationId: userId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      isFromUser: isFromUser,
      createdAt: now,
    );

    final batch = _firestore.batch();
    batch.set(_messagesRef(userId).doc(), message.toJson());
    batch.set(
      _conversationRef(userId),
      {
        'lastMessage': text,
        'updatedAt': now.toIso8601String(),
        if (status != null) 'status': status.value,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<void> updateConversationStatus({
    required String userId,
    required SupportConversationStatus status,
  }) async {
    await _conversationRef(userId).set(
      {
        'status': status.value,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      SetOptions(merge: true),
    );
  }
}
