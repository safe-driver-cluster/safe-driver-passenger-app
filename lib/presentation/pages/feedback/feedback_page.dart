import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';

class FeedbackPage extends StatefulWidget {
  final String? busId;
  final String? driverId;
  final String? tripId;

  const FeedbackPage({super.key, this.busId, this.driverId, this.tripId});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with TickerProviderStateMixin {
  int selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  String selectedCategory = 'General';
  late AnimationController _ratingAnimationController;
  late Animation<double> _ratingAnimation;
  
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          // Professional Header
          _buildProfessionalHeader(),
          
          // Feedback Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Column(
                children: [
                  // Trip Info Card
                  if (widget.busId != null) _buildTripInfoCard(),
                  
                  const SizedBox(height: AppDesign.space2XL),
                  
                  // Rating Section
                  _buildRatingSection(),
                  
                  const SizedBox(height: AppDesign.space2XL),
                  
                  // Category Selection
                  _buildCategorySection(),
                  
                  const SizedBox(height: AppDesign.space2XL),
                  
                  // Feedback Text
                  _buildFeedbackSection(),
                  
                  const SizedBox(height: AppDesign.space2XL),
                  
                  // Submit Button
                  _buildSubmitSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        60,
        AppDesign.spaceLG,
        AppDesign.space2XL,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.space2XL),
          bottomRight: Radius.circular(AppDesign.space2XL),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: AppDesign.iconMD,
              ),
            ),
          ),
          
          const SizedBox(width: AppDesign.spaceLG),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Feedback',
                  style: AppTextStyles.headline4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Help us improve your experience',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.feedback_rounded,
              color: Colors.white,
              size: AppDesign.iconLG,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfoCard() {
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
                'Trip Information',
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
                child: _buildInfoItem('Bus ID', widget.busId ?? 'N/A'),
              ),
              Expanded(
                child: _buildInfoItem('Trip ID', widget.tripId ?? 'N/A'),
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

  Widget _buildRatingSection() {
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
                'Rate Your Experience',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppDesign.spaceLG),
          
          Text(
            'How was your overall experience?',
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
                          isSelected ? Icons.star_rounded : Icons.star_border_rounded,
                          color: isSelected ? AppColors.warningColor : AppColors.textHint,
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
                    _getRatingText(),
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

  Widget _buildCategorySection() {
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
                'Feedback Category',
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
                    category,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
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

  Widget _buildFeedbackSection() {
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
                'Your Feedback',
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
              hintText: 'Tell us about your experience...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: const BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(AppDesign.spaceLG),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canSubmit() ? _submitFeedback : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canSubmit() ? AppColors.primaryColor : AppColors.greyLight,
              foregroundColor: _canSubmit() ? Colors.white : AppColors.textHint,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceLG),
            ),
            child: const Text('Submit Feedback'),
          ),
        ),
        
        const SizedBox(height: AppDesign.spaceMD),
        
        Text(
          'Your feedback helps us improve our service',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
          textAlign: TextAlign.center,
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

  String _getRatingText() {
    switch (selectedRating) {
      case 1: return 'Very Poor';
      case 2: return 'Poor';
      case 3: return 'Average';
      case 4: return 'Good';
      case 5: return 'Excellent';
      default: return '';
    }
  }

  bool _canSubmit() {
    return selectedRating > 0 && _feedbackController.text.trim().isNotEmpty;
  }

  void _submitFeedback() {
    // Implement feedback submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for your feedback!'),
        backgroundColor: AppColors.successColor,
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _ratingAnimationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
