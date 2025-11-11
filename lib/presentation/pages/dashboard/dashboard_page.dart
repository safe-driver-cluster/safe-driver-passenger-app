import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/dashboard/active_journey_widget.dart';
import '../../widgets/dashboard/recent_activity_widget.dart';
import '../bus/bus_search_page.dart';
import '../profile/notifications_page.dart';
import '../profile/user_profile_page.dart';
import '../qr/qr_scanner_page.dart';

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
                heroTag: "dashboard_qr_fab", // Unique hero tag
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
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.4],
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
                  // Redesigned Header
                  _buildRedesignedHeader(context, dashboardState),

                  // Main Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDesign.spaceXL),

                        // Quick Actions Grid - Main Feature
                        _buildQuickActionsGrid(context),
                        const SizedBox(height: AppDesign.space2XL),

                        // Active Journey Section
                        _buildCleanSection(
                          title: 'Current Journey',
                          child: const ActiveJourneyWidget(),
                        ),
                        const SizedBox(height: AppDesign.space2XL),

                        // Recent Activity Section
                        _buildCleanSection(
                          title: 'Recent Activity',
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

  Widget _buildRedesignedHeader(BuildContext context, dynamic dashboardState) {
    final greeting = _getGreeting();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
        AppDesign.space2XL,
      ),
      child: Column(
        children: [
          // Top Row - Simple greeting and notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good $greeting',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Where would you like to go?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                ),
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceLG),
        Container(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Main action buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      title: 'Scan QR Code',
                      subtitle: 'Board your bus',
                      icon: Icons.qr_code_scanner_rounded,
                      color: AppColors.primaryColor,
                      onTap: () => onNavigateToTab?.call(2),
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceLG),
                  Expanded(
                    child: _buildActionButton(
                      title: 'Find Routes',
                      subtitle: 'Search buses',
                      icon: Icons.directions_bus_rounded,
                      color: AppColors.tealAccent,
                      onTap: () => onNavigateToTab?.call(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDesign.spaceLG),
              // Secondary actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      title: 'Emergency',
                      subtitle: 'Get help now',
                      icon: Icons.warning_rounded,
                      color: AppColors.errorColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/emergency');
                      },
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceLG),
                  Expanded(
                    child: _buildActionButton(
                      title: 'Feedback',
                      subtitle: 'Share experience',
                      icon: Icons.feedback_rounded,
                      color: AppColors.successColor,
                      onTap: () {
                        Navigator.pushNamed(context, '/feedback-system');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceLG),
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
