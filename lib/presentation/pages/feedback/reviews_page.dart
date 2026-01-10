import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../controllers/feedback_controller.dart';

class ReviewsPage extends ConsumerStatefulWidget {
  const ReviewsPage({super.key});

  @override
  ConsumerState<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends ConsumerState<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    // Load feedback data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedbackControllerProvider.notifier).loadFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedbackController = ref.read(feedbackControllerProvider.notifier);
    final statistics = feedbackController.statistics;
    final feedbacks = feedbackController.feedbacks;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Feedback Analytics'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: feedbacks.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  _buildSummaryCards(statistics),
                  const SizedBox(height: AppDesign.spaceXL),

                  // Rating Distribution
                  _buildRatingDistribution(statistics),
                  const SizedBox(height: AppDesign.spaceXL),

                  // Category Distribution
                  _buildCategoryDistribution(statistics),
                  const SizedBox(height: AppDesign.spaceXL),

                  // Status Overview
                  _buildStatusOverview(statistics),
                  const SizedBox(height: AppDesign.spaceXL),

                  // Recent Feedback Insights
                  _buildRecentInsights(feedbacks),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppDesign.spaceLG),
          Text(
            'No Feedback Data Yet',
            style: TextStyle(
              fontSize: AppDesign.text2XL,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDesign.spaceSM),
          Text(
            'Analytics will appear once you receive feedback',
            style: TextStyle(
              fontSize: AppDesign.textMD,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(statistics) {
    final totalFeedback = statistics['total'] ?? 0;
    final averageRating =
        statistics['averageRating']?.toStringAsFixed(1) ?? '0';
    final submitted = statistics['byStatus']?['submitted'] ?? 0;
    final reviewed = statistics['byStatus']?['reviewed'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: AppDesign.textXL,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Feedback',
                value: totalFeedback.toString(),
                icon: Icons.feedback_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: _buildStatCard(
                title: 'Average Rating',
                value: '$averageRating ⭐',
                icon: Icons.star_rounded,
                color: const Color(0xFFFFC107),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesign.spaceMD),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Submitted',
                value: submitted.toString(),
                icon: Icons.send_rounded,
                color: const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: _buildStatCard(
                title: 'Reviewed',
                value: reviewed.toString(),
                icon: Icons.done_rounded,
                color: const Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppDesign.text2XL,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppDesign.textSM,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(statistics) {
    final ratingData = statistics['byRating'] as Map<String, int>? ?? {};

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rating Distribution',
            style: TextStyle(
              fontSize: AppDesign.textLG,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Column(
            children: List.generate(5, (index) {
              final rating = 5 - index;
              final count = ratingData[rating.toString()] ?? 0;
              final total = ratingData.values.fold<int>(0, (a, b) => a + b);
              final percentage = total > 0 ? (count / total * 100).toInt() : 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Row(
                        children: List.generate(
                          rating,
                          (i) => const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Color(0xFFFFC107),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          minHeight: 8,
                          backgroundColor: AppColors.greyLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getRatingColor(rating),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$percentage%',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution(statistics) {
    final categoryData = statistics['byCategory'] as Map<String, int>? ?? {};

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feedback by Category',
            style: TextStyle(
              fontSize: AppDesign.textLG,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Column(
            children: categoryData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: AppDesign.textMD,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceMD,
                        vertical: AppDesign.spaceSM,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                      ),
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
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

  Widget _buildStatusOverview(statistics) {
    final statusData = statistics['byStatus'] as Map<String, int>? ?? {};

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feedback Status',
            style: TextStyle(
              fontSize: AppDesign.textLG,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Column(
            children: statusData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _capitalizeStatus(entry.key),
                        style: const TextStyle(
                          fontSize: AppDesign.textMD,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceMD,
                        vertical: AppDesign.spaceSM,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(entry.key).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                      ),
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(entry.key),
                        ),
                      ),
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

  Widget _buildRecentInsights(feedbacks) {
    if (feedbacks.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get high-rated feedback
    final highRated = feedbacks.where((f) => f.rating.overall >= 4).toList();
    final lowRated = feedbacks.where((f) => f.rating.overall <= 2).toList();

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
              fontSize: AppDesign.textLG,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              border: Border.all(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.thumb_up_rounded,
                  color: Color(0xFF4CAF50),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Positive Feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        '${highRated.length} feedback rated 4+ stars',
                        style: const TextStyle(
                          fontSize: AppDesign.textSM,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: const Color(0xFFF44336).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              border: Border.all(
                color: const Color(0xFFF44336).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.thumb_down_rounded,
                  color: Color(0xFFF44336),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Needs Attention',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF44336),
                        ),
                      ),
                      Text(
                        '${lowRated.length} feedback rated 1-2 stars',
                        style: const TextStyle(
                          fontSize: AppDesign.textSM,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return const Color(0xFF4CAF50);
    if (rating == 3) return const Color(0xFFFFC107);
    return const Color(0xFFF44336);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted':
        return AppColors.primaryColor;
      case 'reviewed':
        return const Color(0xFF4CAF50);
      case 'resolved':
        return const Color(0xFF2196F3);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return AppColors.textSecondary;
    }
  }

  String _capitalizeStatus(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }
}
