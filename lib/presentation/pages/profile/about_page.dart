import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../widgets/common/profile_page_components.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _packageInfoFuture,
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;

        return ProfilePageScaffold(
          title: 'About App',
          accentColor: AppColors.accentColor,
          children: [
            _buildBrandCard(context, packageInfo),
            const SizedBox(height: AppDesign.spaceLG),
            _buildOverviewSection(context),
            const SizedBox(height: AppDesign.spaceLG),
            _buildFeatureSection(context),
            const SizedBox(height: AppDesign.spaceLG),
            _buildSafetySection(context),
            const SizedBox(height: AppDesign.spaceLG),
            _buildSupportLegalSection(context),
            const SizedBox(height: AppDesign.spaceLG),
            _buildFooter(context, packageInfo),
          ],
        );
      },
    );
  }

  Widget _buildBrandCard(BuildContext context, PackageInfo? packageInfo) {
    final th = ThemeHelper.of(context);
    final version = packageInfo?.version ?? 'Loading version';
    final build = packageInfo?.buildNumber ?? '--';

    return ProfileSectionCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withValues(alpha: 0.16),
              AppColors.accentColor.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  padding: const EdgeInsets.all(AppDesign.spaceMD),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDesign.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.primaryColor,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SafeDriver',
                        style: AppTextStyles.headline5.copyWith(
                          color: th.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppDesign.spaceXS),
                      Text(
                        'Passenger safety and bus navigation companion',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: th.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Wrap(
              spacing: AppDesign.spaceSM,
              runSpacing: AppDesign.spaceSM,
              children: [
                _buildMetaPill(
                  context,
                  icon: Icons.verified_rounded,
                  label: 'Version $version',
                ),
                _buildMetaPill(
                  context,
                  icon: Icons.layers_rounded,
                  label: 'Build $build',
                ),
                _buildMetaPill(
                  context,
                  icon: Icons.people_alt_outlined,
                  label: 'Passenger app',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.verified_user_rounded,
            title: 'About SafeDriver',
            subtitle: 'Built to make daily bus travel safer and easier.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            'SafeDriver helps passengers navigate bus journeys, use emergency tools quickly, manage trusted contacts, and share feedback that improves transport safety.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    final features = [
      const _FeatureData(
        title: 'Bus Navigation',
        description:
            'Search destinations and follow bus-focused route guidance.',
        icon: Icons.map_rounded,
        color: AppColors.primaryColor,
      ),
      const _FeatureData(
        title: 'SOS Contacts',
        description: 'Reach trusted contacts quickly during urgent situations.',
        icon: Icons.sos_rounded,
        color: AppColors.dangerColor,
      ),
      const _FeatureData(
        title: 'Safety Hub',
        description:
            'Keep emergency actions and safety tools within easy reach.',
        icon: Icons.health_and_safety_rounded,
        color: AppColors.successColor,
      ),
      const _FeatureData(
        title: 'Feedback',
        description:
            'Report bus and journey experiences to improve service quality.',
        icon: Icons.rate_review_rounded,
        color: AppColors.warningColor,
      ),
    ];

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.grid_view_rounded,
            title: 'Core Features',
            subtitle: 'The main tools passengers use across the app.',
            color: AppColors.accentColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - AppDesign.spaceMD) / 2;

              return Wrap(
                spacing: AppDesign.spaceMD,
                runSpacing: AppDesign.spaceMD,
                children: features
                    .map(
                      (feature) => SizedBox(
                        width: itemWidth,
                        child: _FeatureHighlightCard(feature: feature),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSafetySection(BuildContext context) {
    final items = [
      const _InfoRowData(
        title: 'Emergency first',
        description:
            'SOS and emergency contact tools are designed to stay easy to reach.',
        icon: Icons.emergency_share_rounded,
        color: AppColors.dangerColor,
      ),
      const _InfoRowData(
        title: 'Permission based',
        description:
            'Location-powered features work only when device permission is granted.',
        icon: Icons.location_on_rounded,
        color: AppColors.successColor,
      ),
      const _InfoRowData(
        title: 'Passenger control',
        description:
            'Profile, notifications, contacts, and support preferences can be updated anytime.',
        icon: Icons.tune_rounded,
        color: AppColors.primaryColor,
      ),
    ];

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.shield_rounded,
            title: 'Safety & Privacy',
            subtitle: 'Core principles behind how the app behaves.',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ...items.map(_CompactInfoRow.new),
        ],
      ),
    );
  }

  Widget _buildSupportLegalSection(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.article_outlined,
            title: 'Support & Legal',
            subtitle: 'Reach the team or read the key app policies.',
            color: AppColors.infoColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ProfileActionTile(
            icon: Icons.email_outlined,
            title: 'Contact Support',
            subtitle: 'info@safedriver.com',
            color: AppColors.primaryColor,
            onTap: _sendSupportEmail,
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How passenger data is handled inside the app',
            color: AppColors.successColor,
            onTap: () => _showTextSheet(
              context,
              title: 'Privacy Policy',
              body:
                  'SafeDriver uses profile, contact, notification, feedback, and location data only to provide passenger safety, navigation, emergency, and support features. Location access is permission based and can be changed from device or app settings.',
            ),
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Passenger app usage guidelines',
            color: AppColors.warningColor,
            onTap: () => _showTextSheet(
              context,
              title: 'Terms of Service',
              body:
                  'Use SafeDriver responsibly and keep your emergency contact details accurate. Navigation and safety information can depend on device permissions, network availability, and third-party map providers.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, PackageInfo? packageInfo) {
    final th = ThemeHelper.of(context);
    final versionText = packageInfo == null
        ? 'Version information is loading'
        : 'Version ${packageInfo.version} build ${packageInfo.buildNumber}';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: AppDesign.spaceXS,
      ),
      child: Column(
        children: [
          Text(
            'SafeDriver Passenger App',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            versionText,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textSecondary,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            'Copyright 2026 SafeDriver. All rights reserved.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaPill(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceMD,
        vertical: AppDesign.spaceSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: AppDesign.spaceXS),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSupportEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'info@safedriver.com',
      queryParameters: {
        'subject': 'SafeDriver App Support',
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showTextSheet(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesign.radiusXL),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppDesign.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headline5.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              body,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
                height: 1.55,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
          ],
        ),
      ),
    );
  }
}

class _FeatureHighlightCard extends StatelessWidget {
  const _FeatureHighlightCard({required this.feature});

  final _FeatureData feature;

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 156),
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: feature.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: feature.color.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: feature.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: Icon(feature.icon, color: feature.color, size: 22),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            feature.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            feature.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactInfoRow extends StatelessWidget {
  const _CompactInfoRow(this.data);

  final _InfoRowData data;

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: data.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: data.color.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: Icon(data.icon, color: data.color, size: 18),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: th.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: th.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _InfoRowData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _InfoRowData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
