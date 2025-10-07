import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';
import 'bus_details_page.dart';
import 'live_tracking_page.dart';

class BusSearchPage extends ConsumerStatefulWidget {
  const BusSearchPage({super.key});

  @override
  ConsumerState<BusSearchPage> createState() => _BusSearchPageState();
}

class _BusSearchPageState extends ConsumerState<BusSearchPage>
    with SingleTickerProviderStateMixin {
  final _busNumberController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _routeController = TextEditingController();

  late TabController _tabController;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  int _selectedSearchType = 0; // 0: Route, 1: Bus Number, 2: Location

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPopularRoutes();
  }

  @override
  void dispose() {
    _busNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _routeController.dispose();
    _tabController.dispose();
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
          'fare': '\$2.50',
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
          'fare': '\$2.00',
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
          'fare': '\$1.75',
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
          _searchResults = _searchResults.where((bus) {
            return bus['routeName']
                .toLowerCase()
                .contains(_routeController.text.toLowerCase());
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
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.backgroundColor,
              AppColors.scaffoldBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Professional Header
              _buildProfessionalHeader(),

              // Search Content
              Expanded(
                child: Column(
                  children: [
                    // Search Tabs
                    _buildSearchTabs(),

                    const SizedBox(height: AppDesign.spaceLG),

                    // Search Form
                    _buildSearchForm(),

                    const SizedBox(height: AppDesign.spaceLG),

                    // Results Section
                    Expanded(child: _buildSearchResults()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.space2XL),
          bottomRight: Radius.circular(AppDesign.space2XL),
        ),
        boxShadow: AppDesign.shadowLG,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.search_rounded,
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
                      'Find Your Bus',
                      style: AppTextStyles.headline5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceXS),
                    Text(
                      'Search by route, bus number, or location',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      child: ProfessionalCard(
        padding: const EdgeInsets.all(AppDesign.spaceXS),
        child: Row(
          children: [
            Expanded(
              child: _buildTabButton(
                'Route',
                0,
                Icons.route_rounded,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                'Bus Number',
                1,
                Icons.directions_bus_rounded,
              ),
            ),
            Expanded(
              child: _buildTabButton(
                'Location',
                2,
                Icons.location_on_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = _selectedSearchType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSearchType = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDesign.spaceMD,
          horizontal: AppDesign.spaceSM,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
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
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      child: ProfessionalCard(
        child: Column(
          children: [
            if (_selectedSearchType == 0) ..._buildRouteSearchFields(),
            if (_selectedSearchType == 1) ..._buildBusNumberSearchFields(),
            if (_selectedSearchType == 2) ..._buildLocationSearchFields(),

            const SizedBox(height: AppDesign.spaceLG),

            // Search Button
            ProfessionalButton(
              text: _isSearching ? 'Searching...' : 'Search Buses',
              onPressed: _isSearching ? null : _performSearch,
              isLoading: _isSearching,
              width: double.infinity,
              gradient: AppColors.primaryGradient,
              icon: _isSearching
                  ? null
                  : const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: AppDesign.iconSM,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRouteSearchFields() {
    return [
      ProfessionalTextField(
        controller: _fromController,
        labelText: 'From',
        hintText: 'Enter departure location',
        prefixIcon: const Icon(Icons.my_location_rounded),
      ),
      const SizedBox(height: AppDesign.spaceLG),
      ProfessionalTextField(
        controller: _toController,
        labelText: 'To',
        hintText: 'Enter destination',
        prefixIcon: const Icon(Icons.location_on_rounded),
      ),
    ];
  }

  List<Widget> _buildBusNumberSearchFields() {
    return [
      ProfessionalTextField(
        controller: _busNumberController,
        labelText: 'Bus Number',
        hintText: 'Enter bus number (e.g., B001)',
        prefixIcon: const Icon(Icons.directions_bus_rounded),
      ),
    ];
  }

  List<Widget> _buildLocationSearchFields() {
    return [
      ProfessionalTextField(
        controller: _routeController,
        labelText: 'Route Name',
        hintText: 'Enter route name',
        prefixIcon: const Icon(Icons.route_rounded),
      ),
    ];
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final bus = _searchResults[index];
        return _buildProfessionalBusCard(bus);
      },
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
}
