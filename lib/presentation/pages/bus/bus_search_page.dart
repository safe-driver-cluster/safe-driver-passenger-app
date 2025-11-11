import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';
import 'bus_details_page.dart';
import 'live_tracking_page.dart';
import 'route_map_page.dart';

class BusSearchPage extends ConsumerStatefulWidget {
  const BusSearchPage({super.key});

  @override
  ConsumerState<BusSearchPage> createState() => _BusSearchPageState();
}

class _BusSearchPageState extends ConsumerState<BusSearchPage>
    with TickerProviderStateMixin {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _busNumberController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  int _selectedSearchType = 0; // 0: Route, 1: Bus Number, 2: Live Tracking

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _loadPopularRoutes();
    _animationController.forward();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _busNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadPopularRoutes() {
    setState(() {
      _searchResults = [
        {
          'id': 'bus_001',
          'busNumber': 'B001',
          'routeName': 'City Express',
          'route': 'City Center → Airport',
          'nextArrival': '5 min',
          'fare': 'Rs. 210',
          'capacity': 85,
          'occupancy': 68,
          'driverName': 'John Smith',
          'driverId': 'driver_001',
          'rating': 4.8,
          'isLive': true,
          'estimatedTime': '25 min',
        },
        {
          'id': 'bus_002',
          'busNumber': 'B023',
          'routeName': 'University Line',
          'route': 'University → Downtown → Mall',
          'nextArrival': '12 min',
          'fare': 'Rs. 170',
          'capacity': 65,
          'occupancy': 42,
          'driverName': 'Sarah Johnson',
          'driverId': 'driver_002',
          'rating': 4.6,
          'isLive': true,
          'estimatedTime': '35 min',
        },
        {
          'id': 'bus_003',
          'busNumber': 'B045',
          'routeName': 'Residential Route',
          'route': 'Mall → Residential Area',
          'nextArrival': '18 min',
          'fare': 'Rs. 150',
          'capacity': 45,
          'occupancy': 28,
          'driverName': 'Mike Wilson',
          'driverId': 'driver_003',
          'rating': 4.9,
          'isLive': false,
          'estimatedTime': '20 min',
        },
      ];
    });
  }

  void _performSearch() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSearching = true;
    });

    if (_selectedSearchType == 0) {
      _searchByRoute();
    } else if (_selectedSearchType == 1) {
      _searchByBusNumber();
    } else {
      _searchByLocation();
    }
  }

  void _searchByBusNumber() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _searchResults.where((bus) {
            return bus['busNumber']
                .toLowerCase()
                .contains(_busNumberController.text.toLowerCase());
          }).toList();
        });
      }
    });
  }

  void _searchByRoute() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _searchResults.where((bus) {
            return bus['route']
                    .toLowerCase()
                    .contains(_fromController.text.toLowerCase()) ||
                bus['route']
                    .toLowerCase()
                    .contains(_toController.text.toLowerCase());
          }).toList();
        });
      }
    });
  }

  void _searchByLocation() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          // For live tracking search, filter by bus number for now
          _searchResults = _searchResults.where((bus) {
            return bus['routeName']
                .toLowerCase()
                .contains(_busNumberController.text.toLowerCase());
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildModernHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSearchSection(),
                          _buildQuickActionsSection(),
                          _buildPopularRoutesSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAnimatedFAB(),
    );
  }

  Widget _buildModernHeader() {
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
                    const Text(
                      'Find Your Bus',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Search routes and track buses',
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
                        builder: (context) => const RouteMapPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.map_rounded,
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

  Widget _buildProfessionalAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Bus Search',
          style: AppTextStyles.headline6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              const Positioned(
                right: AppDesign.spaceLG,
                bottom: AppDesign.spaceLG,
                child: Icon(
                  Icons.search_rounded,
                  size: 64,
                  color: Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.map_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RouteMapPage(),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () => _showFilterOptions(),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Type Selector with Modern Design
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            child: Row(
              children: [
                _buildModernSearchTypeTab('Route', Icons.route_rounded, 0),
                _buildModernSearchTypeTab(
                    'Bus #', Icons.directions_bus_rounded, 1),
                _buildModernSearchTypeTab('Live', Icons.live_tv_rounded, 2),
              ],
            ),
          ),

          // Search Form with Modern Design
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                if (_selectedSearchType == 0) ...[
                  _buildGlassTextField(
                    controller: _fromController,
                    labelText: 'From',
                    hintText: 'Enter departure location',
                    icon: Icons.my_location_rounded,
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                  _buildGlassTextField(
                    controller: _toController,
                    labelText: 'To',
                    hintText: 'Enter destination',
                    icon: Icons.location_on_rounded,
                  ),
                ] else if (_selectedSearchType == 1) ...[
                  _buildGlassTextField(
                    controller: _busNumberController,
                    labelText: 'Bus Number',
                    hintText: 'Enter bus number (e.g., B001)',
                    icon: Icons.directions_bus_rounded,
                  ),
                ] else ...[
                  _buildGlassTextField(
                    controller: _busNumberController,
                    labelText: 'Live Tracking',
                    hintText: 'Enter bus number for live tracking',
                    icon: Icons.live_tv_rounded,
                  ),
                ],

                const SizedBox(height: AppDesign.spaceLG),

                // Modern Search Button
                _buildModernSearchButton(),
              ],
            ),
          ),

          // Search Results
          if (_isSearching || _searchResults.isNotEmpty) ...[
            const SizedBox(height: AppDesign.spaceLG),
            _buildSearchResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDesign.spaceLG),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
            child: Text(
              'Quick Actions',
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildModernQuickActionCard(
                  'Route Map',
                  Icons.map_rounded,
                  AppColors.primaryGradient,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RouteMapPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildModernQuickActionCard(
                  'Live Tracking',
                  Icons.my_location_rounded,
                  AppColors.accentGradient,
                  () => _showLiveTracking(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Row(
            children: [
              Expanded(
                child: _buildModernQuickActionCard(
                  'Nearby Stops',
                  Icons.location_on_rounded,
                  LinearGradient(
                    colors: [
                      AppColors.warningColor,
                      AppColors.warningColor.withOpacity(0.8)
                    ],
                  ),
                  () => _showNearbyStops(),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildModernQuickActionCard(
                  'Schedules',
                  Icons.schedule_rounded,
                  LinearGradient(
                    colors: [
                      AppColors.tealAccent,
                      AppColors.tealAccent.withOpacity(0.8)
                    ],
                  ),
                  () => _showSchedules(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuickActionCard(
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: AppColors.glassGradient,
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay for icon
            Positioned(
              top: AppDesign.spaceMD,
              left: AppDesign.spaceMD,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: AppDesign.iconMD,
                ),
              ),
            ),
            // Title
            Positioned(
              bottom: AppDesign.spaceMD,
              left: AppDesign.spaceMD,
              right: AppDesign.spaceMD,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularRoutesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDesign.spaceLG),
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.glassGradient,
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Routes',
                      style: AppTextStyles.headline6.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RouteMapPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spaceMD,
                          vertical: AppDesign.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusLG),
                        ),
                        child: Text(
                          'View All',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spaceLG),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDesign.spaceMD),
                  itemBuilder: (context, index) {
                    return _buildModernBusCard(_searchResults[index]);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesign.space2XL),
        ],
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return Container(
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
      child: FloatingActionButton.extended(
        heroTag: "search_fab",
        onPressed: () {
          HapticFeedback.mediumImpact();
          _performSearch();
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: _isSearching
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.search_rounded, color: Colors.white),
        label: Text(
          _isSearching ? 'Searching...' : 'Search Buses',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppDesign.spaceLG),
            Text(
              'Searching for buses...',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.space2XL),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: AppDesign.icon3XL,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              'No buses found',
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              'Try adjusting your search criteria',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results',
            style: AppTextStyles.headline6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppDesign.spaceMD),
            itemBuilder: (context, index) {
              return _buildModernBusCard(_searchResults[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernBusCard(Map<String, dynamic> bus) {
    final occupancyPercent = (bus['occupancy'] / bus['capacity']) * 100;
    final occupancyColor = occupancyPercent > 80
        ? AppColors.dangerColor
        : occupancyPercent > 60
            ? AppColors.warningColor
            : AppColors.successColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusDetailsPage(
                  busId: bus['id'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Bus Icon with Status
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.directions_bus_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          if (bus['isLive'])
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppColors.successColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceLG),

                    // Bus Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                bus['busNumber'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: AppDesign.spaceMD),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDesign.spaceSM,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: bus['isLive']
                                      ? AppColors.successColor.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.circular(AppDesign.radiusLG),
                                ),
                                child: Text(
                                  bus['isLive'] ? 'LIVE' : 'OFFLINE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: bus['isLive']
                                        ? AppColors.successColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bus['routeName'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrival Time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus['nextArrival'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'arrival',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDesign.spaceLG),

                // Route
                Row(
                  children: [
                    Icon(
                      Icons.route,
                      size: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    Expanded(
                      child: Text(
                        bus['route'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDesign.spaceMD),

                // Stats Row
                Row(
                  children: [
                    _buildModernStatChip(
                      Icons.people,
                      '${bus['occupancy']}/${bus['capacity']}',
                      occupancyColor,
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    _buildModernStatChip(
                      Icons.attach_money,
                      bus['fare'],
                      AppColors.successColor,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bus['rating']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
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

  Widget _buildModernStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceMD,
        vertical: AppDesign.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalBusCard(Map<String, dynamic> bus) {
    final occupancyPercentage = (bus['occupancy'] / bus['capacity']) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceLG),
      child: ProfessionalCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusDetailsPage(
                busId: bus['id'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                  ),
                  child: Text(
                    bus['busNumber'],
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                StatusBadge(
                  text: bus['isLive'] ? 'Live' : 'Offline',
                  color: bus['isLive']
                      ? AppColors.successColor
                      : AppColors.textHint,
                  showDot: true,
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceLG),

            // Route Information
            Text(
              bus['routeName'],
              style: AppTextStyles.headline6.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              bus['route'],
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppDesign.spaceLG),

            // Bus Info Grid
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    'Next Arrival',
                    bus['nextArrival'],
                    Icons.access_time_rounded,
                    AppColors.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Fare',
                    bus['fare'],
                    Icons.payments_rounded,
                    AppColors.successColor,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    'Occupancy',
                    '${occupancyPercentage.toInt()}%',
                    Icons.people_rounded,
                    _getOccupancyColor(occupancyPercentage),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceLG),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ProfessionalButton(
                    text: 'Track Live',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveTrackingPage(
                            busId: bus['id'],
                          ),
                        ),
                      );
                    },
                    isOutlined: true,
                    height: 40,
                    borderRadius: AppDesign.radiusMD,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: ProfessionalButton(
                    text: 'View Details',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusDetailsPage(
                            busId: bus['id'],
                          ),
                        ),
                      );
                    },
                    gradient: AppColors.primaryGradient,
                    height: 40,
                    borderRadius: AppDesign.radiusMD,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDesign.iconSM,
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            value,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getOccupancyColor(double percentage) {
    if (percentage >= 90) return AppColors.dangerColor;
    if (percentage >= 70) return AppColors.warningColor;
    return AppColors.successColor;
  }

  Widget _buildModernSearchTypeTab(String title, IconData icon, int index) {
    final isSelected = _selectedSearchType == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedSearchType = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDesign.iconSM,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: AppDesign.spaceXS),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: AppDesign.iconMD,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(AppDesign.spaceLG),
        ),
      ),
    );
  }

  Widget _buildModernSearchButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _isSearching
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          onTap: _isSearching
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  _performSearch();
                },
          child: Center(
            child: _isSearching
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: AppDesign.spaceMD),
                      Text(
                        'Searching...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: AppDesign.iconMD,
                      ),
                      SizedBox(width: AppDesign.spaceMD),
                      Text(
                        'Search Buses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTypeTab(String title, IconData icon, int index) {
    final isSelected = _selectedSearchType == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSearchType = index;
          });
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceMD,
            vertical: AppDesign.spaceMD,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: AppDesign.iconSM,
              ),
              const SizedBox(width: AppDesign.spaceXS),
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return ProfessionalCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
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
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDesign.radiusXL),
            topRight: Radius.circular(AppDesign.radiusXL),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Column(
                children: [
                  Text(
                    'Filter Options',
                    style: AppTextStyles.headline6.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                  ListTile(
                    leading: const Icon(Icons.access_time_rounded),
                    title: const Text('By Schedule'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_rounded),
                    title: const Text('By Occupancy'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.payments_rounded),
                    title: const Text('By Fare'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLiveTracking() {
    HapticFeedback.lightImpact();
    // Navigate to live tracking or show available buses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live Tracking feature coming soon!'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showNearbyStops() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nearby Stops feature coming soon!'),
        backgroundColor: AppColors.warningColor,
      ),
    );
  }

  void _showSchedules() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Schedules feature coming soon!'),
        backgroundColor: AppColors.tealAccent,
      ),
    );
  }
}
