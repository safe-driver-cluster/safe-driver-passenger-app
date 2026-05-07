import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';

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
    final th = ThemeHelper.of(context);
    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor,
              AppColors.primaryColor,
              th.background,
            ],
            stops: const [0.0, 0.32, 0.72],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<PackageInfo>(
            future: _packageInfoFuture,
            builder: (context, snapshot) {
              final packageInfo = snapshot.data;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(context, packageInfo),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDesign.spaceLG,
                      0,
                      AppDesign.spaceLG,
                      AppDesign.spaceXL,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _buildMissionCard(),
                          const SizedBox(height: AppDesign.spaceLG),
                          _buildFeatureGrid(),
                          const SizedBox(height: AppDesign.spaceLG),
                          _buildSafetySection(),
                          const SizedBox(height: AppDesign.spaceLG),
                          _buildActionSection(context),
                          const SizedBox(height: AppDesign.spaceLG),
                          _buildFooter(packageInfo),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PackageInfo? packageInfo) {
    return Padding(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Expanded(
                child: Text(
                  'About App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceXL),
          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(AppDesign.spaceMD),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDesign.radius2XL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.14),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.primaryColor,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceLG),
                const Text(
                  'SafeDriver',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                Text(
                  'Passenger safety and bus navigation companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildVersionPill(packageInfo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionPill(PackageInfo? packageInfo) {
    final versionText = packageInfo == null
        ? 'Version loading'
        : 'Version ${packageInfo.version} (${packageInfo.buildNumber})';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceLG,
        vertical: AppDesign.spaceSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: Colors.white.withOpacity(0.26)),
      ),
      child: Text(
        versionText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.verified_user_rounded,
            title: 'Built For Safer Journeys',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            'SafeDriver helps passengers plan bus journeys, access emergency tools, manage trusted contacts, and share feedback that improves public transport safety.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final features = [
      const _FeatureData(
        'Bus Navigation',
        'Search destinations and view bus-focused route guidance.',
        Icons.map_rounded,
        AppColors.primaryColor,
      ),
      const _FeatureData(
        'SOS Contacts',
        'Alert trusted contacts quickly during emergencies.',
        Icons.sos_rounded,
        AppColors.dangerColor,
      ),
      const _FeatureData(
        'Safety Hub',
        'Access emergency actions and safety information.',
        Icons.health_and_safety_rounded,
        AppColors.successColor,
      ),
      const _FeatureData(
        'Feedback',
        'Report journey, driver, and bus service experiences.',
        Icons.rate_review_rounded,
        AppColors.warningColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - AppDesign.spaceMD) / 2;
        return Wrap(
          spacing: AppDesign.spaceMD,
          runSpacing: AppDesign.spaceMD,
          children: features
              .map(
                (feature) => SizedBox(
                  width: itemWidth,
                  child: _FeatureCard(feature: feature),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildSafetySection() {
    final items = [
      const _InfoRowData(
        'Emergency first',
        'SOS and emergency contact tools are designed to stay easy to reach.',
        Icons.emergency_share_rounded,
      ),
      const _InfoRowData(
        'Location aware',
        'Map and safety features use location only when permission is granted.',
        Icons.location_on_rounded,
      ),
      const _InfoRowData(
        'Passenger control',
        'You can update profile, preferences, notifications, and contacts anytime.',
        Icons.tune_rounded,
      ),
    ];

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.shield_rounded,
            title: 'Safety & Privacy',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceMD),
          ...items.map(_InfoRow.new),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.article_rounded,
            title: 'Support & Legal',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _ActionTile(
            icon: Icons.email_outlined,
            title: 'Contact Support',
            subtitle: 'support@safedriver.com',
            onTap: _sendSupportEmail,
          ),
          const Divider(height: 1, color: AppColors.greyLight),
          _ActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How passenger data is handled',
            onTap: () => _showTextSheet(
              context,
              title: 'Privacy Policy',
              body:
                  'SafeDriver uses profile, contact, notification, feedback, and location data only to provide passenger safety, navigation, emergency, and support features. Location access is permission based and can be changed from device or app settings.',
            ),
          ),
          const Divider(height: 1, color: AppColors.greyLight),
          _ActionTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Passenger app usage guidelines',
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

  Widget _buildFooter(PackageInfo? packageInfo) {
    final version = packageInfo == null
        ? ''
        : 'Version ${packageInfo.version} build ${packageInfo.buildNumber}';

    return Builder(builder: (context) {
      final th = ThemeHelper.of(context);
      return Column(
        children: [
          Text(
            'SafeDriver Passenger App',
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            version,
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
      );
    });
  }

  Future<void> _sendSupportEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@safedriver.com',
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowMD,
        border: Border.all(color: th.border),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesign.spaceSM),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppDesign.radiusMD),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppDesign.spaceMD),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.headline6.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 154),
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowSM,
        border: Border.all(color: th.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: feature.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: Icon(feature.icon, color: feature.color, size: 24),
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

class _InfoRow extends StatelessWidget {
  final _InfoRowData data;

  const _InfoRow(this.data);

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: AppColors.primaryColor, size: 20),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: th.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: th.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: th.textHint,
      ),
      onTap: onTap,
    );
  }
}

class _FeatureData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _FeatureData(
    this.title,
    this.description,
    this.icon,
    this.color,
  );
}

class _InfoRowData {
  final String title;
  final String description;
  final IconData icon;

  const _InfoRowData(
    this.title,
    this.description,
    this.icon,
  );
}
