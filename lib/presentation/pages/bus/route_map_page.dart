import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';
import 'bus_details_page.dart';
import 'live_tracking_page.dart';

class RouteMapPage extends ConsumerStatefulWidget {
  final String? routeId;
  final String? routeName;

  const RouteMapPage({
    super.key,
    this.routeId,
    this.routeName,
  });

  @override
  ConsumerState<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends ConsumerState<RouteMapPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fabAnimation;

  final PageController _pageController = PageController();
  int _currentMapType = 0; // 0: Route View, 1: Stops View, 2: Live Buses
  final bool _isLoading = false;
  String _selectedRoute = 'Route 001 - City Express';

  // Sample route data
  List<Map<String, dynamic>> _routes = [];
  List<Map<String, dynamic>> _busStops = [];
  List<Map<String, dynamic>> _liveBuses = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadRouteData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        _fabAnimationController.forward();
      });
    });
  }

  void _loadRouteData() {
    setState(() {
      _routes = [
        {
          'id': 'route_001',
          'name': 'City Express',
          'routeNumber': '001',
          'description': 'City Center ↔ Airport',
          'totalStops': 15,
          'estimatedTime': '45 min',
          'operatingHours': '05:30 - 23:00',
          'frequency': '10-15 min',
          'fare': 'Rs. 210',
          'color': AppColors.primaryColor,
          'isActive': true,
        },
        {
          'id': 'route_002',
          'name': 'University Line',
          'routeNumber': '002',
          'description': 'University ↔ Downtown',
          'totalStops': 22,
          'estimatedTime': '35 min',
          'operatingHours': '06:00 - 22:30',
          'frequency': '8-12 min',
          'fare': 'Rs. 170',
          'color': AppColors.successColor,
          'isActive': true,
        },
        {
          'id': 'route_003',
          'name': 'Residential Route',
          'routeNumber': '003',
          'description': 'Mall ↔ Residential Area',
          'totalStops': 18,
          'estimatedTime': '28 min',
          'operatingHours': '06:30 - 21:00',
          'frequency': '15-20 min',
          'fare': 'Rs. 150',
          'color': AppColors.warningColor,
          'isActive': false,
        },
      ];

      _busStops = [
        {
          'id': 'stop_001',
          'name': 'City Center Terminal',
          'code': 'CCT01',
          'address': '123 Main Street, City Center',
          'amenities': ['Shelter', 'Seating', 'Digital Display', 'WiFi'],
          'nextBus': '3 min',
          'routesServed': ['001', '005', '012'],
          'isAccessible': true,
          'coordinates': {'lat': 37.7749, 'lng': -122.4194},
        },
        {
          'id': 'stop_002',
          'name': 'Shopping Mall',
          'code': 'SM02',
          'address': '456 Commerce Blvd, Mall District',
          'amenities': ['Shelter', 'Seating', 'Ticket Machine'],
          'nextBus': '7 min',
          'routesServed': ['001', '003', '008'],
          'isAccessible': true,
          'coordinates': {'lat': 37.7849, 'lng': -122.4094},
        },
        {
          'id': 'stop_003',
          'name': 'University Campus',
          'code': 'UC03',
          'address': '789 University Ave, Campus',
          'amenities': ['Shelter', 'Digital Display', 'Security'],
          'nextBus': '12 min',
          'routesServed': ['002', '007', '011'],
          'isAccessible': false,
          'coordinates': {'lat': 37.7649, 'lng': -122.4294},
        },
      ];

      _liveBuses = [
        {
          'id': 'bus_001',
          'busNumber': 'B001',
          'route': '001',
          'routeName': 'City Express',
          'currentLocation': 'Approaching Mall Stop',
          'nextStop': 'Shopping Mall',
          'eta': '2 min',
          'occupancy': 68,
          'capacity': 85,
          'delay': 0,
          'isOnTime': true,
          'coordinates': {'lat': 37.7799, 'lng': -122.4144},
        },
        {
          'id': 'bus_002',
          'busNumber': 'B023',
          'route': '002',
          'routeName': 'University Line',
          'currentLocation': 'Downtown Terminal',
          'nextStop': 'University Campus',
          'eta': '8 min',
          'occupancy': 42,
          'capacity': 65,
          'delay': 3,
          'isOnTime': false,
          'coordinates': {'lat': 37.7699, 'lng': -122.4244},
        },
      ];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildProfessionalAppBar(),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        _buildRouteSelector(),
                        _buildViewTypeSelector(),
                        _buildContentView(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAnimatedFAB(),
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
          widget.routeName ?? 'Route Maps',
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
                  Icons.route_rounded,
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
          icon: const Icon(Icons.search_rounded),
          onPressed: () => _showRouteSearch(),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () => _showFilterOptions(),
        ),
      ],
    );
  }

  Widget _buildRouteSelector() {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      child: ProfessionalCard(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: AppColors.primaryColor,
                    size: AppDesign.iconMD,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Route',
                        style: AppTextStyles.headline6.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Choose a route to view details',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRoute,
                  isExpanded: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
                  items: _routes.map((route) {
                    return DropdownMenuItem<String>(
                      value: '${route['routeNumber']} - ${route['name']}',
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: route['color'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: AppDesign.spaceMD),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Route ${route['routeNumber']} - ${route['name']}',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  route['description'],
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!route['isActive'])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDesign.spaceSM,
                                vertical: AppDesign.spaceXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.errorColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusSM),
                              ),
                              child: Text(
                                'Inactive',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRoute = value;
                      });
                      HapticFeedback.lightImpact();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewTypeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      child: ProfessionalCard(
        padding: const EdgeInsets.all(AppDesign.spaceSM),
        child: Row(
          children: [
            _buildViewTypeTab('Route View', Icons.timeline_rounded, 0),
            _buildViewTypeTab('Bus Stops', Icons.location_on_rounded, 1),
            _buildViewTypeTab('Live Buses', Icons.directions_bus_rounded, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildViewTypeTab(String title, IconData icon, int index) {
    final isSelected = _currentMapType == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentMapType = index;
          });
          HapticFeedback.lightImpact();
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: AppDesign.iconSM,
              ),
              const SizedBox(height: AppDesign.spaceXS),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentMapType = index;
          });
        },
        children: [
          _buildRouteOverview(),
          _buildBusStopsView(),
          _buildLiveBusesView(),
        ],
      ),
    );
  }

  Widget _buildRouteOverview() {
    final currentRoute = _routes.first;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Route Stats Card
          ProfessionalCard(
            gradient: AppColors.primaryGradient,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Total Stops',
                        '${currentRoute['totalStops']}',
                        Icons.location_on_rounded,
                        Colors.white,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white24,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Journey Time',
                        currentRoute['estimatedTime'],
                        Icons.access_time_rounded,
                        Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spaceLG),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Frequency',
                        currentRoute['frequency'],
                        Icons.schedule_rounded,
                        Colors.white,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white24,
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Base Fare',
                        currentRoute['fare'],
                        Icons.payments_rounded,
                        Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDesign.spaceLG),

          // Operating Hours
          ProfessionalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDesign.spaceSM),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.successColor,
                        size: AppDesign.iconSM,
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceMD),
                    Text(
                      'Operating Hours',
                      style: AppTextStyles.headline6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDesign.spaceLG),
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceLG),
                  decoration: BoxDecoration(
                    color: AppColors.successColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                    border: Border.all(
                      color: AppColors.successColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.successColor,
                      ),
                      const SizedBox(width: AppDesign.spaceMD),
                      Text(
                        currentRoute['operatingHours'],
                        style: AppTextStyles.headline6.copyWith(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spaceMD,
                          vertical: AppDesign.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successColor,
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDesign.spaceLG),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ProfessionalButton(
                  text: 'View Live Tracking',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiveTrackingPage(
                          busId: 'route_001',
                        ),
                      ),
                    );
                  },
                  gradient: AppColors.primaryGradient,
                  prefixIcon: Icons.location_on_rounded,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: ProfessionalButton(
                  text: 'Route Details',
                  onPressed: () => _showRouteDetails(currentRoute),
                  isOutlined: true,
                  prefixIcon: Icons.info_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusStopsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bus Stops on Route',
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.spaceLG),
        Expanded(
          child: ListView.builder(
            itemCount: _busStops.length,
            itemBuilder: (context, index) {
              final stop = _busStops[index];
              return _buildBusStopCard(stop, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBusStopCard(Map<String, dynamic> stop, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceLG),
      child: ProfessionalCard(
        onTap: () => _showStopDetails(stop),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop['name'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Code: ${stop['code']}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceSM,
                        vertical: AppDesign.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                      ),
                      child: Text(
                        'Next: ${stop['nextBus']}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.successColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (stop['isAccessible'])
                      Container(
                        margin: const EdgeInsets.only(top: AppDesign.spaceXS),
                        child: const Icon(
                          Icons.accessible_rounded,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            Text(
              stop['address'],
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Wrap(
              spacing: AppDesign.spaceSM,
              runSpacing: AppDesign.spaceXS,
              children: (stop['amenities'] as List<String>).map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                  ),
                  child: Text(
                    amenity,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveBusesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Buses on Route',
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDesign.spaceLG),
        Expanded(
          child: ListView.builder(
            itemCount: _liveBuses.length,
            itemBuilder: (context, index) {
              final bus = _liveBuses[index];
              return _buildLiveBusCard(bus);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBusCard(Map<String, dynamic> bus) {
    final occupancyPercentage = (bus['occupancy'] / bus['capacity']) * 100;
    final occupancyColor = occupancyPercentage > 80
        ? AppColors.errorColor
        : occupancyPercentage > 60
            ? AppColors.warningColor
            : AppColors.successColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceLG),
      child: ProfessionalCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusDetailsPage(busId: bus['id']),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceLG),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.white,
                    size: AppDesign.iconLG,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bus ${bus['busNumber']}',
                        style: AppTextStyles.headline6.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        bus['routeName'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceMD,
                        vertical: AppDesign.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: bus['isOnTime']
                            ? AppColors.successColor.withOpacity(0.1)
                            : AppColors.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                      ),
                      child: Text(
                        bus['isOnTime'] ? 'ON TIME' : '+${bus['delay']} MIN',
                        style: AppTextStyles.caption.copyWith(
                          color: bus['isOnTime']
                              ? AppColors.successColor
                              : AppColors.warningColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'ETA: ${bus['eta']}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceLG),

            // Current Status
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primaryColor,
                    size: AppDesign.iconSM,
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          bus['currentLocation'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Next: ${bus['nextStop']}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDesign.spaceLG),

            // Occupancy Bar
            Row(
              children: [
                const Icon(
                  Icons.people_rounded,
                  color: AppColors.textSecondary,
                  size: AppDesign.iconSM,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Occupancy',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${bus['occupancy']}/${bus['capacity']} (${occupancyPercentage.toInt()}%)',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: occupancyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDesign.spaceXS),
                      LinearProgressIndicator(
                        value: occupancyPercentage / 100,
                        backgroundColor: AppColors.borderColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(occupancyColor),
                        minHeight: 6,
                      ),
                    ],
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
                    prefixIcon: Icons.my_location_rounded,
                    height: 36,
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
                    prefixIcon: Icons.info_outline_rounded,
                    height: 36,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color textColor) {
    return Column(
      children: [
        Icon(
          icon,
          color: textColor.withOpacity(0.8),
          size: AppDesign.iconSM,
        ),
        const SizedBox(height: AppDesign.spaceXS),
        Text(
          value,
          style: AppTextStyles.headline5.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () => _showQuickActions(),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Quick Actions'),
          ),
        );
      },
    );
  }

  void _showRouteSearch() {
    // Implementation for route search
    HapticFeedback.lightImpact();
  }

  void _showFilterOptions() {
    // Implementation for filter options
    HapticFeedback.lightImpact();
  }

  void _showRouteDetails(Map<String, dynamic> route) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRouteDetailsModal(route),
    );
  }

  void _showStopDetails(Map<String, dynamic> stop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStopDetailsModal(stop),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickActionsModal(),
    );
  }

  Widget _buildRouteDetailsModal(Map<String, dynamic> route) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDesign.radiusXL),
          topRight: Radius.circular(AppDesign.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route ${route['routeNumber']} - ${route['name']}',
                  style: AppTextStyles.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  route['description'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopDetailsModal(Map<String, dynamic> stop) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDesign.radiusXL),
          topRight: Radius.circular(AppDesign.radiusXL),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop['name'],
                  style: AppTextStyles.headline5.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceMD),
                Text(
                  'Code: ${stop['code']}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsModal() {
    final actions = [
      {
        'title': 'Report Issue',
        'icon': Icons.report_problem_rounded,
        'color': AppColors.warningColor
      },
      {
        'title': 'Schedule Alert',
        'icon': Icons.notifications_rounded,
        'color': AppColors.primaryColor
      },
      {
        'title': 'Share Route',
        'icon': Icons.share_rounded,
        'color': AppColors.successColor
      },
      {
        'title': 'Save Route',
        'icon': Icons.bookmark_add_rounded,
        'color': AppColors.primaryColor
      },
    ];

    return Container(
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
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            child: Column(
              children: [
                Text(
                  'Quick Actions',
                  style: AppTextStyles.headline6.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceLG),
                ...actions.map((action) => ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(AppDesign.spaceMD),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusLG),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                        ),
                      ),
                      title: Text(action['title'] as String),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        HapticFeedback.lightImpact();
                      },
                    )),
                const SizedBox(height: AppDesign.spaceLG),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
