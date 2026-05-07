import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../providers/auth_provider.dart';
import '../../controllers/feedback_controller.dart';
import '../../widgets/common/professional_widgets.dart';

class FeedbackHistoryPage extends ConsumerStatefulWidget {
  const FeedbackHistoryPage({super.key});

  @override
  ConsumerState<FeedbackHistoryPage> createState() =>
      _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends ConsumerState<FeedbackHistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Setup rotation animation for refresh icon
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Load user's feedback when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);
      debugPrint('📜 FeedbackHistoryPage: User UID: ${authState.user?.uid}');

      if (authState.user?.uid != null) {
        debugPrint(
            '🔄 FeedbackHistoryPage: Loading feedback for user ${authState.user!.uid}');
        _startLoading();
        ref
            .read(feedbackControllerProvider.notifier)
            .loadUserFeedback(authState.user!.uid)
            .then((_) {
          _stopLoading();
        });
      } else {
        debugPrint('⚠️ FeedbackHistoryPage: No user UID available');
        _stopLoading();
      }
    });
  }

  void _startLoading() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      _rotationController.repeat();
    }
  }

  void _stopLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _rotationController.stop();
      _rotationController.reset();
    }
  }

  void _refreshFeedback() {
    final authState = ref.read(authStateProvider);
    if (authState.user?.uid != null) {
      _startLoading();
      ref
          .read(feedbackControllerProvider.notifier)
          .loadUserFeedback(authState.user!.uid)
          .then((_) {
        _stopLoading();
      });
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final feedbackController = ref.read(feedbackControllerProvider.notifier);

    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              th.background,
            ],
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(context),

              // Content Area
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: feedbackController.feedbacksNotifier,
                  builder: (context, feedbacks, _) {
                    debugPrint(
                        '📋 FeedbackHistoryPage: Feedbacks updated: ${feedbacks.length} items');
                    return feedbacks.isEmpty
                        ? _buildEmptyState()
                        : _buildFeedbackList(feedbacks);
                  },
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppDesign.spaceXL),
          ProfessionalCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 64,
                  color: th.textSecondary,
                ),
                const SizedBox(height: AppDesign.spaceLG),
                Text(
                  'No Feedback Yet',
                  style: TextStyle(
                    fontSize: AppDesign.text2XL,
                    fontWeight: FontWeight.bold,
                    color: th.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                Text(
                  'Share your feedback about buses and drivers to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDesign.textMD,
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackList(feedbacks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      child: Column(
        children: [
          const SizedBox(height: AppDesign.spaceLG),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feedbacks.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDesign.spaceMD),
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return _buildFeedbackCard(feedback);
            },
          ),
          const SizedBox(height: AppDesign.spaceLG),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(feedback) {
    final th = ThemeHelper.of(context);
    final dateFormatter = DateFormat('MMM dd, yyyy • hh:mm a');
    final submittedDate = dateFormatter.format(feedback.submittedAt);

    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with bus number and status
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getStatusGradient(feedback.status),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDesign.radiusLG),
                topRight: Radius.circular(AppDesign.radiusLG),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (feedback.busNumber != null)
                        Text(
                          'Bus ${feedback.busNumber}',
                          style: const TextStyle(
                            fontSize: AppDesign.textLG,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(height: AppDesign.spaceXS),
                      Text(
                        feedback.title,
                        style: TextStyle(
                          fontSize: AppDesign.textMD,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Text(
                    _getStatusText(feedback.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: AppDesign.textSM,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating and Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Icon(
                            i < feedback.rating.overall
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: AppColors.primaryColor,
                            size: 18,
                          ),
                        const SizedBox(width: AppDesign.spaceSM),
                        Text(
                          '${feedback.rating.overall}/5',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: th.textPrimary,
                          ),
                        ),
                      ],
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
                      child: const Text(
                        '',
                        style: TextStyle(
                          fontSize: AppDesign.textSM,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spaceMD),

                // Category chip
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
                    _getCategoryText(feedback.category),
                    style: const TextStyle(
                      fontSize: AppDesign.textSM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),

                // Comment
                if (feedback.comment.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comment',
                        style: TextStyle(
                          fontSize: AppDesign.textSM,
                          fontWeight: FontWeight.w600,
                          color: th.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDesign.spaceSM),
                      Text(
                        feedback.comment,
                        style: TextStyle(
                          fontSize: AppDesign.textMD,
                          color: th.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppDesign.spaceMD),
                    ],
                  ),

                // Date
                Text(
                  'Submitted: $submittedDate',
                  style: TextStyle(
                    fontSize: AppDesign.textSM,
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getStatusGradient(status) {
    switch (status.toString()) {
      case 'FeedbackStatus.submitted':
        return [AppColors.primaryColor, AppColors.primaryDark];
      case 'FeedbackStatus.reviewed':
        return [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
      case 'FeedbackStatus.resolved':
        return [const Color(0xFF2196F3), const Color(0xFF1565C0)];
      case 'FeedbackStatus.rejected':
        return [const Color(0xFFF44336), const Color(0xFFC62828)];
      default:
        return [AppColors.primaryColor, AppColors.primaryDark];
    }
  }

  String _getStatusText(status) {
    switch (status.toString()) {
      case 'FeedbackStatus.submitted':
        return 'Submitted';
      case 'FeedbackStatus.reviewed':
        return 'Reviewed';
      case 'FeedbackStatus.resolved':
        return 'Resolved';
      case 'FeedbackStatus.rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  String _getCategoryText(category) {
    switch (category.toString()) {
      case 'FeedbackCategory.general':
        return 'General';
      case 'FeedbackCategory.safety':
        return 'Safety';
      case 'FeedbackCategory.service':
        return 'Service';
      case 'FeedbackCategory.driver':
        return 'Driver';
      case 'FeedbackCategory.busCondition':
        return 'Bus Condition';
      default:
        return 'Other';
    }
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: const CustomBackButton(
                  color: Colors.white,
                ),
              ),
              // Right corner refresh process icon
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: RotationTransition(
                  turns: _rotationController,
                  child: IconButton(
                    onPressed: _isLoading ? null : _refreshFeedback,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: _isLoading
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                      size: AppDesign.iconLG,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Feedback History',
                      style: TextStyle(
                        fontSize: AppDesign.text2XL,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'Track all your feedback submissions',
                      style: TextStyle(
                        fontSize: AppDesign.textMD,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
