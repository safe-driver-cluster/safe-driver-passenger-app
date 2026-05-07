import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/greeting_util.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/passenger_provider.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/common/bottom_navigation_widget.dart';
import '../../widgets/dashboard/active_journey_widget.dart';
import '../../widgets/dashboard/recent_activity_widget.dart';
import '../../widgets/notifications/notifications_bottom_sheet.dart';
import '../buses/bus_list_page.dart';
import '../drivers/driver_list_page.dart';
import '../maps/map_page.dart';
import '../profile/user_profile_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final int? initialTab;

  const DashboardPage({super.key, this.initialTab});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set initial tab if provided
    if (widget.initialTab != null) {
      _selectedIndex = widget.initialTab!;
    }

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
      const BusListPage(), // Search tab shows bus list
      const MapPage(),
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
                  Navigator.pushNamed(context, '/qr-scanner');
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
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardHome extends ConsumerWidget {
  final Function(int)? onNavigateToTab;

  const DashboardHome({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              th.background,
            ],
            stops: const [0.0, 0.3, 0.7],
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
            backgroundColor: th.cardBackground,
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
                          context: context,
                          title: l10n.activeJourney,
                          icon: Icons.directions_bus_rounded,
                          gradient: AppColors.primaryGradient,
                          child: const ActiveJourneyWidget(),
                        ),
                        const SizedBox(height: AppDesign.spaceLG),

                        // Recent Activity Section
                        _buildProfessionalSection(
                          context: context,
                          title: l10n.recentActivity,
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
    return Consumer(
      builder: (context, ref, child) {
        final passengerAsyncValue = ref.watch(currentPassengerProvider);
        final l10n = AppLocalizations.of(context);

        return passengerAsyncValue.when(
          data: (passenger) {
            final firstName = passenger?.firstName ?? '';
            final greeting = GreetingUtil.getFullGreeting(firstName, l10n);
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
                              greeting,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.appTagline,
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
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const NotificationsBottomSheet(),
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
          },
          loading: () {
            return Container(
              padding: const EdgeInsets.fromLTRB(
                AppDesign.spaceLG,
                AppDesign.spaceSM,
                AppDesign.spaceLG,
                AppDesign.spaceLG,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${GreetingUtil.getTimeBasedGreeting(l10n)} ${GreetingUtil.getGreetingEmoji()}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.appTagline,
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
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const NotificationsBottomSheet(),
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
          },
          error: (error, stack) {
            return Container(
              padding: const EdgeInsets.fromLTRB(
                AppDesign.spaceLG,
                AppDesign.spaceSM,
                AppDesign.spaceLG,
                AppDesign.spaceLG,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${GreetingUtil.getTimeBasedGreeting(l10n)} ${GreetingUtil.getGreetingEmoji()}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.appTagline,
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
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const NotificationsBottomSheet(),
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
          },
        );
      },
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
          color: th.border,
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
                    title: l10n.busInformation,
                    subtitle: l10n.busStatus,
                    icon: Icons.directions_bus_rounded,
                    gradient: AppColors.primaryGradient,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusListPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.driverInformation,
                    subtitle: l10n.details,
                    icon: Icons.person_rounded,
                    gradient: AppColors.accentGradient,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverListPage(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Row(
              children: [
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.emergency,
                    subtitle: l10n.callForHelp,
                    icon: Icons.warning_rounded,
                    gradient: AppColors.dangerGradient,
                    onTap: () => Navigator.pushNamed(context, '/emergency'),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildProfessionalActionCard(
                    title: l10n.feedback,
                    subtitle: l10n.share,
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
    required BuildContext context,
  }) {
    final th = ThemeHelper.of(context);
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
}
