import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/models/feedback_model.dart';

/// Comprehensive feedback analytics dashboard
class FeedbackAnalyticsDashboard extends StatefulWidget {
  final List<FeedbackModel> feedbacks;
  final DateTimeRange? dateRange;
  final String? categoryFilter;

  const FeedbackAnalyticsDashboard({
    super.key,
    required this.feedbacks,
    this.dateRange,
    this.categoryFilter,
  });

  @override
  State<FeedbackAnalyticsDashboard> createState() =>
      _FeedbackAnalyticsDashboardState();
}

class _FeedbackAnalyticsDashboardState
    extends State<FeedbackAnalyticsDashboard> {
  late List<FeedbackModel> _filteredFeedback;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void didUpdateWidget(FeedbackAnalyticsDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _applyFilters();
  }

  void _applyFilters() {
    _filteredFeedback = widget.feedbacks.where((feedback) {
      // Date range filter
      if (widget.dateRange != null) {
        if (!feedback.timestamp.isAfter(widget.dateRange!.start) ||
            !feedback.timestamp.isBefore(
              widget.dateRange!.end.add(const Duration(days: 1)),
            )) {
          return false;
        }
      }

      // Category filter
      if (widget.categoryFilter != null) {
        if (feedback.category.toString().split('.').last !=
            widget.categoryFilter) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics
          _buildKeyMetrics(context),
          const SizedBox(height: 24),

          // Rating distribution
          _buildRatingDistribution(context),
          const SizedBox(height: 24),

          // Status breakdown
          _buildStatusBreakdown(context),
          const SizedBox(height: 24),

          // Category breakdown
          _buildCategoryBreakdown(context),
          const SizedBox(height: 24),

          // Attachment statistics
          _buildAttachmentStats(context),
          const SizedBox(height: 24),

          // Trend chart
          _buildTrendChart(context),
          const SizedBox(height: 24),

          // Resolution metrics
          _buildResolutionMetrics(context),
        ],
      ),
    );
  }

  /// Build key metrics cards
  Widget _buildKeyMetrics(BuildContext context) {
    final totalFeedback = _filteredFeedback.length;
    final avgRating = _filteredFeedback.isEmpty
        ? 0.0
        : _filteredFeedback.fold<double>(
                0, (sum, f) => sum + f.rating.overall) /
            totalFeedback;
    final positiveFeedback =
        _filteredFeedback.where((f) => f.rating.overall >= 4).length;
    final satisfactionRate =
        totalFeedback > 0 ? (positiveFeedback / totalFeedback) * 100 : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Total Feedback',
                totalFeedback.toString(),
                Icons.feedback,
                AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                'Avg Rating',
                avgRating.toStringAsFixed(1),
                Icons.star,
                AppColors.warningColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Satisfaction',
                '${satisfactionRate.toStringAsFixed(1)}%',
                Icons.thumb_up,
                AppColors.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                'With Media',
                _filteredFeedback
                    .where((f) => f.attachments.isNotEmpty)
                    .length
                    .toString(),
                Icons.attachment,
                AppColors.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build individual metric card
  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey,
                ),
          ),
        ],
      ),
    );
  }

  /// Build rating distribution chart
  Widget _buildRatingDistribution(BuildContext context) {
    final ratingCounts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] =
          _filteredFeedback.where((f) => f.rating.overall == i).length;
    }

    final maxCount = ratingCounts.values.isEmpty
        ? 1
        : ratingCounts.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rating Distribution',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final count = ratingCounts[rating] ?? 0;
            final percentage = _filteredFeedback.isEmpty
                ? 0.0
                : (count / _filteredFeedback.length) * 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '⭐ $rating',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: maxCount > 0 ? count / maxCount : 0,
                        minHeight: 8,
                        backgroundColor: AppColors.grey.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getRatingColor(rating),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '$count (${percentage.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                          ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Build status breakdown
  Widget _buildStatusBreakdown(BuildContext context) {
    final statusCounts = <FeedbackStatus, int>{};
    for (final status in FeedbackStatus.values) {
      statusCounts[status] =
          _filteredFeedback.where((f) => f.status == status).length;
    }

    // Sort by count
    final sortedStatuses = statusCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feedback by Status',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in sortedStatuses.where((e) => e.value > 0))
                _buildStatusTag(
                  entry.key,
                  entry.value,
                  _filteredFeedback.length,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build status tag
  Widget _buildStatusTag(FeedbackStatus status, int count, int total) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            status.toString().split('.').last,
            style: TextStyle(
              color: color,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Build category breakdown
  Widget _buildCategoryBreakdown(BuildContext context) {
    final categoryCounts = <FeedbackCategory, int>{};
    for (final category in FeedbackCategory.values) {
      categoryCounts[category] =
          _filteredFeedback.where((f) => f.category == category).length;
    }

    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feedback by Category',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...sortedCategories.where((e) => e.value > 0).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        entry.key.toString().split('.').last,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _filteredFeedback.isEmpty
                              ? 0
                              : entry.value / _filteredFeedback.length,
                          minHeight: 6,
                          backgroundColor: AppColors.grey.withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCategoryColor(entry.key),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /// Build attachment statistics
  Widget _buildAttachmentStats(BuildContext context) {
    final withAttachments =
        _filteredFeedback.where((f) => f.attachments.isNotEmpty).length;
    final totalAttachments =
        _filteredFeedback.fold<int>(0, (sum, f) => sum + f.attachments.length);
    final images = _filteredFeedback.fold<int>(
        0, (sum, f) => sum + f.attachments.where((a) => a.isImage).length);
    final videos = _filteredFeedback.fold<int>(
        0, (sum, f) => sum + f.attachments.where((a) => a.isVideo).length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Media Attachments',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAttachmentStat(
                'Feedback with Media',
                withAttachments.toString(),
                Icons.attachment,
              ),
              _buildAttachmentStat(
                'Total Files',
                totalAttachments.toString(),
                Icons.folder,
              ),
              _buildAttachmentStat(
                'Images',
                images.toString(),
                Icons.image,
              ),
              _buildAttachmentStat(
                'Videos',
                videos.toString(),
                Icons.videocam,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build attachment stat item
  Widget _buildAttachmentStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  /// Build trend chart
  Widget _buildTrendChart(BuildContext context) {
    // Group feedback by date
    final trendData = <String, int>{};
    for (final feedback in _filteredFeedback) {
      final date = DateFormat('MMM d').format(feedback.timestamp);
      trendData[date] = (trendData[date] ?? 0) + 1;
    }

    // Get last 7 days
    final last7Days = <String, int>{};
    for (int i = 6; i >= 0; i--) {
      final date = DateFormat('MMM d')
          .format(DateTime.now().subtract(Duration(days: i)));
      last7Days[date] = trendData[date] ?? 0;
    }

    final maxCount = last7Days.values.isEmpty
        ? 1
        : last7Days.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feedback Trend (Last 7 Days)',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: last7Days.entries.map((entry) {
              final height =
                  maxCount > 0 ? (entry.value / maxCount) * 100 : 0.0;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: double.infinity,
                      height: height.clamp(10, 150),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key.split(' ')[0],
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Build resolution metrics
  Widget _buildResolutionMetrics(BuildContext context) {
    final resolved = _filteredFeedback
        .where((f) => f.status == FeedbackStatus.resolved)
        .length;
    final pending = _filteredFeedback
        .where((f) =>
            f.status != FeedbackStatus.resolved &&
            f.status != FeedbackStatus.closed)
        .length;

    final resolutionRate = _filteredFeedback.isEmpty
        ? 0.0
        : (resolved / _filteredFeedback.length) * 100;

    // Calculate average resolution time
    final resolvedFeedback = _filteredFeedback
        .where(
            (f) => f.status == FeedbackStatus.resolved && f.respondedAt != null)
        .toList();

    double avgResolutionHours = 0.0;
    if (resolvedFeedback.isNotEmpty) {
      final totalHours = resolvedFeedback.fold<double>(
        0,
        (sum, f) => sum + f.respondedAt!.difference(f.timestamp).inHours,
      );
      avgResolutionHours = totalHours / resolvedFeedback.length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resolution Metrics',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn(
                'Resolution Rate',
                '${resolutionRate.toStringAsFixed(1)}%',
                Colors.green,
              ),
              _buildMetricColumn(
                'Resolved',
                resolved.toString(),
                Colors.green,
              ),
              _buildMetricColumn(
                'Pending',
                pending.toString(),
                Colors.orange,
              ),
              _buildMetricColumn(
                'Avg Time',
                '${avgResolutionHours.toStringAsFixed(1)}h',
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build metric column
  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  /// Get rating color
  Color _getRatingColor(int rating) {
    switch (rating) {
      case 5:
        return AppColors.successColor;
      case 4:
        return AppColors.secondaryColor;
      case 3:
        return AppColors.warningColor;
      case 2:
        return AppColors.warningColorAlt;
      case 1:
        return AppColors.dangerColor;
      default:
        return AppColors.grey;
    }
  }

  /// Get status color
  Color _getStatusColor(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.submitted:
        return AppColors.grey;
      case FeedbackStatus.received:
        return AppColors.infoColor;
      case FeedbackStatus.inReview:
        return AppColors.warningColor;
      case FeedbackStatus.responded:
        return AppColors.infoColor;
      case FeedbackStatus.resolved:
        return AppColors.successColor;
      case FeedbackStatus.closed:
        return AppColors.grey;
      case FeedbackStatus.escalated:
        return AppColors.dangerColor;
    }
  }

  /// Get category color
  Color _getCategoryColor(FeedbackCategory category) {
    const colors = {
      FeedbackCategory.safety: AppColors.dangerColor,
      FeedbackCategory.service: AppColors.infoColor,
      FeedbackCategory.comfort: AppColors.accentColor,
      FeedbackCategory.driver: AppColors.warningColor,
      FeedbackCategory.vehicle: AppColors.tealAccent,
      FeedbackCategory.route: AppColors.primaryVariant,
      FeedbackCategory.general: AppColors.grey,
      FeedbackCategory.suggestion: AppColors.successColor,
      FeedbackCategory.complaint: AppColors.dangerColor,
      FeedbackCategory.compliment: AppColors.warningColorAlt,
    };

    return colors[category] ?? AppColors.grey;
  }
}
