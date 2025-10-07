import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../common/professional_widgets.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onQrScan;
  final VoidCallback onSearch;
  final VoidCallback onEmergency;
  final VoidCallback? onFeedback;
  final VoidCallback? onSafetyInfo;
  final VoidCallback? onRoutes;

  const QuickActionsWidget({
    super.key,
    required this.onQrScan,
    required this.onSearch,
    required this.onEmergency,
    this.onFeedback,
    this.onSafetyInfo,
    this.onRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return ProfessionalCard(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      gradient: AppColors.cardGradient,
      borderRadius: AppDesign.radiusXL,
      shadows: AppDesign.shadowMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Actions Grid
          Row(
            children: [
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan QR',
                  subtitle: 'Quick boarding',
                  gradient: AppColors.primaryGradient,
                  onTap: onQrScan,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.search_rounded,
                  label: 'Search Bus',
                  subtitle: 'Find routes',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                  ),
                  onTap: onSearch,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Secondary Actions Grid
          Row(
            children: [
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.emergency_rounded,
                  label: 'Emergency',
                  subtitle: 'Get help now',
                  gradient: AppColors.dangerGradient,
                  onTap: onEmergency,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.feedback_rounded,
                  label: 'Feedback',
                  subtitle: 'Share thoughts',
                  gradient: AppColors.successGradient,
                  onTap: onFeedback ?? () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Additional Actions Row
          Row(
            children: [
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.route_rounded,
                  label: 'Routes',
                  subtitle: 'View all routes',
                  gradient: AppColors.accentGradient,
                  onTap: onRoutes ?? () {},
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: _buildProfessionalActionButton(
                  icon: Icons.security_rounded,
                  label: 'Safety Info',
                  subtitle: 'Learn more',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                  ),
                  onTap: onSafetyInfo ?? () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalActionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: AppDesign.iconLG,
                    color: Colors.white,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
