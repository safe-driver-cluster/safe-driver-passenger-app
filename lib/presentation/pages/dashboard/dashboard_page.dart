import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/dashboard/active_journey_widget.dart';
import '../../widgets/dashboard/modern_safety_overview_widget.dart';
import '../../widgets/dashboard/quick_actions_widget.dart';
import '../../widgets/dashboard/recent_activity_widget.dart';
import '../bus/bus_search_page.dart';
import '../feedback/feedback_page.dart';
import '../profile/notifications_page.dart';
import '../profile/user_profile_page.dart';
import '../qr/qr_scanner_page.dart';
import '../safety/emergency_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardControllerProvider.notifier).loadDashboardData();
    });
  }

  void _onNavigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardHome(
        onNavigateToTab: _onNavigateToTab,
      ),
      const BusSearchPage(),
      const QrScannerPage(),
      const UserProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      floatingActionButton: _selectedIndex == 0
          ? Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2; // Navigate to QR scanner
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: AppDesign.iconLG,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDesign.space2XL),
            topRight: Radius.circular(AppDesign.space2XL),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDesign.space2XL),
            topRight: Radius.circular(AppDesign.space2XL),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            showUnselectedLabels: true,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Icon(
                    _selectedIndex == 0
                        ? Icons.dashboard
                        : Icons.dashboard_outlined,
                    size: AppDesign.iconMD,
                  ),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Icon(
                    _selectedIndex == 1 ? Icons.search : Icons.search_outlined,
                    size: AppDesign.iconMD,
                  ),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Icon(
                    _selectedIndex == 2
                        ? Icons.qr_code_scanner
                        : Icons.qr_code_scanner_outlined,
                    size: AppDesign.iconMD,
                  ),
                ),
                label: 'QR Scanner',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 3
                        ? AppColors.primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: Icon(
                    _selectedIndex == 3 ? Icons.person : Icons.person_outlined,
                    size: AppDesign.iconMD,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHome extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const DashboardHome({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerLeft,
            colors: [
              AppColors.backgroundColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.6],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(dashboardControllerProvider.notifier)
                  .loadDashboardData();
            },
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Professional Header
                  _buildModernHeader(context, dashboardState),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDesign.spaceXL),

                        // Safety Overview
                        _buildProfessionalSection(
                          title: 'Safety Overview',
                          icon: Icons.security_rounded,
                          iconColor: AppColors.successColor,
                          child: const ModernSafetyOverviewWidget(),
                        ),
                        const SizedBox(height: AppDesign.space2XL),

                        // Quick Actions Section
                        _buildProfessionalSection(
                          title: 'Quick Actions',
                          icon: Icons.flash_on_rounded,
                          iconColor: AppColors.accentColor,
                          child: QuickActionsWidget(
                            onQrScan: () => onNavigateToTab?.call(2),
                            onSearch: () => onNavigateToTab?.call(1),
                            onEmergency: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmergencyPage(),
                                ),
                              );
                            },
                            onFeedback: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedbackPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppDesign.space2XL),

                        // Active Journey Section
                        _buildProfessionalSection(
                          title: 'Active Journey',
                          icon: Icons.directions_bus_rounded,
                          iconColor: AppColors.primaryColor,
                          child: const ActiveJourneyWidget(),
                        ),
                        const SizedBox(height: AppDesign.space2XL),

                        // Recent Activity Section
                        _buildProfessionalSection(
                          title: 'Recent Activity',
                          icon: Icons.history_rounded,
                          iconColor: AppColors.tealAccent,
                          child: const RecentActivityWidget(),
                        ),
                        const SizedBox(height: AppDesign.space3XL),
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

  Widget _buildModernHeader(BuildContext context, dynamic dashboardState) {
    final greeting = _getGreeting();
    final time = _getTimeOfDay();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        60,
        AppDesign.spaceLG,
        AppDesign.space2XL,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.space2XL),
          bottomRight: Radius.circular(AppDesign.space2XL),
        ),
        boxShadow: AppDesign.shadowLG,
      ),
      child: Column(
        children: [
          // Top Row - Greeting and Notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good $greeting!',
                      style: AppTextStyles.headline3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'Ready for a safe journey?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceMD,
                        vertical: AppDesign.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: AppDesign.spaceXS),
                          Text(
                            time,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        size: AppDesign.iconLG,
                        color: Colors.white,
                      ),
                      if (dashboardState.activeIncidents > 0)
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.dangerColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDesign.space2XL),

          // Quick Stats Row
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.directions_bus_rounded,
                    label: 'Trips',
                    value: '24',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.route_rounded,
                    label: 'Distance',
                    value: '847km',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.security_rounded,
                    label: 'Safety',
                    value: '98%',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconColor.withOpacity(0.15),
                    iconColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: iconColor.withOpacity(0.1),
                ),
              ),
              child: Icon(
                icon,
                size: AppDesign.iconSM,
                color: iconColor,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Text(
              title,
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: AppDesign.iconSM,
            ),
          ],
        ),
        const SizedBox(height: AppDesign.spaceLG),
        // Section Content
        child,
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  String _getTimeOfDay() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: AppDesign.iconMD,
        ),
        const SizedBox(height: AppDesign.spaceXS),
        Text(
          value,
          style: AppTextStyles.headline6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
