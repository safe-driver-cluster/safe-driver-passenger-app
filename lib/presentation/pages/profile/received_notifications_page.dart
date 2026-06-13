import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/data/models/notification_model.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../providers/notification_provider.dart';
import '../profile/notifications_page.dart';

class ReceivedNotificationsPage extends ConsumerStatefulWidget {
  const ReceivedNotificationsPage({super.key});

  @override
  ConsumerState<ReceivedNotificationsPage> createState() =>
      _ReceivedNotificationsPageState();
}

class _ReceivedNotificationsPageState
    extends ConsumerState<ReceivedNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.background,
      body: Consumer(
        builder: (context, ref, _) {
          final notificationsAsyncValue = ref.watch(userNotificationsProvider);

          return ReceivedNotificationsContent(
            notificationsAsyncValue: notificationsAsyncValue,
            ref: ref,
          );
        },
      ),
    );
  }
}

class ReceivedNotificationsContent extends ConsumerWidget {
  final AsyncValue<List<NotificationModel>> notificationsAsyncValue;
  final WidgetRef ref;

  const ReceivedNotificationsContent({
    super.key,
    required this.notificationsAsyncValue,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _HeaderIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppDesign.spaceMD),
                      const Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _HeaderIconButton(
                        icon: Icons.settings_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your latest alerts and updates in one place',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.82),
                    ),
                  ),
                  const SizedBox(height: 12),
                  notificationsAsyncValue.when(
                    data: (notifications) {
                      final count = notifications.where((item) {
                        return !item.isRead;
                      }).length;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: count > 0
                                  ? Colors.orange.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: count > 0
                                    ? Colors.orange.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  count > 0
                                      ? Icons.mail_outline
                                      : Icons.done_all,
                                  size: 14,
                                  color:
                                      count > 0 ? Colors.orange : Colors.green,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  count > 0 ? '$count new' : 'All caught up',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: count == 0
                                ? null
                                : () {
                                    ref
                                        .read(notificationControllerProvider
                                            .notifier)
                                        .markAllAsReadForCurrentUser();
                                  },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFFE1E1),
                              disabledForegroundColor:
                                  Colors.white.withValues(alpha: 0.45),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Mark all read',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const ShimmerBadge(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: notificationsAsyncValue.when(
                data: (notifications) {
                  final visibleNotifications = notifications;

                  if (visibleNotifications.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: visibleNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = visibleNotifications[index];
                      return Dismissible(
                        key: ValueKey(notification.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                          ),
                        ),
                        confirmDismiss: (_) async {
                          await ref
                              .read(notificationControllerProvider.notifier)
                              .deleteNotification(notification.id);
                          return true;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildNotificationCard(
                            context,
                            ref,
                            notification,
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, stackTrace) {
                  print('Error loading notifications: $error');
                  print('Stack trace: $stackTrace');
                  return _buildErrorState(ref, error);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 56,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up! Check back soon for updates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.8),
              ),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading notifications...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Colors.red.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something Went Wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load your notifications. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.invalidate(userNotificationsProvider);
                  ref.invalidate(unreadNotificationCountProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          ref
              .read(notificationControllerProvider.notifier)
              .markAsRead(notification.id);
        }
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete notification'),
                  onTap: () {
                    ref
                        .read(notificationControllerProvider.notifier)
                        .deleteNotification(notification.id);
                    Navigator.pop(context);
                  },
                ),
                if (!notification.isRead)
                  ListTile(
                    leading: const Icon(Icons.done, color: Colors.green),
                    title: const Text('Mark as read'),
                    onTap: () {
                      ref
                          .read(notificationControllerProvider.notifier)
                          .markAsRead(notification.id);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFF8FBFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? Colors.white.withValues(alpha: 0.18)
                : const Color(0xFFBFD5FF),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0E3D91).withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (!notification.isRead)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          const Color(0xFFEAF2FF),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _notificationAccent(notification).withValues(
                          alpha: notification.isRead ? 0.10 : 0.16,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _notificationIcon(notification),
                        color: _notificationAccent(notification),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF163B73),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notification.body,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF466286),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTime(notification.sentAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF7A8EAA),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (notification.status !=
                                  NotificationStatus.sent)
                                Row(
                                  children: [
                                    Icon(
                                      notification.status ==
                                              NotificationStatus.read
                                          ? Icons.done_all
                                          : Icons.done,
                                      size: 12,
                                      color: const Color(0xFF8EA0BA),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      notification.status
                                          .toString()
                                          .split('.')
                                          .last,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF8EA0BA),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
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

  IconData _notificationIcon(NotificationModel notification) {
    switch (notification.type) {
      case NotificationType.registration:
        return Icons.celebration_rounded;
      case NotificationType.login:
        return Icons.waving_hand_rounded;
      case NotificationType.feedback:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.feedbackStatus:
        return Icons.rate_review_outlined;
      case NotificationType.profile:
        return Icons.person_rounded;
      case NotificationType.journey:
        return Icons.directions_bus_rounded;
      case NotificationType.general:
        return Icons.campaign_rounded;
    }
  }

  Color _notificationAccent(NotificationModel notification) {
    switch (notification.priority) {
      case NotificationPriority.high:
        return const Color(0xFFE25241);
      case NotificationPriority.normal:
        return const Color(0xFF147AD6);
      case NotificationPriority.low:
        return const Color(0xFF4D7C8A);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return dateTime.toString().split(' ')[0];
    }
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(AppDesign.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class ShimmerBadge extends StatefulWidget {
  const ShimmerBadge({super.key});

  @override
  State<ShimmerBadge> createState() => _ShimmerBadgeState();
}

class _ShimmerBadgeState extends State<ShimmerBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.mail_outline,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          FadeTransition(
            opacity: _controller,
            child: Text(
              'Loading...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
