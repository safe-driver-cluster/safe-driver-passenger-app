import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
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

  void _searchByRoute() {
    setState(() {
      _isSearching = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _searchResults.where((bus) {
            return bus['routeName']
                    .toLowerCase()
                    .contains(_routeController.text.toLowerCase()) ||
                bus['route']
                    .toLowerCase()
                    .contains(_routeController.text.toLowerCase());
          }).toList();
        });
      }
    });
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

  void _searchByLocation() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Search Buses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchSection(),
                _buildSearchResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Search Type Tabs
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildSearchTypeTab('Route', 0, Icons.route),
                _buildSearchTypeTab('Bus #', 1, Icons.directions_bus),
                _buildSearchTypeTab('Location', 2, Icons.location_on),
              ],
            ),
          ),

          // Search Fields
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchFields(),
          ),

          // Search Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSearching ? null : _performSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: _isSearching
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Search Buses',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTypeTab(String label, int index, IconData icon) {
    bool isSelected = _selectedSearchType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSearchType = index;
            _searchResults.clear();
            _loadPopularRoutes();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFields() {
    switch (_selectedSearchType) {
      case 0: // Route search
        return TextField(
          controller: _routeController,
          decoration: InputDecoration(
            hintText: 'Enter route name (e.g., City Express)',
            prefixIcon: const Icon(Icons.route, color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        );
      case 1: // Bus number search
        return TextField(
          controller: _busNumberController,
          decoration: InputDecoration(
            hintText: 'Enter bus number (e.g., B001)',
            prefixIcon:
                const Icon(Icons.directions_bus, color: AppColors.primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
        );
      case 2: // Location search
      default:
        return Column(
          children: [
            TextField(
              controller: _fromController,
              decoration: InputDecoration(
                hintText: 'From (e.g., City Center)',
                prefixIcon: const Icon(Icons.trip_origin,
                    color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _toController,
              decoration: InputDecoration(
                hintText: 'To (e.g., Airport)',
                prefixIcon: const Icon(Icons.location_on,
                    color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && !_isSearching) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No buses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_searchResults.length} buses found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              TextButton.icon(
                onPressed: _loadPopularRoutes,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final bus = _searchResults[index];
            return _buildBusCard(bus);
          },
        ),
      ],
    );
  }

  Widget _buildBusCard(Map<String, dynamic> bus) {
    double occupancyPercentage = (bus['occupancy'] / bus['capacity']) * 100;
    Color occupancyColor = occupancyPercentage > 80
        ? Colors.red
        : occupancyPercentage > 60
            ? Colors.orange
            : Colors.green;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bus Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: bus['isLive'] ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              bus['isLive'] ? 'LIVE' : 'OFFLINE',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        bus['routeName'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      bus['nextArrival'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      'arrives',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bus Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.route, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bus['route'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Occupancy Bar
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${bus['occupancy']}/${bus['capacity']} passengers',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: occupancyPercentage / 100,
                            backgroundColor: Colors.grey.shade200,
                            color: occupancyColor,
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Driver & Fare Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          bus['driverName'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 12, color: Colors.amber),
                            Text(
                              bus['rating'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bus['fare'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
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
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryColor,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: bus['isLive']
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveTrackingPage(
                                  busId: bus['id'],
                                  busNumber: bus['busNumber'],
                                  routeNumber: bus['routeName'],
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.location_on, size: 18),
                    label: const Text('Track Live'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
