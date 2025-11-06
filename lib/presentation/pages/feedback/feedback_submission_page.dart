import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/feedback_model.dart';
import '../../../providers/auth_provider.dart';
import '../../controllers/feedback_controller.dart';
import 'feedback_system_page.dart';

class FeedbackSubmissionPage extends ConsumerStatefulWidget {
  final String busNumber;
  final FeedbackTarget feedbackTarget;

  const FeedbackSubmissionPage({
    super.key,
    required this.busNumber,
    required this.feedbackTarget,
  });

  @override
  ConsumerState<FeedbackSubmissionPage> createState() =>
      _FeedbackSubmissionPageState();
}

class _FeedbackSubmissionPageState extends ConsumerState<FeedbackSubmissionPage>
    with TickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  String? selectedQuickAction;
  bool isSubmitting = false;

  late AnimationController _starAnimationController;
  late List<AnimationController> _starControllers;

  final List<String> busQuickActions = [
    'Clean and comfortable',
    'Good condition',
    'Air conditioning works well',
    'Seats are comfortable',
    'Bus needs cleaning',
    'Maintenance required',
    'Uncomfortable seats',
    'Poor ventilation',
  ];

  final List<String> driverQuickActions = [
    'Excellent driving',
    'Courteous and helpful',
    'Safe driving',
    'Professional behavior',
    'Reckless driving',
    'Unprofessional behavior',
    'Poor customer service',
    'Safety concerns',
  ];

  @override
  void initState() {
    super.initState();
    _starAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _starControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 200 + (index * 50)),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _starAnimationController.dispose();
    for (var controller in _starControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        title: Text(
          '${widget.feedbackTarget == FeedbackTarget.bus ? 'Bus' : 'Driver'} Feedback',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBusInfoHeader(),
                  const SizedBox(height: AppDesign.spaceXL),
                  _buildRatingSection(),
                  const SizedBox(height: AppDesign.spaceXL),
                  _buildQuickActionsSection(),
                  const SizedBox(height: AppDesign.spaceXL),
                  _buildCommentSection(),
                  const SizedBox(height: AppDesign.spaceXL),
                ],
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildBusInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: widget.feedbackTarget == FeedbackTarget.bus
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : AppColors.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(
              widget.feedbackTarget == FeedbackTarget.bus
                  ? Icons.directions_bus
                  : Icons.person,
              color: widget.feedbackTarget == FeedbackTarget.bus
                  ? AppColors.primaryColor
                  : AppColors.accentColor,
              size: AppDesign.iconLG,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${widget.busNumber}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  '${widget.feedbackTarget == FeedbackTarget.bus ? 'Bus' : 'Driver'} Feedback',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            _getRatingDescription(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildStarRating(),
          if (selectedRating > 0) ...[
            const SizedBox(height: AppDesign.spaceMD),
            _buildRatingFeedback(),
          ],
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => _selectRating(index + 1),
          child: AnimatedBuilder(
            animation: _starControllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: selectedRating > index ? 1.2 : 1.0,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceXS),
                  child: Icon(
                    selectedRating > index ? Icons.star : Icons.star_outline,
                    size: 40,
                    color: selectedRating > index
                        ? _getStarColor(index + 1)
                        : AppColors.greyMedium,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildRatingFeedback() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: _getRatingColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(
          color: _getRatingColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getRatingIcon(),
            color: _getRatingColor(),
            size: 20,
          ),
          const SizedBox(width: AppDesign.spaceSM),
          Text(
            _getRatingText(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _getRatingColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    final actions = widget.feedbackTarget == FeedbackTarget.bus
        ? busQuickActions
        : driverQuickActions;

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick feedback (optional)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Select a common feedback or write your own below',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Wrap(
            spacing: AppDesign.spaceSM,
            runSpacing: AppDesign.spaceSM,
            children:
                actions.map((action) => _buildQuickActionChip(action)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String action) {
    final isSelected = selectedQuickAction == action;
    final isPositive = _isPositiveAction(action);

    return GestureDetector(
      onTap: () => _selectQuickAction(action),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceMD,
          vertical: AppDesign.spaceSM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isPositive ? AppColors.successColor : AppColors.warningColor)
              : AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
          border: isSelected
              ? Border.all(
                  color: isPositive
                      ? AppColors.successColor
                      : AppColors.warningColor,
                  width: 2,
                )
              : null,
        ),
        child: Text(
          action,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceSM),
          const Text(
            'Share more details about your experience (optional)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: 'Type your feedback here...',
              hintStyle: const TextStyle(
                color: AppColors.textHint,
              ),
              filled: true,
              fillColor: AppColors.greyExtraLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              counterStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: const BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSubmit() ? _submitFeedback : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  String _getRatingDescription() {
    if (widget.feedbackTarget == FeedbackTarget.bus) {
      return 'How would you rate the overall condition and comfort of the bus?';
    } else {
      return 'How would you rate the driver\'s performance and professionalism?';
    }
  }

  void _selectRating(int rating) {
    setState(() {
      selectedRating = rating;
    });

    // Animate stars
    for (int i = 0; i < rating; i++) {
      _starControllers[i].forward();
    }
    for (int i = rating; i < 5; i++) {
      _starControllers[i].reverse();
    }
  }

  void _selectQuickAction(String action) {
    setState(() {
      if (selectedQuickAction == action) {
        selectedQuickAction = null;
      } else {
        selectedQuickAction = action;
      }
    });
  }

  Color _getStarColor(int rating) {
    if (rating <= 2) return AppColors.dangerColor;
    if (rating == 3) return AppColors.warningColor;
    return AppColors.successColor;
  }

  Color _getRatingColor() {
    if (selectedRating <= 2) return AppColors.dangerColor;
    if (selectedRating == 3) return AppColors.warningColor;
    return AppColors.successColor;
  }

  IconData _getRatingIcon() {
    if (selectedRating <= 2) return Icons.sentiment_very_dissatisfied;
    if (selectedRating == 3) return Icons.sentiment_neutral;
    if (selectedRating == 4) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_satisfied;
  }

  String _getRatingText() {
    switch (selectedRating) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  bool _isPositiveAction(String action) {
    const positiveKeywords = [
      'clean',
      'comfortable',
      'good',
      'excellent',
      'courteous',
      'helpful',
      'safe',
      'professional',
      'works well',
    ];

    return positiveKeywords.any(
      (keyword) => action.toLowerCase().contains(keyword),
    );
  }

  bool _canSubmit() {
    return selectedRating > 0 && !isSubmitting;
  }

  Future<void> _submitFeedback() async {
    if (!_canSubmit()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Get current user info
      final user = ref.read(simpleUserProvider);

      debugPrint('🔍 Starting feedback submission...');
      debugPrint('👤 User: ${user['name']} (${user['id']})');
      debugPrint('🚌 Bus: ${widget.busNumber}');
      debugPrint('⭐ Rating: $selectedRating');
      debugPrint('📝 Comment: ${_commentController.text.trim()}');

      // Submit to Firebase
      await ref.read(feedbackControllerProvider.notifier).submitFeedback(
        userId: user['id']!,
        userName: user['name']!,
        busId: widget.busNumber,
        busNumber: widget.busNumber,
        rating: selectedRating,
        comment: _commentController.text.trim().isEmpty
            ? selectedQuickAction ?? _getRatingText()
            : _commentController.text.trim(),
        category: widget.feedbackTarget == FeedbackTarget.bus
            ? FeedbackCategory.vehicle
            : FeedbackCategory.driver,
        type:
            selectedRating >= 4 ? FeedbackType.positive : FeedbackType.negative,
        title: selectedQuickAction ?? _getRatingText(),
        metadata: {
          'feedbackTarget': widget.feedbackTarget.name,
          'quickAction': selectedQuickAction,
          'platform': 'mobile',
        },
      );

      debugPrint('✅ Feedback submitted successfully!');

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  List<String> _generateTags() {
    final tags = <String>[];

    tags.add(widget.feedbackTarget.name);
    tags.add('bus-${widget.busNumber}');
    tags.add('rating-$selectedRating');

    if (selectedQuickAction != null) {
      if (_isPositiveAction(selectedQuickAction!)) {
        tags.add('positive');
      } else {
        tags.add('negative');
      }
    }

    return tags;
  }

  FeedbackPriority _getPriority() {
    if (selectedRating <= 2) return FeedbackPriority.high;
    if (selectedRating == 3) return FeedbackPriority.medium;
    return FeedbackPriority.low;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.successColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            const Text(
              'Feedback Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            const Text(
              'Thank you for your feedback. It helps us improve our service.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close feedback page
              Navigator.of(context).pop(); // Close feedback system page
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error,
                color: AppColors.errorColor,
                size: 48,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            const Text(
              'Submission Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceSM),
            const Text(
              'Failed to submit feedback. Please try again.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Try Again',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
