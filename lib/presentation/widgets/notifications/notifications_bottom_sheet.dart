import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/data/models/notification_model.dart';
import 'package:safedriver_passenger_app/presentation/pages/profile/received_notifications_page.dart';

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
  String _filterType = 'all';

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
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, -10),
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
                      width: 46,
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
                    _buildTopBar(unreadCountAsync),
                    const SizedBox(height: AppDesign.spaceMD),
                    _buildSegmentedFilter(),
                  ],
                ),
              ),
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) {
                    final filteredNotifications =
                        _filterNotifications(notifications);

                    if (filteredNotifications.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppDesign.spaceLG,
                        0,
                        AppDesign.spaceLG,
                        AppDesign.spaceLG,
                      ),
                      itemCount: filteredNotifications.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppDesign.spaceSM),
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(
                          filteredNotifications[index],
                        );
                      },
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
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withValues(alpha: 0.18),
                AppColors.tealAccent.withValues(alpha: 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: const Icon(
            Icons.notifications_active_rounded,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: AppDesign.spaceMD),
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
                      ? '$count update${count == 1 ? '' : 's'} waiting'
                      : 'Everything looks quiet right now',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
                loading: () => Text(
                  'Loading inbox status...',
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close_rounded,
            color: th.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(AsyncValue<int> unreadCountAsync) {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: th.borderLight),
      ),
      child: Row(
        children: [
          unreadCountAsync.when(
            data: (count) => _StatusPill(
              icon: Icons.mark_email_unread_outlined,
              label: count > 0 ? '$count unread' : 'All caught up',
              color:
                  count > 0 ? AppColors.primaryColor : AppColors.successColor,
            ),
            loading: () => const _StatusPill(
              icon: Icons.sync_rounded,
              label: 'Syncing...',
              color: AppColors.primaryColor,
            ),
            error: (_, __) => const _StatusPill(
              icon: Icons.error_outline_rounded,
              label: 'Unavailable',
              color: AppColors.errorColor,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _markAllAsRead,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceMD,
                vertical: AppDesign.spaceSM,
              ),
            ),
            child: const Text('Mark all read'),
          ),
          const SizedBox(width: AppDesign.spaceXS),
          FilledButton.tonal(
            onPressed: _openFullInbox,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.10),
              foregroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceMD,
                vertical: AppDesign.spaceSM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusFull),
              ),
            ),
            child: const Text('Open inbox'),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedFilter() {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: th.borderLight),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSegmentButton('All', 'all')),
          Expanded(child: _buildSegmentButton('Unread', 'unread')),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, String value) {
    final th = ThemeHelper.of(context);
    final selected = _filterType == value;

    return GestureDetector(
      onTap: () => setState(() => _filterType = value),
      child: AnimatedContainer(
        duration: AppDesign.animationFast,
        curve: AppDesign.easeOut,
        padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: selected ? Colors.white : th.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  List<NotificationModel> _filterNotifications(
    List<NotificationModel> notifications,
  ) {
    switch (_filterType) {
      case 'unread':
        return notifications.where((item) => !item.isRead).toList();
      default:
        return notifications;
    }
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
            color: notification.isRead
                ? th.cardBackground
                : accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            border: Border.all(
              color: notification.isRead
                  ? th.borderLight
                  : accentColor.withValues(alpha: 0.24),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: th.textPrimary,
                              fontWeight: notification.isRead
                                  ? FontWeight.w700
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: th.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceSM),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesign.spaceSM,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(
                              AppDesign.radiusFull,
                            ),
                          ),
                          child: Text(
                            _labelForType(notification.type),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDesign.spaceSM),
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: th.textHint,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatTime(notification.sentAt),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: th.textHint,
                              fontWeight: FontWeight.w700,
                            ),
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
                            Icons.more_horiz_rounded,
                            size: 18,
                            color: th.textSecondary,
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
      ),
    );
  }

  Widget _buildEmptyState() {
    final th = ThemeHelper.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDesign.spaceXL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                th.subtleBackground,
                AppColors.primaryColor.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            border: Border.all(color: th.borderLight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  _filterType == 'unread'
                      ? Icons.drafts_outlined
                      : Icons.notifications_none_rounded,
                  size: 30,
                  color: AppColors.primaryColor.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: AppDesign.spaceLG),
              Text(
                _filterType == 'unread'
                    ? 'No unread notifications'
                    : 'No notifications yet',
                style: AppTextStyles.headline6.copyWith(
                  color: th.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDesign.spaceSM),
              Text(
                _filterType == 'unread'
                    ? 'You have already checked everything in the inbox.'
                    : 'New push alerts and in-app updates will show up here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: th.textSecondary,
                ),
              ),
            ],
          ),
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
            const SizedBox(height: AppDesign.spaceLG),
            ElevatedButton(
              onPressed: () => ref.refresh(userNotificationsProvider),
              child: const Text('Retry'),
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

  void _openFullInbox() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(
      MaterialPageRoute(
        builder: (_) => const ReceivedNotificationsPage(),
      ),
    );
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
        return AppColors.tealAccent;
    }
  }

  String _labelForType(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
        return 'Registration';
      case NotificationType.login:
        return 'Security';
      case NotificationType.feedback:
        return 'Feedback';
      case NotificationType.feedbackStatus:
        return 'Feedback status';
      case NotificationType.profile:
        return 'Profile';
      case NotificationType.journey:
        return 'Journey';
      case NotificationType.general:
        return 'General';
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
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceMD,
        vertical: AppDesign.spaceSM,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppDesign.spaceXS),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
