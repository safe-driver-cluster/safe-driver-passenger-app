import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../controllers/dashboard_controller.dart';

class RecentActivityWidget extends ConsumerWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final recentActivity = dashboardState.recentActivity;

    if (recentActivity.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: recentActivity
          .take(5)
          .map((activity) => _buildActivityItem(activity))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
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
            const Text(
              'No recent activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start your first journey with SafeDriver\nto see your activity here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: _getActivityColor(activity),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            _getActivityIcon(activity),
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String activity) {
    if (activity.toLowerCase().contains('boarded')) {
      return Colors.green;
    } else if (activity.toLowerCase().contains('feedback')) {
      return Colors.blue;
    } else if (activity.toLowerCase().contains('alert')) {
      return Colors.orange;
    } else if (activity.toLowerCase().contains('notification')) {
      return Colors.purple;
    }
    return AppColors.primaryColor;
  }

  IconData _getActivityIcon(String activity) {
    if (activity.toLowerCase().contains('boarded')) {
      return Icons.directions_bus;
    } else if (activity.toLowerCase().contains('feedback')) {
      return Icons.feedback;
    } else if (activity.toLowerCase().contains('alert')) {
      return Icons.warning;
    } else if (activity.toLowerCase().contains('notification')) {
      return Icons.notifications;
    }
    return Icons.info;
  }
}
