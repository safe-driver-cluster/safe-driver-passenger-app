import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/dashboard/active_journey_widget.dart';
import '../../widgets/dashboard/recent_activity_widget.dart';
import '../bus/bus_search_page.dart';
import '../maps/maps_page.dart';
import '../profile/notifications_page.dart';
import '../profile/user_profile_page.dart';

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
      const MapsPage(),
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
                    _selectedIndex == 2 ? Icons.map : Icons.map_outlined,
                    size: AppDesign.iconMD,
                  ),
                ),
                label: 'Maps',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
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
                        horizontal: AppDesign.spaceMD),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDesign.spaceMD),

                        // Quick Actions Grid - Main Feature
                        _buildProfessionalQuickActions(context),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Active Journey Section
                        _buildProfessionalSection(
                          title: 'Current Journey',
                          icon: Icons.directions_bus_rounded,
                          gradient: AppColors.primaryGradient,
                          child: const ActiveJourneyWidget(),
                        ),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Recent Activity Section
                        _buildProfessionalSection(
                          title: 'Recent Activity',
                          icon: Icons.history_rounded,
                          gradient: AppColors.accentGradient,
                          child: const RecentActivityWidget(),
                        ),
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

  Widget _buildRedesignedHeader(BuildContext context, dynamic dashboardState) {
    final greeting = _getGreeting();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceLG,
      ),
      child: Column(
        children: [
          // Top Row - Greeting and notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good $greeting',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ready for your journey?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
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
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_rounded,
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
                    gradient: AppColors.primaryGradient,
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
                    title: 'Scan QR',
                    subtitle: 'Board bus',
                    icon: Icons.qr_code_scanner_rounded,
                    gradient: AppColors.primaryGradient,
                    onTap: () => onNavigateToTab?.call(2),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: 'Find Routes',
                    subtitle: 'Search',
                    icon: Icons.directions_bus_rounded,
                    gradient: AppColors.accentGradient,
                    onTap: () => onNavigateToTab?.call(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Row(
              children: [
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: 'Emergency',
                    subtitle: 'Get help',
                    icon: Icons.warning_rounded,
                    gradient: AppColors.dangerGradient,
                    onTap: () => Navigator.pushNamed(context, '/emergency'),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: 'Feedback',
                    subtitle: 'Share',
                    icon: Icons.feedback_rounded,
                    gradient: AppColors.successGradient,
                    onTap: () =>
                        Navigator.pushNamed(context, '/feedback-system'),
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

  Widget _buildProfessionalSection({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required Widget child,
  }) {
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
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDesign.radiusXL),
                topRight: Radius.circular(AppDesign.radiusXL),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Text(
                  title,
                  style: AppTextStyles.headline6.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          // Section content
          child,
        ],
      ),
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
}
