import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/data/models/notification_model.dart';
import 'package:safedriver_passenger_app/presentation/pages/profile/notifications_page.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../providers/notification_provider.dart';

class NotificationsBottomSheet extends ConsumerStatefulWidget {
  const NotificationsBottomSheet({super.key});

  @override
  ConsumerState<NotificationsBottomSheet> createState() =>
      _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState
    extends ConsumerState<NotificationsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final notificationsAsync = ref.watch(userNotificationsProvider);
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: screenHeight * 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: th.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDesign.radius2XL),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 26,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDesign.spaceLG,
                  AppDesign.spaceMD,
                  AppDesign.spaceLG,
                  AppDesign.spaceMD,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: th.border,
                        borderRadius: BorderRadius.circular(
                          AppDesign.radiusFull,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceLG),
                    _buildHeader(unreadCountAsync),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildInfoBanner(),
                  ],
                ),
              ),
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) {
                    if (notifications.isEmpty) {
                      return _buildEmptyState();
                    }

                    final sections = _groupNotifications(notifications);
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppDesign.spaceLG,
                        0,
                        AppDesign.spaceLG,
                        AppDesign.spaceLG,
                      ),
                      children: [
                        Row(
                          children: [
                            Text(
                              'Recent',
                              style: AppTextStyles.headline6.copyWith(
                                color: th.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _markAllAsRead,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Mark all read'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDesign.spaceSM),
                        ...sections.map(_buildSection),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                  error: (_, __) => _buildErrorState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<int> unreadCountAsync) {
    final th = ThemeHelper.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: AppTextStyles.headline4.copyWith(
                  color: th.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDesign.spaceXS),
              unreadCountAsync.when(
                data: (count) => Text(
                  count > 0
                      ? '$count unread notification${count == 1 ? '' : 's'}'
                      : 'All caught up',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
                loading: () => Text(
                  'Loading...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _openNotificationSettings,
          tooltip: 'Notification settings',
          icon: Icon(
            Icons.settings_outlined,
            color: th.textPrimary,
            size: 22,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: 'Close',
          icon: Icon(
            Icons.close_rounded,
            color: th.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F0),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.errorColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Information!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppDesign.textSM,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Journey, safety, and account alerts will appear here as soon as they arrive.',
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: AppDesign.textSM,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_NotificationSectionData> _groupNotifications(
    List<NotificationModel> notifications,
  ) {
    final now = DateTime.now();
    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final earlier = <NotificationModel>[];

    for (final notification in notifications) {
      if (_isSameDay(notification.sentAt, now)) {
        today.add(notification);
      } else if (_isSameDay(
        notification.sentAt,
        now.subtract(const Duration(days: 1)),
      )) {
        yesterday.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    final sections = <_NotificationSectionData>[];
    if (today.isNotEmpty) {
      sections.add(_NotificationSectionData(title: 'Today', items: today));
    }
    if (yesterday.isNotEmpty) {
      sections.add(
        _NotificationSectionData(title: 'Yesterday', items: yesterday),
      );
    }
    if (earlier.isNotEmpty) {
      sections.add(_NotificationSectionData(title: 'Earlier', items: earlier));
    }

    return sections;
  }

  Widget _buildSection(_NotificationSectionData section) {
    final th = ThemeHelper.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: AppTextStyles.labelLarge.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSM),
          ...List.generate(section.items.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    index == section.items.length - 1 ? 0 : AppDesign.spaceMD,
              ),
              child: _buildNotificationCard(section.items[index]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final th = ThemeHelper.of(context);
    final accentColor = _colorForType(notification.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (!notification.isRead) {
            await ref
                .read(notificationControllerProvider.notifier)
                .markAsRead(notification.id);
          }
        },
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        child: Ink(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: th.cardBackground,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 18, right: 10),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? Colors.transparent
                      : AppColors.errorColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    notification.typeEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: th.textPrimary,
                        fontWeight: notification.isRead
                            ? FontWeight.w600
                            : FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: th.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      _formatTime(notification.sentAt),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: th.textHint,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    await ref
                        .read(notificationControllerProvider.notifier)
                        .deleteNotification(notification.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: th.textHint,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final th = ThemeHelper.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 52,
              color: th.textDisabled,
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              'No notifications',
              style: AppTextStyles.headline6.copyWith(
                color: th.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              'You will see new journey and account updates here.',
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

  Widget _buildErrorState() {
    final th = ThemeHelper.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: AppColors.errorColor.withValues(alpha: 0.8),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              'Couldn\'t load notifications',
              style: AppTextStyles.headline6.copyWith(
                color: th.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              'Try again to refresh your inbox.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: th.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAllAsRead() async {
    await ref
        .read(notificationControllerProvider.notifier)
        .markAllAsReadForCurrentUser();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openNotificationSettings() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(
        builder: (_) => const NotificationsPage(),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
        return AppColors.successColor;
      case NotificationType.login:
        return AppColors.warningColor;
      case NotificationType.feedback:
      case NotificationType.feedbackStatus:
        return AppColors.accentColor;
      case NotificationType.profile:
        return AppColors.infoColor;
      case NotificationType.journey:
        return AppColors.primaryColor;
      case NotificationType.general:
        return AppColors.errorColor;
    }
  }

  String _formatTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

class _NotificationSectionData {
  final String title;
  final List<NotificationModel> items;

  const _NotificationSectionData({
    required this.title,
    required this.items,
  });
}
