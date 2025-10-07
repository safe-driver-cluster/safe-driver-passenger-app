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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to full activity history
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                  label: const Text('View All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentActivity.isEmpty)
              _buildEmptyState()
            else
              Column(
                children: recentActivity
                    .take(5)
                    .map((activity) => _buildActivityItem(activity))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
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
            child: Icon(
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
          Text(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getTimeAgo(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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

  String _getTimeAgo() {
    // Mock time ago - in a real app, this would calculate actual time difference
    final times = [
      '2 min ago',
      '5 min ago',
      '15 min ago',
      '1 hour ago',
      '2 hours ago'
    ];
    times.shuffle();
    return times.first;
  }
}
