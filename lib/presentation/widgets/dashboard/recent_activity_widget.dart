import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../controllers/dashboard_controller.dart';

class RecentActivityWidget extends ConsumerWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final th = ThemeHelper.of(context);
    final dashboardState = ref.watch(dashboardControllerProvider);
    final recentActivity = dashboardState.recentActivity;

    if (recentActivity.isEmpty) {
      return _buildEmptyState(th);
    }

    final latestActivities = recentActivity.take(5).toList();

    return ListView.separated(
      itemCount: latestActivities.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _buildActivityTile(th, latestActivities[index]);
      },
    );
  }

  Widget _buildEmptyState(ThemeHelper th) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 30,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No recent activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: th.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start your first journey with SafeDriver\nto see your activity here',
              style: TextStyle(
                fontSize: 14,
                color: th.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(ThemeHelper th, String activity) {
    final color = _getActivityColor(activity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: th.divider.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: th.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity),
              size: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String activity) {
    final lower = activity.toLowerCase();
    if (lower.contains('started') || lower.contains('boarded')) {
      return Colors.green;
    } else if (lower.contains('ended')) {
      return Colors.redAccent;
    } else if (lower.contains('feedback')) {
      return Colors.blue;
    } else if (lower.contains('alert')) {
      return Colors.orange;
    } else if (lower.contains('notification')) {
      return Colors.purple;
    }
    return AppColors.primaryColor;
  }

  IconData _getActivityIcon(String activity) {
    final lower = activity.toLowerCase();
    if (lower.contains('started') || lower.contains('boarded')) {
      return Icons.directions_bus;
    } else if (lower.contains('ended')) {
      return Icons.check_circle;
    } else if (lower.contains('feedback')) {
      return Icons.feedback;
    } else if (lower.contains('alert')) {
      return Icons.warning;
    } else if (lower.contains('notification')) {
      return Icons.notifications;
    }
    return Icons.info;
  }
}
