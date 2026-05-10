import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/core/utils/theme_helper.dart';
import 'package:safedriver_passenger_app/data/models/faq_model.dart';
import 'package:safedriver_passenger_app/data/services/support_data_service.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/profile_page_components.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportCategoryPage extends StatefulWidget {
  final String categoryName;

  const SupportCategoryPage({
    super.key,
    required this.categoryName,
  });

  @override
  State<SupportCategoryPage> createState() => _SupportCategoryPageState();
}

class _SupportCategoryPageState extends State<SupportCategoryPage> {
  final SupportDataService _supportService = SupportDataService();
  final TextEditingController _searchController = TextEditingController();
  late List<SupportIssue> _issues;
  late List<SupportIssue> _filteredIssues;

  @override
  void initState() {
    super.initState();
    _issues = _supportService.getSupportIssuesByCategory(widget.categoryName);
    _filteredIssues = _issues;
    _searchController.addListener(_filterIssues);
  }

  void _filterIssues() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIssues = _issues;
      } else {
        _filteredIssues = _issues
            .where(
              (issue) =>
                  issue.title.toLowerCase().contains(query) ||
                  issue.description.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'SafeDriver App Support - ${widget.categoryName}',
      },
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactInfo = _supportService.getContactInfo();
    final accentColor = _accentColorForCategory(widget.categoryName);

    return ProfilePageScaffold(
      title: widget.categoryName,
      accentColor: accentColor,
      children: [
        _buildOverviewCard(accentColor),
        const SizedBox(height: AppDesign.spaceLG),
        _buildSearchCard(),
        const SizedBox(height: AppDesign.spaceLG),
        _buildIssueSection(accentColor),
        const SizedBox(height: AppDesign.spaceLG),
        _buildContactSection(contactInfo, accentColor),
      ],
    );
  }

  Widget _buildOverviewCard(Color accentColor) {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withValues(alpha: 0.18),
              AppColors.primaryColor.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: Icon(
                _categoryIconForName(widget.categoryName),
                color: accentColor,
                size: AppDesign.iconMD,
              ),
            ),
            const SizedBox(width: AppDesign.spaceLG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find the right fix faster',
                    style: AppTextStyles.headline6.copyWith(
                      color: th.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    'Browse step-by-step help for ${widget.categoryName.toLowerCase()} and contact support if you still need a hand.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: th.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  Wrap(
                    spacing: AppDesign.spaceSM,
                    runSpacing: AppDesign.spaceSM,
                    children: [
                      _InfoChip(
                        icon: Icons.article_outlined,
                        label: '${_issues.length} issues',
                        color: accentColor,
                      ),
                      const _InfoChip(
                        icon: Icons.manage_search_rounded,
                        label: 'Search supported',
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.search_rounded,
            title: 'Search Issues',
            subtitle: 'Filter solutions by title or description.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          TextField(
            controller: _searchController,
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search issues...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: th.textHint,
              ),
              filled: true,
              fillColor: th.subtleBackground,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.primaryColor,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: _searchController.clear,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceLG,
                vertical: AppDesign.spaceMD,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: BorderSide(color: th.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueSection(Color accentColor) {
    if (_filteredIssues.isEmpty) {
      return ProfileSectionCard(
        child: Column(
          children: [
            const ProfileSectionHeader(
              icon: Icons.search_off_rounded,
              title: 'No Matches Found',
              subtitle: 'Try a broader keyword or clear your search.',
              color: AppColors.warningColor,
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: AppColors.warningColor.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                'No issues found for "${_searchController.text}". Clear the search to see all available help topics.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ThemeHelper.of(context).textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionHeader(
            icon: Icons.topic_outlined,
            title: 'Available Help Topics',
            subtitle:
                '${_filteredIssues.length} issue${_filteredIssues.length == 1 ? '' : 's'} currently visible.',
            color: accentColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ...List.generate(_filteredIssues.length, (index) {
            final spacing = index == _filteredIssues.length - 1
                ? const SizedBox.shrink()
                : const SizedBox(height: AppDesign.spaceMD);

            return Column(
              children: [
                _buildIssueCard(_filteredIssues[index], accentColor),
                spacing,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContactSection(
      Map<String, String> contactInfo, Color accentColor) {
    final th = ThemeHelper.of(context);

    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.support_agent_rounded,
            title: 'Still Need Help?',
            subtitle: 'Reach the SafeDriver team directly for extra support.',
            color: AppColors.successColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.08),
                  AppColors.successColor.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              border: Border.all(color: th.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ContactActionCard(
                        icon: Icons.call_rounded,
                        title: 'Call Support',
                        detail: contactInfo['phone'] ?? '',
                        color: AppColors.successColor,
                        onTap: () => _makeCall(contactInfo['phone'] ?? ''),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    Expanded(
                      child: _ContactActionCard(
                        icon: Icons.email_outlined,
                        title: 'Send Email',
                        detail: contactInfo['email'] ?? '',
                        color: AppColors.primaryColor,
                        onTap: () => _sendEmail(contactInfo['email'] ?? ''),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard(SupportIssue issue, Color accentColor) {
    final th = ThemeHelper.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: th.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  color: accentColor,
                  size: AppDesign.iconSM,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      style: AppTextStyles.headline6.copyWith(
                        color: th.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      issue.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: th.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Text(
            'Solutions',
            style: AppTextStyles.labelLarge.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          ...List.generate(issue.solutions.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    index == issue.solutions.length - 1 ? 0 : AppDesign.spaceMD,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        issue.solutions[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: th.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (issue.contactEmail != null || issue.contactPhone != null) ...[
            const SizedBox(height: AppDesign.spaceLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: AppColors.warningColor.withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'If the problem persists, contact:',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: th.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (issue.contactEmail != null) ...[
                    const SizedBox(height: AppDesign.spaceSM),
                    GestureDetector(
                      onTap: () => _sendEmail(issue.contactEmail!),
                      child: Text(
                        issue.contactEmail!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  if (issue.contactPhone != null) ...[
                    const SizedBox(height: AppDesign.spaceXS),
                    GestureDetector(
                      onTap: () => _makeCall(issue.contactPhone!),
                      child: Text(
                        issue.contactPhone!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _accentColorForCategory(String categoryName) {
    switch (categoryName) {
      case 'App Issues':
        return AppColors.accentColor;
      case 'Bus Services':
        return AppColors.warningColor;
      case 'Account & Security':
        return AppColors.successColor;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _categoryIconForName(String categoryName) {
    switch (categoryName) {
      case 'App Issues':
        return Icons.bug_report_outlined;
      case 'Bus Services':
        return Icons.directions_bus_outlined;
      case 'Account & Security':
        return Icons.lock_person_outlined;
      default:
        return Icons.support_agent_rounded;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceMD,
        vertical: AppDesign.spaceSM,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppDesign.spaceXS),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;
  final Color color;
  final VoidCallback onTap;

  const _ContactActionCard({
    required this.icon,
    required this.title,
    required this.detail,
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
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        child: Ink(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          decoration: BoxDecoration(
            color: th.cardBackground,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            border: Border.all(color: color.withValues(alpha: 0.16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                ),
                child: Icon(icon, color: color, size: AppDesign.iconSM),
              ),
              const SizedBox(height: AppDesign.spaceMD),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: th.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDesign.spaceXS),
              Text(
                detail,
                style: AppTextStyles.bodySmall.copyWith(
                  color: th.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
