import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/support_chat_models.dart';
import '../../../providers/passenger_provider.dart';
import '../../../providers/support_chat_provider.dart';
import '../../widgets/common/profile_page_components.dart';

class LiveChatPage extends ConsumerStatefulWidget {
  const LiveChatPage({super.key});

  @override
  ConsumerState<LiveChatPage> createState() => _LiveChatPageState();
}

class _LiveChatPageState extends ConsumerState<LiveChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _initializedUserId;
  int _lastRenderedMessageCount = 0;

  static const List<String> _quickPrompts = [
    'App not working',
    'Location issue',
    'Account issue',
    'Bus service issue',
    'Notifications issue',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final passengerAsync = ref.watch(currentPassengerProvider);
    final composerState = ref.watch(supportChatControllerProvider);

    if (user == null) {
      return Scaffold(
        backgroundColor: th.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDesign.spaceXL),
            child: Text(
              'Please sign in to start a live chat with support.',
              style: AppTextStyles.bodyLarge.copyWith(color: th.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final passenger = passengerAsync.asData?.value;
    final userName = passenger?.displayName.trim().isNotEmpty == true
        ? passenger!.displayName
        : (user.displayName?.trim().isNotEmpty == true
            ? user.displayName!
            : 'Passenger');
    final userEmail = passenger?.email.isNotEmpty == true
        ? passenger!.email
        : (user.email ?? '');

    _ensureConversationReady(
      userId: user.uid,
      userName: userName,
      userEmail: userEmail,
    );

    final messagesAsync = ref.watch(supportChatMessagesProvider(user.uid));
    final conversationAsync = ref.watch(supportConversationProvider(user.uid));

    final messages =
        messagesAsync.asData?.value ?? const <SupportChatMessage>[];
    _scheduleScroll(messages.length + (composerState.isAgentTyping ? 1 : 0));

    return ProfilePageScaffold(
      title: 'Live Chat Support',
      accentColor: AppColors.primaryColor,
      children: [
        _buildHeroCard(context, composerState, conversationAsync),
        const SizedBox(height: AppDesign.spaceLG),
        _buildConversationCard(
          context: context,
          userId: user.uid,
          userName: userName,
          userEmail: userEmail,
          conversationAsync: conversationAsync,
          messagesAsync: messagesAsync,
          composerState: composerState,
        ),
      ],
    );
  }

  void _ensureConversationReady({
    required String userId,
    required String userName,
    required String userEmail,
  }) {
    if (_initializedUserId == userId) {
      return;
    }

    _initializedUserId = userId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(supportChatControllerProvider.notifier).ensureConversation(
            userId: userId,
            userName: userName,
            userEmail: userEmail,
          );
    });
  }

  void _scheduleScroll(int itemCount) {
    if (_lastRenderedMessageCount == itemCount) {
      return;
    }

    _lastRenderedMessageCount = itemCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildHeroCard(
    BuildContext context,
    SupportChatComposerState composerState,
    AsyncValue<SupportConversation?> conversationAsync,
  ) {
    final th = ThemeHelper.of(context);
    final conversation = conversationAsync.asData?.value;
    final status = conversation?.status ?? SupportConversationStatus.open;

    final (title, subtitle, color, icon) = switch (status) {
      SupportConversationStatus.open => (
          'Support is ready',
          'Start a conversation and keep all your support updates in one place.',
          AppColors.successColor,
          Icons.support_agent_rounded,
        ),
      SupportConversationStatus.waitingOnSupport => (
          'Waiting on support',
          'Your latest message is in the queue and a reply is on the way.',
          AppColors.warningColor,
          Icons.schedule_rounded,
        ),
      SupportConversationStatus.waitingOnUser => (
          'Waiting on you',
          'Reply with more details, screenshots, route info, or device details if needed.',
          AppColors.primaryColor,
          Icons.mark_chat_unread_rounded,
        ),
      SupportConversationStatus.resolved => (
          'Conversation resolved',
          'You can still send another message if you need more help.',
          AppColors.infoColor,
          Icons.verified_rounded,
        ),
    };

    return ProfileSectionCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.14),
              AppColors.primaryColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Icon(
                    composerState.isAgentTyping
                        ? Icons.more_horiz_rounded
                        : icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headline6.copyWith(
                          color: th.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        composerState.isAgentTyping
                            ? 'Support is typing a reply now.'
                            : subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: th.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  ),
                  child: Text(
                    _formatStatusLabel(status),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                if (conversation != null &&
                    status != SupportConversationStatus.resolved)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceSM,
                        vertical: AppDesign.spaceXS,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => ref
                        .read(supportChatControllerProvider.notifier)
                        .resolveConversation(conversation.id),
                    child: const Text('Mark Resolved'),
                  ),
              ],
            ),
            if (composerState.error != null) ...[
              const SizedBox(height: AppDesign.spaceMD),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.errorColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  border: Border.all(
                    color: AppColors.errorColor.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  composerState.error!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConversationCard({
    required BuildContext context,
    required String userId,
    required String userName,
    required String userEmail,
    required AsyncValue<SupportConversation?> conversationAsync,
    required AsyncValue<List<SupportChatMessage>> messagesAsync,
    required SupportChatComposerState composerState,
  }) {
    final th = ThemeHelper.of(context);
    final conversation = conversationAsync.asData?.value;
    final isResolved =
        conversation?.status == SupportConversationStatus.resolved;

    return ProfileSectionCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 580,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppDesign.spaceLG,
                AppDesign.spaceLG,
                AppDesign.spaceLG,
                AppDesign.spaceMD,
              ),
              decoration: BoxDecoration(
                color: th.subtleBackground.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDesign.radiusXL),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Conversation',
                          style: AppTextStyles.headline6.copyWith(
                            color: th.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppDesign.spaceXS),
                        Text(
                          'Continue the same support thread until your issue is solved.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: th.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (conversation != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceSM,
                        vertical: AppDesign.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusFull),
                      ),
                      child: Text(
                        _formatStatusLabel(conversation.status),
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: th.cardBackground,
                child: messagesAsync.when(
                  data: (messages) {
                    if (messages.isEmpty) {
                      return _buildEmptyConversation(context);
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppDesign.spaceLG,
                        AppDesign.spaceLG,
                        AppDesign.spaceLG,
                        AppDesign.spaceLG,
                      ),
                      itemCount: messages.length +
                          (composerState.isAgentTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= messages.length) {
                          return _buildTypingBubble(context);
                        }
                        return _buildMessageBubble(context, messages[index]);
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDesign.spaceXL),
                      child: Text(
                        'Unable to load conversation right now.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: th.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: th.cardBackground,
                border: Border(
                  top: BorderSide(color: th.borderLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _quickPrompts
                          .map(
                            (prompt) => Padding(
                              padding: const EdgeInsets.only(
                                right: AppDesign.spaceSM,
                                bottom: AppDesign.spaceMD,
                              ),
                              child: _QuickPromptChip(
                                label: prompt,
                                onTap: composerState.isSending
                                    ? null
                                    : () => _sendPrompt(
                                          prompt,
                                          userId: userId,
                                          userName: userName,
                                          userEmail: userEmail,
                                        ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: th.subtleBackground,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusXL),
                            border: Border.all(color: th.borderLight),
                          ),
                          child: TextField(
                            controller: _messageController,
                            enabled: !composerState.isSending,
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: isResolved
                                  ? 'Send another message to reopen this conversation'
                                  : 'Type your message here',
                              hintStyle: TextStyle(color: th.textHint),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppDesign.spaceLG,
                                vertical: AppDesign.spaceMD,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDesign.spaceMD),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusXL),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.22),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: composerState.isSending
                                ? null
                                : () => _sendCurrentMessage(
                                      userId: userId,
                                      userName: userName,
                                      userEmail: userEmail,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusXL),
                              ),
                            ),
                            child: composerState.isSending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.north_east_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyConversation(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.12),
                    AppColors.infoColor.withValues(alpha: 0.06),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_outlined,
                color: AppColors.primaryColor,
                size: AppDesign.iconLG,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              'Your support conversation will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: th.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingBubble(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: AppDesign.spaceSM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesign.spaceMD,
              vertical: AppDesign.spaceSM,
            ),
            decoration: BoxDecoration(
              color: th.subtleBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDesign.radiusLG),
                topRight: Radius.circular(AppDesign.radiusLG),
                bottomRight: Radius.circular(AppDesign.radiusLG),
                bottomLeft: Radius.circular(AppDesign.radiusSM),
              ),
              border: Border.all(color: th.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => Container(
                  width: 7,
                  height: 7,
                  margin: EdgeInsets.only(
                    right: index == 2 ? 0 : AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, SupportChatMessage message) {
    final th = ThemeHelper.of(context);
    final isUser = message.isFromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: AppDesign.spaceSM),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                gradient: isUser ? AppColors.primaryGradient : null,
                color: isUser ? null : th.subtleBackground,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppDesign.radiusLG),
                  topRight: const Radius.circular(AppDesign.radiusLG),
                  bottomLeft: Radius.circular(
                    isUser ? AppDesign.radiusLG : AppDesign.radiusSM,
                  ),
                  bottomRight: Radius.circular(
                    isUser ? AppDesign.radiusSM : AppDesign.radiusLG,
                  ),
                ),
                border: isUser ? null : Border.all(color: th.borderLight),
              ),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDesign.spaceXS),
                      child: Text(
                        message.senderName,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isUser ? Colors.white : th.textPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    _formatTime(message.createdAt),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.8)
                          : th.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppDesign.spaceSM),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primaryColor,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _sendCurrentMessage({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    _messageController.clear();
    await ref.read(supportChatControllerProvider.notifier).sendMessage(
          userId: userId,
          userName: userName,
          userEmail: userEmail,
          message: text,
        );
  }

  Future<void> _sendPrompt(
    String prompt, {
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    await ref.read(supportChatControllerProvider.notifier).sendMessage(
          userId: userId,
          userName: userName,
          userEmail: userEmail,
          message: prompt,
        );
  }

  String _formatStatusLabel(SupportConversationStatus status) {
    switch (status) {
      case SupportConversationStatus.open:
        return 'Open';
      case SupportConversationStatus.waitingOnSupport:
        return 'Waiting';
      case SupportConversationStatus.waitingOnUser:
        return 'Your reply';
      case SupportConversationStatus.resolved:
        return 'Resolved';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

class _QuickPromptChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _QuickPromptChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceMD,
            vertical: AppDesign.spaceSM,
          ),
          decoration: BoxDecoration(
            color: th.subtleBackground,
            borderRadius: BorderRadius.circular(AppDesign.radiusFull),
            border: Border.all(color: th.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppColors.primaryColor,
                  size: 14,
                ),
              ),
              const SizedBox(width: AppDesign.spaceSM),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
