import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

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
    with TickerProviderStateMixin {
  final _busNumberController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _routeController = TextEditingController();
  final _searchController = TextEditingController();

  late TabController _tabController;
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fabAnimation;

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _recentSearches = [];
  List<String> _popularDestinations = [];
  bool _isSearching = false;
  bool _showSearchResults = false;
  int _selectedSearchType = 0; // 0: Route, 1: Bus Number, 2: Location

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.elasticOut),
    );

    _loadPopularRoutes();
    _loadRecentSearches();
    _loadPopularDestinations();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        _fabAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _busNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _routeController.dispose();
    _searchController.dispose();
    _tabController.dispose();
    _animationController.dispose();
    _fabAnimationController.dispose();
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

  void _loadRecentSearches() {
    setState(() {
      _recentSearches = [
        {
          'type': 'route',
          'from': 'City Center',
          'to': 'Airport',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        },
        {
          'type': 'busNumber',
          'busNumber': 'B023',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        },
        {
          'type': 'location',
          'location': 'University',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        },
      ];
    });
  }

  void _loadPopularDestinations() {
    setState(() {
      _popularDestinations = [
        'Airport',
        'University',
        'City Center',
        'Downtown',
        'Mall',
        'Hospital',
        'Train Station',
        'Business District',
      ];
    });
  }

  void _performSearch() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isSearching = true;
      _showSearchResults = true;
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
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Modern App Bar with Gradient
                _buildModernAppBar(),

                // Search Hero Section
                SliverToBoxAdapter(
                  child: _buildHeroSearchSection(),
                ),

                // Quick Search Suggestions
                SliverToBoxAdapter(
                  child: _buildQuickSuggestions(),
                ),

                // Main Search Content
                SliverToBoxAdapter(
                  child: _buildMainSearchContent(),
                ),

                // Search Results or Popular Routes
                _showSearchResults 
                    ? _buildSearchResultsSliver()
                    : _buildPopularRoutesSliver(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildAnimatedFAB(),
    );
  }

  // New Modern Widget Methods
  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.tealAccent.withOpacity(0.6),
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          title: const Text(
            'Find Your Ride',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.tealAccent,
                ],
              ),
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
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
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
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSearchSection() {
    return Transform.translate(
      offset: Offset(0, _slideAnimation.value),
      child: Container(
        margin: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          children: [
            // Main Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Where are you going?',
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 16,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  suffixIcon: Container(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _showSearchResults = value.isNotEmpty;
                  });
                },
                onTap: () {
                  HapticFeedback.lightImpact();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSuggestions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final suggestions = [
                  {'icon': Icons.location_city, 'title': 'City Center', 'color': Colors.blue},
                  {'icon': Icons.local_airport, 'title': 'Airport', 'color': Colors.green},
                  {'icon': Icons.school, 'title': 'University', 'color': Colors.orange},
                  {'icon': Icons.local_mall, 'title': 'Mall', 'color': Colors.purple},
                ];
                
                return Container(
                  width: 80,
                  margin: EdgeInsets.only(right: index < 3 ? 12 : 0),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: (suggestions[index]['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          suggestions[index]['icon'] as IconData,
                          color: suggestions[index]['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        suggestions[index]['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSearchContent() {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        children: [
          // Search Type Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildModernTab('Route', 0, Icons.route),
                _buildModernTab('Bus #', 1, Icons.directions_bus),
                _buildModernTab('Live', 2, Icons.live_tv),
              ],
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),
          
          // Search Fields Based on Type
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildSearchFieldsForType(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTab(String title, int index, IconData icon) {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                size: 18,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primaryColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFieldsForType() {
    switch (_selectedSearchType) {
      case 0: // Route
        return Column(
          key: const ValueKey('route'),
          children: [
            _buildModernTextField(
              controller: _fromController,
              label: 'From',
              hint: 'Starting point',
              icon: Icons.my_location,
            ),
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _toController,
              label: 'To',
              hint: 'Destination',
              icon: Icons.location_on,
            ),
          ],
        );
      case 1: // Bus Number
        return Column(
          key: const ValueKey('bus'),
          children: [
            _buildModernTextField(
              controller: _busNumberController,
              label: 'Bus Number',
              hint: 'e.g., B001',
              icon: Icons.directions_bus,
            ),
          ],
        );
      case 2: // Live Tracking
        return Column(
          key: const ValueKey('live'),
          children: [
            _buildModernTextField(
              controller: _routeController,
              label: 'Route Name',
              hint: 'e.g., City Express',
              icon: Icons.route,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSearchResultsSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildModernBusCard(_searchResults[index]);
        },
        childCount: _searchResults.length,
      ),
    );
  }

  Widget _buildPopularRoutesSliver() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular Routes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return _buildModernBusCard(_searchResults[index]);
              },
            ),
          ],
        ),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Bus Icon with Status
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
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
                                  color: Colors.green,
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
                    const SizedBox(width: 16),
                    
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
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: bus['isLive']
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  bus['isLive'] ? 'LIVE' : 'OFFLINE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: bus['isLive'] ? Colors.green : Colors.grey,
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
                              color: AppColors.textSecondary,
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
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const Text(
                          'arrival',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Route
                Row(
                  children: [
                    const Icon(
                      Icons.route,
                      size: 16,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bus['route'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Stats Row
                Row(
                  children: [
                    _buildStatChip(
                      Icons.people,
                      '${bus['occupancy']}/${bus['capacity']}',
                      occupancyColor,
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      Icons.attach_money,
                      bus['fare'],
                      AppColors.successColor,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bus['rating']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
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

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
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

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () {
              HapticFeedback.mediumImpact();
              _performSearch();
            },
            backgroundColor: AppColors.primaryColor,
            elevation: 8,
            icon: _isSearching
                ? SizedBox(
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
      },
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
