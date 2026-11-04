import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/passenger_model.dart';
import '../../../providers/passenger_provider.dart';
import '../../widgets/common/profile_page_components.dart';
import 'received_notifications_page.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final passengerAsync = ref.watch(currentPassengerProvider);

    return ProfilePageScaffold(
      title: 'Notifications',
      accentColor: AppColors.primaryGradientEnd,
      children: [
        _buildInboxSection(),
        const SizedBox(height: AppDesign.spaceLG),
        passengerAsync.when(
          data: (passenger) => _buildPreferencesSection(passenger),
          loading: () => _buildLoadingCard(),
          error: (error, _) => _buildErrorCard(error),
        ),
        const SizedBox(height: AppDesign.spaceLG),
        _buildInfoCard(context),
      ],
    );
  }

  Widget _buildInboxSection() {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.10),
              AppColors.infoColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.inbox_outlined,
                  color: AppColors.primaryColor,
                  size: AppDesign.iconSM,
                ),
                SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    'Notification Inbox',
                    style: TextStyle(
                      fontSize: AppDesign.textLG,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceSM),
            Text(
              'Open the full in-app inbox to review every push and app alert in one place.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: th.textSecondary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReceivedNotificationsPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceLG,
                  vertical: AppDesign.spaceMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text('Open inbox'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection(PassengerModel? passenger) {
    if (passenger == null) {
      return const ProfileSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSectionHeader(
              icon: Icons.notifications_off_outlined,
              title: 'Notification Preferences',
              subtitle: 'Sign in to manage your delivery settings.',
              color: AppColors.warningColor,
            ),
          ],
        ),
      );
    }

    final notifications = passenger.preferences.notifications;
    final pushEnabled = notifications.safetyAlerts ||
        notifications.journeyUpdates ||
        notifications.emergencyAlerts ||
        notifications.systemAnnouncements;

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.tune_rounded,
            title: 'Delivery Preferences',
            subtitle: 'Choose which notifications should reach this device.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildToggleTile(
            icon: Icons.smartphone_rounded,
            color: AppColors.primaryColor,
            title: 'Push notifications',
            description:
                'Turn device alerts on or off for journeys, safety, and service updates.',
            value: pushEnabled,
            emphasized: pushEnabled,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(
                safetyAlerts: value,
                journeyUpdates: value,
                emergencyAlerts: value,
                systemAnnouncements: value,
              ),
              successMessage: value
                  ? 'Push notifications enabled.'
                  : 'Push notifications disabled.',
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            icon: Icons.email_outlined,
            color: AppColors.infoColor,
            title: 'Email notifications',
            description:
                'Receive email copies for important account and journey updates.',
            value: notifications.emailEnabled,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(emailEnabled: value),
              successMessage: value
                  ? 'Email notifications enabled.'
                  : 'Email notifications disabled.',
            ),
          ),
          const SizedBox(height: AppDesign.spaceXL),
          const ProfileSectionHeader(
            icon: Icons.health_and_safety_outlined,
            title: 'Trip & Safety Alerts',
            subtitle: 'Control the high-priority updates that matter most.',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildToggleTile(
            icon: Icons.shield_outlined,
            color: AppColors.successColor,
            title: 'Safety alerts',
            description:
                'Critical safety notices and warnings related to your travel area.',
            value: notifications.safetyAlerts,
            emphasized: notifications.safetyAlerts,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(safetyAlerts: value),
              successMessage:
                  value ? 'Safety alerts enabled.' : 'Safety alerts disabled.',
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            icon: Icons.warning_amber_rounded,
            color: AppColors.warningColor,
            title: 'Emergency alerts',
            description:
                'Urgent events and emergency instructions that should never be missed.',
            value: notifications.emergencyAlerts,
            emphasized: notifications.emergencyAlerts,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(emergencyAlerts: value),
              successMessage: value
                  ? 'Emergency alerts enabled.'
                  : 'Emergency alerts disabled.',
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            icon: Icons.directions_bus_outlined,
            color: AppColors.primaryColor,
            title: 'Journey updates',
            description:
                'Bus arrivals, delays, route changes, and active trip notifications.',
            value: notifications.journeyUpdates,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(journeyUpdates: value),
              successMessage: value
                  ? 'Journey updates enabled.'
                  : 'Journey updates disabled.',
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildToggleTile(
            icon: Icons.campaign_outlined,
            color: AppColors.accentColor,
            title: 'System announcements',
            description:
                'General app announcements, service changes, and maintenance notices.',
            value: notifications.systemAnnouncements,
            onChanged: (value) => _savePassengerNotifications(
              passenger,
              notifications.copyWith(systemAnnouncements: value),
              successMessage: value
                  ? 'System announcements enabled.'
                  : 'System announcements disabled.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return const ProfileSectionCard(
      child: Padding(
        padding: EdgeInsets.all(AppDesign.spaceLG),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(Object error) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load preferences',
            subtitle: 'Try again in a moment.',
            color: AppColors.errorColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            '$error',
            style: AppTextStyles.bodySmall.copyWith(
              color: ThemeHelper.of(context).textSecondary,
            ),
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
                'Push delivery depends on both app preferences and your device-level notification permission. If alerts stop arriving, check the SafeDriver notification permission from system settings.',
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
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool emphasized = false,
  }) {
    return _NotificationTile(
      icon: icon,
      color: color,
      title: title,
      description: description,
      value: value,
      emphasized: emphasized,
      onChanged: onChanged,
    );
  }

  Future<void> _savePassengerNotifications(
    PassengerModel passenger,
    PassengerNotificationSettings notifications, {
    required String successMessage,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final updatedPreferences = passenger.preferences.copyWith(
        notifications: notifications,
      );

      await ref.read(passengerControllerProvider.notifier).updatePreferences(
            userId: passenger.id,
            preferences: updatedPreferences,
          );

      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('Unable to update notification preferences: $error'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
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
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
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
