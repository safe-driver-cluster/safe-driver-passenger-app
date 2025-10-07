import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';
import 'about_page.dart';
import 'edit_profile_page.dart';
import 'help_support_page.dart';
import 'notifications_page.dart';
import 'payment_methods_page.dart';
import 'settings_page.dart';
import 'trip_history_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Professional Header
            _buildProfessionalHeader(),

            // Profile Content
            Padding(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Column(
                children: [
                  // User Stats Cards
                  _buildUserStatsSection(),

                  const SizedBox(height: AppDesign.space2XL),

                  // Quick Actions
                  _buildQuickActionsSection(),

                  const SizedBox(height: AppDesign.space2XL),

                  // Menu Items
                  _buildMenuSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        60,
        AppDesign.spaceLG,
        AppDesign.space2XL,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.space2XL),
          bottomRight: Radius.circular(AppDesign.space2XL),
        ),
      ),
      child: Column(
        children: [
          // Profile Picture and Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentColor.withOpacity(0.2),
                          AppColors.primaryColor.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: AppDesign.icon2XL,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: AppTextStyles.headline4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'john.doe@email.com',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    const StatusBadge(
                      text: 'Premium Member',
                      color: AppColors.successColor,
                      textColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceMD,
                        vertical: AppDesign.spaceXS,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle settings
                  },
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: AppDesign.iconMD,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Trips',
            '47',
            Icons.directions_bus_rounded,
            AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: AppDesign.spaceLG),
        Expanded(
          child: _buildStatCard(
            'Distance',
            '1,234 km',
            Icons.route_rounded,
            AppColors.accentColor,
          ),
        ),
        const SizedBox(width: AppDesign.spaceLG),
        Expanded(
          child: _buildStatCard(
            'Safety Score',
            '98%',
            Icons.security_rounded,
            AppColors.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return ProfessionalCard(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
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
              size: AppDesign.iconLG,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            value,
            style: AppTextStyles.headline6.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Edit Profile',
                  Icons.edit_rounded,
                  AppColors.primaryColor,
                  () {},
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildQuickActionButton(
                  'Trip History',
                  Icons.history_rounded,
                  AppColors.accentColor,
                  () {},
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildQuickActionButton(
                  'Payment',
                  Icons.payment_rounded,
                  AppColors.successColor,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: AppDesign.iconLG,
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account & Settings',
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ..._buildMenuItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuItems = [
      MenuItemData('Edit Profile', Icons.person_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
      }),
      MenuItemData('Trip History', Icons.history_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TripHistoryPage()),
        );
      }),
      MenuItemData('Payment Methods', Icons.payment_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
        );
      }),
      MenuItemData('Notifications', Icons.notifications_outlined, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsPage()),
        );
      }),
      MenuItemData('Settings', Icons.settings_outlined, () {
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
      MenuItemData('About', Icons.info_outline_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutPage()),
        );
      }),
      MenuItemData('Sign Out', Icons.logout_rounded, () {
        _showSignOutDialog(context);
      }, isDestructive: true),
    ];

    return menuItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return Column(
        children: [
          _buildMenuItem(item),
          if (index < menuItems.length - 1)
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ProfessionalButton(
            text: 'Sign Out',
            onPressed: () {
              Navigator.pop(context);
              // Handle sign out
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
