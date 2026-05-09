import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';

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
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CustomBackButton(
                      color: Colors.white,
                      backgroundColor: Color(0x33FFFFFF),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Notifications',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: th.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.infoColor.withOpacity(0.1),
                                    AppColors.primaryColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.notifications_active,
                                size: 30,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stay Updated',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: th.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Customize your notification preferences',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: th.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Notification Settings
                        Expanded(
                          child: ListView(
                            children: [
                              // General Notifications
                              Text(
                                'General',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: th.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildNotificationTile(
                                th,
                                '📱',
                                'Push Notifications',
                                'Receive notifications on your device',
                                pushNotifications,
                                (value) =>
                                    setState(() => pushNotifications = value),
                              ),

                              _buildNotificationTile(
                                th,
                                '📧',
                                'Email Notifications',
                                'Get updates via email',
                                emailNotifications,
                                (value) =>
                                    setState(() => emailNotifications = value),
                              ),

                              _buildNotificationTile(
                                th,
                                '💬',
                                'SMS Notifications',
                                'Receive SMS updates',
                                smsNotifications,
                                (value) =>
                                    setState(() => smsNotifications = value),
                              ),

                              const SizedBox(height: 24),

                              // Trip & Safety
                              Text(
                                'Trip & Safety',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: th.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildNotificationTile(
                                th,
                                '🚨',
                                'Safety Alerts',
                                'Important safety notifications',
                                safetyAlerts,
                                (value) => setState(() => safetyAlerts = value),
                                isImportant: true,
                              ),

                              _buildNotificationTile(
                                th,
                                '🚌',
                                'Trip Updates',
                                'Bus arrival times and delays',
                                tripUpdates,
                                (value) => setState(() => tripUpdates = value),
                              ),

                              const SizedBox(height: 24),

                              // Marketing
                              Text(
                                'Marketing',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: th.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildNotificationTile(
                                th,
                                '🎉',
                                'Promotional Offers',
                                'Special deals and discounts',
                                promotionalOffers,
                                (value) =>
                                    setState(() => promotionalOffers = value),
                              ),

                              const SizedBox(height: 32),

                              // Info Box
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.infoColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.infoColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: AppColors.infoColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'You can change these settings anytime. Safety alerts are recommended for your security.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: th.textPrimary,
                                        ),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(ThemeHelper th, String emoji, String title,
      String description, bool value, Function(bool) onChanged,
      {bool isImportant = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isImportant
            ? AppColors.safeColor.withOpacity(0.05)
            : th.subtleBackground,
        borderRadius: BorderRadius.circular(12),
        border: isImportant
            ? Border.all(color: AppColors.safeColor.withOpacity(0.2))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: th.cardBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: th.textPrimary,
                        ),
                      ),
                    ),
                    if (isImportant)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.safeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'RECOMMENDED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
