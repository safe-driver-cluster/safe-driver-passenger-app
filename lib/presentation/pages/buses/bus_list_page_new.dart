import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildSliverAppBar(),
          
          // Search Bar
          SliverToBoxAdapter(
            child: _buildSimpleSearchBar(),
          ),
          
          // Bus List
          _buildSliverBusList(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Available Buses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryDark,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by bus number, route, driver...',
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primaryColor,
            size: 24,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textHint,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDesign.spaceLG,
            vertical: AppDesign.spaceLG,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverBusList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vehicles')
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.errorColor,
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  const Text(
                    'Error loading buses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  const Text(
                    'Please try again later',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            ),
          );
        }

        final buses = snapshot.data?.docs ?? [];

        // Simple filtering based on search query
        final filteredBuses = buses.where((bus) {
          final data = bus.data() as Map<String, dynamic>;
          final route = (data['route'] ?? '').toString().toLowerCase();
          final busNumber = (data['busNumberPlate'] ?? '').toString().toLowerCase();
          final driverName = (data['driverName'] ?? '').toString().toLowerCase();
          final location = data['location'] as Map<String, dynamic>?;
          final address = (location?['address'] ?? '').toString().toLowerCase();

          if (_searchQuery.isEmpty) return true;

          return route.contains(_searchQuery) ||
              busNumber.contains(_searchQuery) ||
              driverName.contains(_searchQuery) ||
              address.contains(_searchQuery);
        }).toList();

        if (filteredBuses.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_bus_rounded,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  Text(
                    _searchQuery.isEmpty ? 'No buses available' : 'No buses found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceSM),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Check back later for available buses'
                        : 'Try adjusting your search terms',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final busData = filteredBuses[index].data() as Map<String, dynamic>;
                return _buildBusCard(busData);
              },
              childCount: filteredBuses.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusCard(Map<String, dynamic> busData) {
    final route = busData['route'] ?? 'Unknown Route';
    final busNumber = busData['busNumberPlate'] ?? 'N/A';
    final driverName = busData['driverName'] ?? 'Unknown Driver';
    final model = busData['model'] ?? 'N/A';
    final safetyScore = busData['safetyScore'] ?? 0;
    final batteryLevel = busData['batteryLevel'] ?? 0;
    final fuel = busData['fuel'] ?? 0;
    final location = busData['location'] as Map<String, dynamic>?;
    final address = location?['address'] ?? 'Location unavailable';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowMD,
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with bus number and safety score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    busNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceMD,
                    vertical: AppDesign.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getSafetyScoreColor(safetyScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                    border: Border.all(
                      color: _getSafetyScoreColor(safetyScore),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.security_rounded,
                        size: 16,
                        color: _getSafetyScoreColor(safetyScore),
                      ),
                      const SizedBox(width: AppDesign.spaceXS),
                      Text(
                        '$safetyScore%',
                        style: TextStyle(
                          color: _getSafetyScoreColor(safetyScore),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceMD),

            // Route info
            Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    route,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceSM),

            // Driver and model info
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: AppDesign.spaceSM),
                      Expanded(
                        child: Text(
                          driverName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: AppDesign.spaceSM),
                    Text(
                      model,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceMD),

            // Status indicators
            Row(
              children: [
                Expanded(
                  child: _buildStatusIndicator(
                    'Battery',
                    '$batteryLevel%',
                    Icons.battery_full_rounded,
                    _getBatteryColor(batteryLevel),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: _buildStatusIndicator(
                    'Fuel',
                    '$fuel%',
                    Icons.local_gas_station_rounded,
                    _getFuelColor(fuel),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: _buildStatusIndicator(
                    'Location',
                    address.length > 15 ? '${address.substring(0, 15)}...' : address,
                    Icons.location_on_rounded,
                    AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDesign.spaceXS),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: AppDesign.spaceXS),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getSafetyScoreColor(int score) {
    if (score >= 80) return AppColors.successColor;
    if (score >= 60) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getBatteryColor(int level) {
    if (level >= 80) return AppColors.successColor;
    if (level >= 50) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getFuelColor(int level) {
    if (level >= 70) return AppColors.successColor;
    if (level >= 30) return AppColors.warningColor;
    return AppColors.errorColor;
  }
}