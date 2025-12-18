import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';

class FeedbackHistoryPage extends StatelessWidget {
  const FeedbackHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildModernHeader(context),

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDesign.spaceLG),

                      // Coming Soon Card
                      ProfessionalCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history_rounded,
                              size: 64,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppDesign.spaceLG),
                            const Text(
                              'Feedback History',
                              style: TextStyle(
                                fontSize: AppDesign.text2XL,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppDesign.spaceSM),
                            const Text(
                              'View your past feedback submissions and their status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDesign.textMD,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppDesign.spaceXL),
                            Container(
                              padding: const EdgeInsets.all(AppDesign.spaceLG),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusLG),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'Coming Soon',
                                style: TextStyle(
                                  fontSize: AppDesign.textLG,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add filter functionality
                  },
                  icon: const Icon(
                    Icons.filter_list_rounded,
                    color: Colors.white,
                    size: AppDesign.iconLG,
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
