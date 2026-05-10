import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../widgets/common/profile_page_components.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;
  bool safetyAlerts = true;
  bool tripUpdates = true;
  bool promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Notifications',
      accentColor: AppColors.primaryGradientEnd,
      children: [
        _buildDeliverySection(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildTripSection(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildMarketingSection(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildInfoCard(context),
      ],
    );
  }

  Widget _buildDeliverySection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.send_outlined,
            title: 'Delivery Channels',
            subtitle: 'Decide where everyday notifications should reach you.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildToggleTile(
            context: context,
            icon: Icons.smartphone_rounded,
            color: AppColors.primaryColor,
            title: 'Push notifications',
            description: 'Receive updates directly on your device.',
            value: pushNotifications,
            onChanged: (value) => setState(() => pushNotifications = value),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            context: context,
            icon: Icons.email_outlined,
            color: AppColors.infoColor,
            title: 'Email notifications',
            description: 'Get a written copy of important service updates.',
            value: emailNotifications,
            onChanged: (value) => setState(() => emailNotifications = value),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            context: context,
            icon: Icons.sms_outlined,
            color: AppColors.warningColor,
            title: 'SMS notifications',
            description: 'Receive quick text alerts when needed.',
            value: smsNotifications,
            onChanged: (value) => setState(() => smsNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.route_outlined,
            title: 'Trip & Safety',
            subtitle: 'Keep the high-value journey and protection updates on.',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildToggleTile(
            context: context,
            icon: Icons.health_and_safety_outlined,
            color: AppColors.successColor,
            title: 'Safety alerts',
            description:
                'Critical safety notices and emergency-related updates.',
            value: safetyAlerts,
            badge: 'Recommended',
            emphasized: true,
            onChanged: (value) => setState(() => safetyAlerts = value),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            context: context,
            icon: Icons.directions_bus_outlined,
            color: AppColors.primaryColor,
            title: 'Trip updates',
            description: 'Bus arrival times, delays, and route changes.',
            value: tripUpdates,
            onChanged: (value) => setState(() => tripUpdates = value),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketingSection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.local_offer_outlined,
            title: 'Offers & Promotions',
            subtitle: 'Opt into occasional discounts and rider campaigns.',
            color: AppColors.accentColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildToggleTile(
            context: context,
            icon: Icons.campaign_outlined,
            color: AppColors.accentColor,
            title: 'Promotional offers',
            description: 'Special deals, new-feature launches, and campaigns.',
            value: promotionalOffers,
            onChanged: (value) => setState(() => promotionalOffers = value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: AppColors.infoColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.infoColor.withValues(alpha: 0.14),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.infoColor,
              size: AppDesign.iconSM,
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: Text(
                'Notification preferences can be updated any time. Keeping safety alerts enabled helps you receive urgent information as quickly as possible.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: th.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? badge,
    bool emphasized = false,
  }) {
    return _NotificationTile(
      icon: icon,
      color: color,
      title: title,
      description: description,
      badge: badge,
      value: value,
      emphasized: emphasized,
      onChanged: onChanged,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String? badge;
  final bool value;
  final bool emphasized;
  final ValueChanged<bool> onChanged;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.badge,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: emphasized ? color.withValues(alpha: 0.07) : th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: emphasized ? color.withValues(alpha: 0.18) : th.borderLight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(icon, size: AppDesign.iconSM, color: color),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: th.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: AppDesign.spaceSM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spaceSM,
                          vertical: AppDesign.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                        ),
                        child: Text(
                          badge!,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
