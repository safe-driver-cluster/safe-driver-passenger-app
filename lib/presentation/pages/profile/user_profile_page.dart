import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:safedriver_passenger_app/presentation/pages/feedback/feedback_history_page.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/passenger_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/passenger_provider.dart';
import '../../widgets/common/professional_widgets.dart';
import '../../widgets/dashboard/reward_points_widget.dart';
import 'about_page.dart';
import 'edit_profile_page.dart';
import 'help_support_page.dart';
import 'received_notifications_page.dart';
import 'settings_page.dart';
import 'trip_history_page.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

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
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // Force refresh passenger profile data from Firebase
              await ref
                  .read(authStateProvider.notifier)
                  .refreshPassengerProfile();

              // Also refresh the passenger provider stream
              ref.invalidate(currentPassengerProvider);

              // Extra wait to ensure all data is loaded
              await Future.delayed(const Duration(milliseconds: 800));
            },
            color: AppColors.primaryColor,
            backgroundColor: th.cardBackground,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show loading header during data fetch, or professional header with data
                  authState.isLoading
                      ? _buildLoadingHeader()
                      : _buildProfessionalHeader(
                          context,
                          authState.passengerProfile,
                          authState.user,
                        ),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesign.spaceMD,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDesign.spaceMD),

                        // Quick Actions Grid - Professional Design
                        _buildProfessionalQuickActions(context),
                        const SizedBox(height: AppDesign.spaceLG),

                        // User Stats Section
                        authState.isLoading
                            ? _buildLoadingStats()
                            : _buildProfessionalStats(
                                authState.passengerProfile),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Account & Settings Section
                        _buildProfessionalMenuSection(context, ref),
                        const SizedBox(height: AppDesign.spaceLG),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader(
    BuildContext context,
    PassengerModel? userProfile,
    User? firebaseUser,
  ) {
    if (userProfile == null) {
      return _buildLoadingHeader();
    }

    final displayName = userProfile.fullName.isNotEmpty
        ? userProfile.fullName
        : '${userProfile.firstName} ${userProfile.lastName}'.trim().isNotEmpty
            ? '${userProfile.firstName} ${userProfile.lastName}'.trim()
            : 'User';
    final l10n = AppLocalizations.of(context);
    final email =
        userProfile.email.isNotEmpty ? userProfile.email : l10n.noEmail;
    final phoneNumber = userProfile.phoneNumber.isNotEmpty
        ? userProfile.phoneNumber
        : l10n.notProvided;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Column(
        children: [
          // Profile Header with user data
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppColors.glassGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: userProfile.profileImageUrl != null &&
                          userProfile.profileImageUrl!.isNotEmpty
                      ? NetworkImage(userProfile.profileImageUrl!)
                      : null,
                  child: userProfile.profileImageUrl == null ||
                          userProfile.profileImageUrl!.isEmpty
                      ? Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.accentGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 45,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (phoneNumber != 'Not provided') ...[
                      const SizedBox(height: 2),
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.successGradient,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.successColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.verifiedMember,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalQuickActions(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowLG,
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with gradient
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                  ),
                  child: const Icon(
                    Icons.flash_on_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Text(
                  l10n.quickActions,
                  style: AppTextStyles.headline6.copyWith(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            // Action buttons grid with same sizes
            Row(
              children: [
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.editProfile,
                    subtitle: l10n.updateInfo,
                    icon: Icons.edit_rounded,
                    gradient: AppColors.primaryGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.tripHistory,
                    subtitle: l10n.viewTrips,
                    icon: Icons.history_rounded,
                    gradient: AppColors.accentGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TripHistoryPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Row(
              children: [
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.feedbackHistory,
                    subtitle: l10n.yourFeedback,
                    icon: Icons.feedback_rounded,
                    gradient: AppColors.successGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackHistoryPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.support,
                    subtitle: l10n.getHelp,
                    icon: Icons.help_rounded,
                    gradient: AppColors.warningGradient,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 100, // Fixed height for same size
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          child: Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalStats(PassengerModel? userProfile) {
    // Get reward points from passenger model, default to 0
    final rewardPoints = userProfile?.stats.pointsEarned ?? 0;
    // Goal can be adjusted - currently set to 100 points
    const goalPoints = 100;

    return RewardPointsWidget(
      currentPoints: rewardPoints,
      goalPoints: goalPoints,
      userProfile: userProfile,
    );
  }

  Widget _buildLoadingStats() {
    return Builder(builder: (context) {
      final th = ThemeHelper.of(context);
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: th.cardBackground,
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          boxShadow: AppDesign.shadowMD,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    });
  }

  Widget _buildProfessionalMenuSection(BuildContext context, WidgetRef ref) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowMD,
        border: Border.all(
          color: th.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Professional section header
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: const BoxDecoration(
              gradient: AppColors.dangerGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDesign.radiusXL),
                topRight: Radius.circular(AppDesign.radiusXL),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Text(
                  l10n.accountAndSettings,
                  style: AppTextStyles.headline6.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Menu content
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: _buildMenuItems(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final accountMenuItems = [
      MenuItemData(l10n.editProfile, Icons.person_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      }),
      MenuItemData(l10n.tripHistory, Icons.history_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TripHistoryPage()),
        );
      }),
    ];

    final settingsMenuItems = [
      MenuItemData(l10n.notifications, Icons.notifications_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReceivedNotificationsPage(),
          ),
        );
      }),
      MenuItemData(l10n.appSettings, Icons.settings_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      }),
      MenuItemData(l10n.emergencyHelp, Icons.help_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpSupportPage()),
        );
      }),
      MenuItemData(l10n.aboutApp, Icons.info_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
      }),
    ];

    final actionMenuItems = [
      MenuItemData(l10n.signOut, Icons.logout_rounded, () {
        showSignOutDialog(context, ref);
      }, isDestructive: true),
    ];

    // Combine all menu items
    final allItems = [
      ...accountMenuItems,
      ...settingsMenuItems,
      ...actionMenuItems
    ];

    return allItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Column(
        children: [
          _buildMenuItem(item),
          if (index < allItems.length - 1)
            const Divider(
              height: 1,
              color: AppColors.greyLight,
            ),
        ],
      );
    }).toList();
  }

  Widget _buildMenuItem(MenuItemData item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: (item.isDestructive
                  ? AppColors.errorColor
                  : AppColors.primaryColor)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        child: Icon(
          item.icon,
          color: item.isDestructive
              ? AppColors.errorColor
              : AppColors.primaryColor,
          size: AppDesign.iconSM,
        ),
      ),
      title: Text(
        item.title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: item.isDestructive ? AppColors.errorColor : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: AppDesign.iconSM,
      ),
      onTap: item.onTap,
    );
  }

  void showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).signOut),
        content: Text(AppLocalizations.of(context).areYouSureSignOut),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ProfessionalButton(
            text: AppLocalizations.of(context).signOut,
            onPressed: () async {
              Navigator.pop(context);

              // Sign out using the auth provider
              final authNotifier = ref.read(authStateProvider.notifier);
              await authNotifier.signOut();

              // Navigate to login page
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            backgroundColor: AppColors.errorColor,
            height: 36,
          ),
        ],
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  MenuItemData(
    this.title,
    this.icon,
    this.onTap, {
    this.isDestructive = false,
  });
}
