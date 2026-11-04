import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/feedback_model.dart';
import '../../../data/repositories/feedback_repository.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/professional_widgets.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  final String? busId;
  final String? driverId;
  final String? tripId;

  const FeedbackPage({super.key, this.busId, this.driverId, this.tripId});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage>
    with TickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  String selectedCategory = 'General';
  late AnimationController _ratingAnimationController;
  late Animation<double> _ratingAnimation;
  bool _isSubmitting = false;

  List<String> categories = [
    'General',
    'Driver',
    'Bus Condition',
    'Safety',
    'Route',
    'Service'
  ];

  @override
  void initState() {
    super.initState();
    _ratingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _ratingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _ratingAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(l10n),

              // Feedback Content
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
                  child: Column(
                    children: [
                      // Trip Info Card
                      if (widget.busId != null) _buildTripInfoCard(l10n),

                      const SizedBox(height: AppDesign.space2XL),

                      // Rating Section
                      _buildRatingSection(l10n),

                      const SizedBox(height: AppDesign.space2XL),

                      // Category Selection
                      _buildCategorySection(l10n),

                      const SizedBox(height: AppDesign.space2XL),

                      // Feedback Text
                      _buildFeedbackSection(l10n),

                      const SizedBox(height: AppDesign.space2XL),

                      // Submit Button
                      _buildSubmitSection(l10n),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(AppLocalizations l10n) {
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
              const CustomBackButton(
                color: Colors.white,
                backgroundColor: Color(0x33FFFFFF),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.shareFeedback,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.feedbackSubtitle,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.feedback_rounded,
                    color: Colors.white,
                    size: AppDesign.iconMD,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoCard(AppLocalizations l10n) {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: AppColors.primaryColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.tripInformation,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(l10n.busIdTitle, widget.busId ?? 'N/A'),
              ),
              Expanded(
                child: _buildInfoItem(l10n.tripIdTitle, widget.tripId ?? 'N/A'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceXS),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(AppLocalizations l10n) {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.warningColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.rateExperience,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            l10n.overallExperience,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= selectedRating;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = starIndex;
                  });
                  _ratingAnimationController.forward().then((_) {
                    _ratingAnimationController.reverse();
                  });
                },
                child: AnimatedBuilder(
                  animation: _ratingAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSelected && selectedRating == starIndex
                          ? _ratingAnimation.value
                          : 1.0,
                      child: Container(
                        padding: const EdgeInsets.all(AppDesign.spaceMD),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.warningColor.withOpacity(0.1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSelected
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: isSelected
                              ? AppColors.warningColor
                              : AppColors.textHint,
                          size: AppDesign.icon2XL,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          if (selectedRating > 0) ...[
            const SizedBox(height: AppDesign.spaceLG),
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: _getRatingColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getRatingIcon(),
                    color: _getRatingColor(),
                    size: AppDesign.iconSM,
                  ),
                  const SizedBox(width: AppDesign.spaceXS),
                  Text(
                    _getRatingText(l10n),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _getRatingColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(AppLocalizations l10n) {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.category_rounded,
                  color: AppColors.accentColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.feedbackCategory,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Wrap(
            spacing: AppDesign.spaceMD,
            runSpacing: AppDesign.spaceMD,
            children: categories.map((category) {
              final isSelected = selectedCategory == category;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceLG,
                    vertical: AppDesign.spaceMD,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Text(
                    _getCategoryDisplayName(category, l10n),
                    style: AppTextStyles.labelMedium.copyWith(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(AppLocalizations l10n) {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.message_rounded,
                  color: AppColors.successColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                l10n.yourFeedback,
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: l10n.feedbackHint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: const BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide:
                    const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(AppDesign.spaceLG),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSection(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSubmit() ? () => _submitFeedback(l10n) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canSubmit() ? AppColors.primaryColor : AppColors.greyLight,
              foregroundColor: _canSubmit() ? Colors.white : AppColors.textHint,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceLG),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(l10n.submitFeedback),
          ),
        ),
        const SizedBox(height: AppDesign.spaceMD),
        Text(
          l10n.feedbackRewardNote,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  Color _getRatingColor() {
    if (selectedRating <= 2) return AppColors.errorColor;
    if (selectedRating == 3) return AppColors.warningColor;
    return AppColors.successColor;
  }

  IconData _getRatingIcon() {
    if (selectedRating <= 2) return Icons.sentiment_dissatisfied_rounded;
    if (selectedRating == 3) return Icons.sentiment_neutral_rounded;
    return Icons.sentiment_satisfied_rounded;
  }

  String _getRatingText(AppLocalizations l10n) {
    switch (selectedRating) {
      case 1:
        return l10n.veryPoor;
      case 2:
        return l10n.poor;
      case 3:
        return l10n.average;
      case 4:
        return l10n.good;
      case 5:
        return l10n.excellent;
      default:
        return '';
    }
  }

  String _getCategoryDisplayName(String category, AppLocalizations l10n) {
    switch (category) {
      case 'General':
        return l10n.categoryGeneral;
      case 'Driver':
        return l10n.categoryDriver;
      case 'Bus Condition':
        return l10n.categoryBusCondition;
      case 'Safety':
        return l10n.categorySafety;
      case 'Route':
        return l10n.categoryRoute;
      case 'Service':
        return l10n.categoryService;
      default:
        return category;
    }
  }

  bool _canSubmit() {
    return selectedRating > 0 &&
        _feedbackController.text.trim().isNotEmpty &&
        !_isSubmitting;
  }

  void _submitFeedback(AppLocalizations l10n) async {
    if (!_canSubmit()) return;

    setState(() => _isSubmitting = true);

    try {
      // Get current user
      final authState = ref.read(authStateProvider);
      final userId = authState.user?.uid;
      final passengerProfile = authState.passengerProfile;

      if (userId == null || passengerProfile == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.userNotAuthenticated),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      // Map category string to FeedbackCategory enum
      final categoryMap = {
        'General': FeedbackCategory.general,
        'Driver': FeedbackCategory.driver,
        'Bus Condition': FeedbackCategory.vehicle,
        'Safety': FeedbackCategory.safety,
        'Route': FeedbackCategory.route,
        'Service': FeedbackCategory.service,
      };

      final category =
          categoryMap[selectedCategory] ?? FeedbackCategory.general;

      // Create feedback model
      final feedback = FeedbackModel(
        id: '', // Firestore will generate ID
        userId: userId,
        userName: passengerProfile.fullName,
        busId: widget.busId,
        driverId: widget.driverId,
        routeId: null,
        category: category,
        type: FeedbackType.positive, // Can be enhanced to detect from rating
        title: 'Feedback - $selectedCategory',
        description: _feedbackController.text.trim(),
        rating: FeedbackRating(overall: selectedRating),
        tags: [selectedCategory, 'mobile'],
        attachments: [],
        location: null,
        timestamp: DateTime.now(),
        status: FeedbackStatus.submitted,
        priority: FeedbackPriority.medium,
        metadata: {
          'tripId': widget.tripId,
          'appVersion': '1.0.0',
          'platform': 'mobile',
        },
        comment: _feedbackController.text.trim(),
        images: [],
        submittedAt: DateTime.now(),
        isAnonymous: false,
        relatedFeedbackIds: [],
      );

      // Submit feedback using repository
      final repository = FeedbackRepository();
      await repository.submitFeedback(feedback);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedbackSuccess),
            backgroundColor: AppColors.successColor,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ Error submitting feedback: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.feedbackError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _ratingAnimationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
