import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/passenger_model.dart';
import '../../../data/services/passenger_service.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/professional_widgets.dart';
import 'about_page.dart';
import 'edit_profile_page.dart';
import 'feedback_history_page.dart';
import 'help_support_page.dart';
import 'notifications_page.dart';
import 'passenger_profile_screen.dart';
import 'settings_page.dart';
import 'trip_history_page.dart';

// Passenger profile provider for Firebase data
final passengerProfileProvider =
    FutureProvider.autoDispose<PassengerModel?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final passengerService = PassengerService.instance;
  return await passengerService.getPassengerProfile(user.uid);
});

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passengerProfileAsync = ref.watch(passengerProfileProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor,
              AppColors.primaryColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(passengerProfileProvider);
            },
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Professional Header with user data
                  passengerProfileAsync.when(
                    data: (userProfile) => _buildProfessionalHeader(
                      context,
                      userProfile,
                      authState.user,
                    ),
                    loading: () => _buildLoadingHeader(),
                    error: (error, _) => _buildErrorHeader(context, error),
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
                        passengerProfileAsync.when(
                          data: (userProfile) =>
                              _buildProfessionalStats(userProfile),
                          loading: () => _buildLoadingStats(),
                          error: (_, __) => const SizedBox(),
                        ),
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
    final displayName =
        userProfile?.fullName ?? firebaseUser?.displayName ?? 'User';
    final email = userProfile?.email ?? firebaseUser?.email ?? 'No email';
    final phoneNumber = userProfile?.phoneNumber ?? 'Not provided';

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
                  backgroundImage: userProfile?.profileImageUrl != null
                      ? NetworkImage(userProfile!.profileImageUrl!)
                      : null,
                  child: userProfile?.profileImageUrl == null
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
                      child: const Text(
                        'Verified Member',
                        style: TextStyle(
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
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: AppDesign.spaceLG),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Failed to load profile data',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalQuickActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
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
                  'Quick Actions',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textPrimary,
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
                    title: 'Edit Profile',
                    subtitle: 'Update info',
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
                    title: 'Trip History',
                    subtitle: 'View trips',
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
                    title: 'Feedback History',
                    subtitle: 'Your feedback',
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
                    title: 'Support',
                    subtitle: 'Get help',
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
    // TODO: Add these fields to UserModel in future iterations
    // For now using placeholder data - should be fetched from travel history
    const totalTrips = 47; // Should be calculated from user's travel records
    const totalDistance = 1234.5; // Should be sum of all trip distances
    const safetyScore = 98.0; // Should be calculated from safety incidents

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowMD,
        border: Border.all(
          color: AppColors.greyLight,
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
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDesign.radiusXL),
                topRight: Radius.circular(AppDesign.radiusXL),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Text(
                  'Travel Statistics',
                  style: AppTextStyles.headline6.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Stats content
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Trips',
                    '$totalTrips',
                    Icons.directions_bus_rounded,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildStatItem(
                    'Distance',
                    '${totalDistance.toStringAsFixed(1)} km',
                    Icons.route_rounded,
                    AppColors.accentColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildStatItem(
                    'Safety Score',
                    '${safetyScore.toStringAsFixed(0)}%',
                    Icons.security_rounded,
                    AppColors.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Icon(
            icon,
            color: color,
            size: AppDesign.iconMD,
          ),
        ),
        const SizedBox(height: AppDesign.spaceSM),
        Text(
          value,
          style: AppTextStyles.headline6.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingStats() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowMD,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildProfessionalMenuSection(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        boxShadow: AppDesign.shadowMD,
        border: Border.all(
          color: AppColors.greyLight,
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
                  'Account & Settings',
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
    final accountMenuItems = [
      MenuItemData('Edit Profile', Icons.person_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      }),
      MenuItemData('Passenger Details', Icons.account_circle_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PassengerProfileScreen()),
        );
      }),
      MenuItemData('Trip History', Icons.history_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TripHistoryPage()),
        );
      }),
    ];

    final settingsMenuItems = [
      MenuItemData('Notifications', Icons.notifications_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsPage()),
        );
      }),
      MenuItemData('App Settings', Icons.settings_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      }),
      MenuItemData('Help & Support', Icons.help_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpSupportPage()),
        );
      }),
      MenuItemData('About App', Icons.info_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
      }),
    ];

    final actionMenuItems = [
      MenuItemData('Sign Out', Icons.logout_rounded, () {
        _showSignOutDialog(context, ref);
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
          color:
              item.isDestructive ? AppColors.errorColor : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textHint,
        size: AppDesign.iconSM,
      ),
      onTap: item.onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).signOut),
        content: Text(AppLocalizations.of(context).areYouSureSignOut),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ProfessionalButton(
            text: 'Sign Out',
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
