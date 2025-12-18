import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/app_theme.dart';
import '../../../data/models/feedback_extended.dart';
import '../../../data/models/feedback_model.dart';

/// Widget showing feedback status timeline
class FeedbackStatusWidget extends StatelessWidget {
  final FeedbackModel feedback;
  final List<FeedbackAuditLog> auditLogs;
  final VoidCallback? onStatusUpdate;

  const FeedbackStatusWidget({
    Key? key,
    required this.feedback,
    required this.auditLogs,
    this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current status section
        _buildCurrentStatus(context),

        const SizedBox(height: 24),

        // Status timeline
        if (auditLogs.isNotEmpty) ...[
          Text(
            'Status History',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          _buildStatusTimeline(context),
        ],

        const SizedBox(height: 24),

        // Response section
        if (feedback.hasResponse) _buildResponseSection(context),

        // Update status button
        if (onStatusUpdate != null && feedback.status != FeedbackStatus.resolved)
          ElevatedButton.icon(
            onPressed: onStatusUpdate,
            icon: const Icon(Icons.edit),
            label: const Text('Update Status'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
      ],
    );
  }

  /// Build current status display
  Widget _buildCurrentStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(feedback.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(feedback.status),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(feedback.status),
                color: _getStatusColor(feedback.status),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feedback.status.toString().split('.').last.toUpperCase(),
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(feedback.status),
                              ),
                    ),
                  ],
                ),
              ),
              _buildResolutionBadge(context),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Last updated: ${DateFormat('MMM d, y • hh:mm a').format(feedback.respondedAt ?? feedback.timestamp)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray,
                ),
          ),
        ],
      ),
    );
  }

  /// Build resolution badge
  Widget _buildResolutionBadge(BuildContext context) {
    if (feedback.isResolved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '✓ Resolved',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (feedback.status == FeedbackStatus.inReview) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '⏳ In Progress',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// Build status timeline
  Widget _buildStatusTimeline(BuildContext context) {
    // Sort audit logs by timestamp
    final sortedLogs = List<FeedbackAuditLog>.from(auditLogs)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (int i = 0; i < sortedLogs.length; i++) ...[
            _buildTimelineItem(context, sortedLogs[i], i == 0),
            if (i < sortedLogs.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 20,
                  width: 2,
                  color: AppColors.gray.withOpacity(0.3),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Build individual timeline item
  Widget _buildTimelineItem(
      BuildContext context, FeedbackAuditLog log, bool isLatest) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLatest
                  ? _getStatusColor(log.toStatus)
                  : AppColors.gray.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getStatusIcon(log.toStatus),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Timeline content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Moved to ${log.toStatus.toString().split('.').last}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        DateFormat('MMM d, y').format(log.timestamp),
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.gray,
                                ),
                      ),
                    ],
                  ),
                  if (log.reason != null && log.reason!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Reason: ${log.reason}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                  if (log.actionPerformedBy != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'By: ${log.actionPerformedBy}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build response section
  Widget _buildResponseSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Response Received',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            feedback.response ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Responded by: ${feedback.respondedBy ?? 'Admin'} on ${DateFormat('MMM d, y • hh:mm a').format(feedback.respondedAt ?? DateTime.now())}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray,
                ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Get color for status
  Color _getStatusColor(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.submitted:
        return AppColors.gray;
      case FeedbackStatus.received:
        return Colors.blue;
      case FeedbackStatus.inReview:
        return Colors.orange;
      case FeedbackStatus.responded:
        return Colors.blue;
      case FeedbackStatus.resolved:
        return Colors.green;
      case FeedbackStatus.closed:
        return AppColors.gray;
      case FeedbackStatus.escalated:
        return Colors.red;
    }
  }

  /// Get icon for status
  IconData _getStatusIcon(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.submitted:
        return Icons.pending;
      case FeedbackStatus.received:
        return Icons.check_circle;
      case FeedbackStatus.inReview:
        return Icons.hourglass_top;
      case FeedbackStatus.responded:
        return Icons.reply;
      case FeedbackStatus.resolved:
        return Icons.done_all;
      case FeedbackStatus.closed:
        return Icons.check_circle;
      case FeedbackStatus.escalated:
        return Icons.warning;
    }
  }
}

/// Widget for displaying resolution metrics
class ResolutionMetricsWidget extends StatelessWidget {
  final List<FeedbackModel> feedbacks;

  const ResolutionMetricsWidget({
    Key? key,
    required this.feedbacks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resolved = feedbacks
        .where((f) => f.status == FeedbackStatus.resolved)
        .length;
    final inReview =
        feedbacks.where((f) => f.status == FeedbackStatus.inReview).length;
    final responded =
        feedbacks.where((f) => f.status == FeedbackStatus.responded).length;

    final resolutionRate =
        feedbacks.isNotEmpty ? (resolved / feedbacks.length) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resolution Metrics',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          // Resolution rate
          _buildMetricRow(
            context,
            'Resolution Rate',
            '${resolutionRate.toStringAsFixed(1)}%',
            Colors.green,
          ),
          const SizedBox(height: 12),
          // Resolved count
          _buildMetricRow(
            context,
            'Resolved',
            '$resolved',
            Colors.green,
          ),
          const SizedBox(height: 12),
          // In Review count
          _buildMetricRow(
            context,
            'In Review',
            '$inReview',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          // Responded count
          _buildMetricRow(
            context,
            'Responded',
            '$responded',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  /// Build metric row
  Widget _buildMetricRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
