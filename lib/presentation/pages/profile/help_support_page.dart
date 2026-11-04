import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/presentation/pages/profile/faq_page.dart';
import 'package:safedriver_passenger_app/presentation/pages/profile/live_chat_page.dart';
import 'package:safedriver_passenger_app/presentation/pages/profile/support_category_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../widgets/common/profile_page_components.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Help & Support',
      accentColor: AppColors.infoColor,
      children: [
        _buildQuickActions(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildCategorySection(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildContactSection(context),
        const SizedBox(height: AppDesign.spaceLG),
        _buildFaqCallout(context),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.flash_on_rounded,
            title: 'Quick Actions',
            subtitle: 'Choose the fastest way to get help right now.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Column(
            children: [
              _SupportQuickActionCard(
                icon: Icons.call_rounded,
                title: 'Call Support',
                description:
                    'Speak with our team for urgent help and real-time assistance.',
                detail: '24/7 hotline',
                badge: 'Fastest',
                color: AppColors.successColor,
                onTap: () => _makeCall('0112123123'),
              ),
              const SizedBox(height: AppDesign.spaceMD),
              _SupportQuickActionCard(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Live Chat',
                description:
                    'Start a conversation without leaving the app and share details quickly.',
                detail: 'Average reply in minutes',
                badge: 'In app',
                color: AppColors.primaryColor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveChatPage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.grid_view_rounded,
            title: 'Support Categories',
            subtitle: 'Jump straight to the topic that matches your issue.',
            color: AppColors.accentColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ProfileActionTile(
            icon: Icons.bug_report_outlined,
            title: 'App Issues',
            subtitle: 'Technical problems, crashes, and unexpected behaviour.',
            onTap: () => _openCategory(context, 'App Issues'),
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.directions_bus_outlined,
            title: 'Bus Services',
            subtitle: 'Questions about routes, timings, and service updates.',
            color: AppColors.warningColor,
            onTap: () => _openCategory(context, 'Bus Services'),
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.lock_person_outlined,
            title: 'Account & Security',
            subtitle: 'Login trouble, privacy concerns, and account safety.',
            color: AppColors.successColor,
            onTap: () => _openCategory(context, 'Account & Security'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.contact_support_outlined,
            title: 'Contact Details',
            subtitle: 'Save the key ways to reach the SafeDriver team.',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _ContactInfoTile(
            icon: Icons.call_outlined,
            label: 'Phone',
            value: '0112123123',
            onTap: () => _makeCall('0112123123'),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _ContactInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'info@safedriver.com',
            onTap: () => _sendEmail(),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _ContactInfoTile(
            icon: Icons.language_rounded,
            label: 'Website',
            value: 'www.safedriver.com',
            onTap: () => _openWebsite(),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          const _ContactInfoTile(
            icon: Icons.schedule_rounded,
            label: 'Hours',
            value: '24/7 support available',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqCallout(BuildContext context) {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.infoColor.withValues(alpha: 0.12),
              AppColors.primaryColor.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: AppColors.infoColor.withValues(alpha: 0.16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.quiz_outlined,
                  color: AppColors.infoColor,
                  size: AppDesign.iconSM,
                ),
                SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    'Frequently Asked Questions',
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
              'Browse common answers about journeys, safety tools, account access, and support workflows before raising a ticket.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: th.textSecondary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.infoColor,
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
              label: const Text('Open FAQ'),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategory(BuildContext context, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportCategoryPage(
          categoryName: categoryName,
        ),
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    await _launchUri(Uri(scheme: 'tel', path: phoneNumber));
  }

  Future<void> _sendEmail() async {
    await _launchUri(
      Uri(
        scheme: 'mailto',
        path: 'info@safedriver.com',
        queryParameters: const {
          'subject': 'SafeDriver Support',
        },
      ),
    );
  }

  Future<void> _openWebsite() async {
    await _launchUri(Uri.parse('https://www.safedriver.com'));
  }

  Future<void> _launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SupportQuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String detail;
  final String badge;
  final Color color;
  final VoidCallback onTap;

  const _SupportQuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
    required this.badge,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        child: Ink(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.12),
                color.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            border: Border.all(color: color.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                ),
                child: Icon(icon, color: color, size: AppDesign.iconMD),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.headline6.copyWith(
                              color: th.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesign.spaceSM,
                            vertical: AppDesign.spaceXS,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.72),
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusFull),
                            border: Border.all(
                              color: color.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: th.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceMD),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDesign.spaceSM,
                            vertical: AppDesign.spaceXS,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppDesign.radiusFull),
                          ),
                          child: Text(
                            detail,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: color,
                          size: AppDesign.iconSM,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _ContactInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final content = Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: th.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(
              icon,
              size: AppDesign.iconSM,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: th.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.open_in_new_rounded,
              size: AppDesign.iconSM,
              color: th.textHint,
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        child: content,
      ),
    );
  }
}
