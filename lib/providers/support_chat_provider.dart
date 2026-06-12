import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/notification_model.dart';
import '../data/models/support_chat_models.dart';
import '../data/repositories/notification_repository.dart';
import '../data/services/support_chat_service.dart';
import '../data/services/support_data_service.dart';

final supportChatServiceProvider = Provider<SupportChatService>((ref) {
  return SupportChatService.instance;
});

final supportDataServiceProvider = Provider<SupportDataService>((ref) {
  return SupportDataService();
});

final supportConversationProvider =
    StreamProvider.family<SupportConversation?, String>((ref, userId) {
  final service = ref.watch(supportChatServiceProvider);
  return service.watchConversation(userId);
});

final supportChatMessagesProvider =
    StreamProvider.family<List<SupportChatMessage>, String>((ref, userId) {
  final service = ref.watch(supportChatServiceProvider);
  return service.watchMessages(userId);
});

class SupportChatComposerState {
  final bool isSending;
  final bool isAgentTyping;
  final String? error;
  final bool isResolved;

  const SupportChatComposerState({
    this.isSending = false,
    this.isAgentTyping = false,
    this.error,
    this.isResolved = false,
  });

  SupportChatComposerState copyWith({
    bool? isSending,
    bool? isAgentTyping,
    String? error,
    bool clearError = false,
    bool? isResolved,
  }) {
    return SupportChatComposerState(
      isSending: isSending ?? this.isSending,
      isAgentTyping: isAgentTyping ?? this.isAgentTyping,
      error: clearError ? null : (error ?? this.error),
      isResolved: isResolved ?? this.isResolved,
    );
  }
}

class SupportChatController extends StateNotifier<SupportChatComposerState> {
  SupportChatController(Ref ref)
      : _service = ref.read(supportChatServiceProvider),
        _notificationRepository = NotificationRepository(),
        _supportData = ref.read(supportDataServiceProvider),
        super(const SupportChatComposerState());

  final SupportChatService _service;
  final NotificationRepository _notificationRepository;
  final SupportDataService _supportData;

  Future<void> ensureConversation({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      await _service.ensureConversation(
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
    } catch (error) {
      state = state.copyWith(
        error: 'Unable to start support chat right now.',
      );
    }
  }

  Future<void> sendMessage({
    required String userId,
    required String userName,
    required String userEmail,
    required String message,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty || state.isSending) {
      return;
    }

    state = state.copyWith(isSending: true, clearError: true);

    try {
      final conversation = await _service.ensureConversation(
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
      final isNewTicket =
          conversation.lastMessage == 'Support conversation created';

      await _service.sendMessage(
        userId: userId,
        senderId: userId,
        senderName: userName,
        text: trimmed,
        isFromUser: true,
        status: SupportConversationStatus.waitingOnSupport,
      );

      if (isNewTicket) {
        await _createSupportTicketNotification(userId);
      }

      state = state.copyWith(
        isSending: false,
        isAgentTyping: true,
        isResolved: false,
        clearError: true,
      );

      unawaited(_sendAssistantReply(userId, trimmed));
    } catch (error) {
      state = state.copyWith(
        isSending: false,
        isAgentTyping: false,
        error: 'Message failed to send. Please try again.',
      );
    }
  }

  Future<void> resolveConversation(String userId) async {
    try {
      await _service.updateConversationStatus(
        userId: userId,
        status: SupportConversationStatus.resolved,
      );
      await _service.sendMessage(
        userId: userId,
        senderId: 'support_assistant',
        senderName: 'SafeDriver Assistant',
        text:
            'This conversation has been marked as resolved. Send a new message anytime if you still need help.',
        isFromUser: false,
        status: SupportConversationStatus.resolved,
      );
      state = state.copyWith(isResolved: true, clearError: true);
    } catch (error) {
      state = state.copyWith(
        error: 'Unable to update conversation status right now.',
      );
    }
  }

  Future<void> _createSupportTicketNotification(String userId) async {
    try {
      await _notificationRepository.createUserNotification(
        userId: userId,
        type: NotificationType.general,
        title: 'Support Ticket Submitted',
        body: 'Your support ticket has been submitted. We will help you here.',
        data: {
          'source': 'support_chat',
        },
        actionUrl: '/support',
      );
    } catch (_) {
      // Message delivery is the important action; notification is secondary.
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> _sendAssistantReply(String userId, String message) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final reply = _buildAssistantReply(message);
    await _service.sendMessage(
      userId: userId,
      senderId: 'support_assistant',
      senderName: 'SafeDriver Assistant',
      text: reply,
      isFromUser: false,
      status: SupportConversationStatus.waitingOnUser,
    );

    state = state.copyWith(
      isAgentTyping: false,
      clearError: true,
    );
  }

  String _buildAssistantReply(String userMessage) {
    final message = userMessage.toLowerCase();

    if (_matchesAny(message, ['bus', 'route', 'driver', 'schedule'])) {
      return 'I can help with bus service issues. Please share the route, time, bus details, or what exactly went wrong so support can guide you faster.';
    }

    if (_matchesAny(message, ['location', 'gps', 'map', 'tracking'])) {
      return 'For location issues, make sure device location services are on and SafeDriver has permission to use location. You can also reopen the app after enabling GPS.';
    }

    if (_matchesAny(message, ['login', 'password', 'account', 'otp'])) {
      return 'For account access help, tell me whether the issue is password reset, OTP delivery, or sign-in failure. I can guide you step by step.';
    }

    if (_matchesAny(message, ['notification', 'alert', 'message'])) {
      return 'If notifications are not arriving, confirm that device notifications are enabled for SafeDriver and that in-app notification preferences are still on.';
    }

    if (_matchesAny(message, ['crash', 'bug', 'not working', 'error'])) {
      return 'Sorry you ran into that. Please share what action caused the issue, your device type, and any error text you saw so support can narrow it down quickly.';
    }

    if (_matchesAny(message, ['hello', 'hi', 'hey'])) {
      return 'Hello. Tell me what went wrong, and I will help route you to the quickest fix.';
    }

    if (_matchesAny(message, ['thanks', 'thank you'])) {
      return 'You are welcome. If anything is still unclear, send one more message and I will keep helping.';
    }

    final issues = _supportData.searchSupportIssues(userMessage);
    if (issues.isNotEmpty) {
      final issue = issues.first;
      return 'This sounds related to "${issue.title}". Try the solutions in that support category as well, and send any route details, phone number, device details, or screenshots you want support to review.';
    }

    return 'Thanks for sharing that. Please add any useful details like route, bus details, device type, or screenshot notes, and SafeDriver support will continue from there.';
  }

  bool _matchesAny(String source, List<String> terms) {
    return terms.any(source.contains);
  }
}

final supportChatControllerProvider = StateNotifierProvider.autoDispose<
    SupportChatController, SupportChatComposerState>((ref) {
  return SupportChatController(ref);
});
