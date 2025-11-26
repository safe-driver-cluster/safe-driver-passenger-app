import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          child: Column(
            children: [
              // Header with search
              _buildHeader(),
              
              // Bus list
              Expanded(
                child: _buildBusList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        AppDesign.spaceSM,
        AppDesign.spaceLG,
        AppDesign.spaceMD,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and back button
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Text(
                'Available Buses',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          
          // Search bar
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
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
                hintText: 'Search by route, bus number...',
                hintStyle: TextStyle(
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
                  vertical: AppDesign.spaceMD,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.space2XL),
          topRight: Radius.circular(AppDesign.space2XL),
        ),
        boxShadow: AppDesign.shadowLG,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDesign.space2XL),
          topRight: Radius.circular(AppDesign.space2XL),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vehicles')
              .where('status', isEqualTo: 'active')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppColors.errorColor,
                    ),
                    const SizedBox(height: AppDesign.spaceMD),
                    Text(
                      'Error loading buses',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceSM),
                    Text(
                      'Please try again later',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
              );
            }

            final buses = snapshot.data?.docs ?? [];
            
            // Filter buses based on search query
            final filteredBuses = buses.where((bus) {
              final data = bus.data() as Map<String, dynamic>;
              final route = (data['route'] ?? '').toString().toLowerCase();
              final busNumber = (data['busNumberPlate'] ?? '').toString().toLowerCase();
              final driverName = (data['driverName'] ?? '').toString().toLowerCase();
              
              return route.contains(_searchQuery) ||
                     busNumber.contains(_searchQuery) ||
                     driverName.contains(_searchQuery);
            }).toList();

            if (filteredBuses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: AppDesign.spaceMD),
                    Text(
                      _searchQuery.isEmpty ? 'No buses available' : 'No buses found',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceSM),
                    Text(
                      _searchQuery.isEmpty 
                          ? 'Check back later for available buses'
                          : 'Try a different search term',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              itemCount: filteredBuses.length,
              itemBuilder: (context, index) {
                final busData = filteredBuses[index].data() as Map<String, dynamic>;
                return _buildBusCard(busData);
              },
            );
          },
        ),
      ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getSafetyColor(safetyScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                    border: Border.all(
                      color: _getSafetyColor(safetyScore).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.security_rounded,
                        size: 14,
                        color: _getSafetyColor(safetyScore),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$safetyScore%',
                        style: TextStyle(
                          color: _getSafetyColor(safetyScore),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesign.spaceMD),
            
            // Route information
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                  ),
                  child: Icon(
                    Icons.route_rounded,
                    size: 16,
                    color: AppColors.accentColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    route,
                    style: AppTextStyles.bodyLarge.copyWith(
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
                      Icon(
                        Icons.person_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDesign.spaceXS),
                      Flexible(
                        child: Text(
                          driverName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_bus_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDesign.spaceXS),
                      Flexible(
                        child: Text(
                          model,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesign.spaceSM),
            
            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDesign.spaceXS),
                Expanded(
                  child: Text(
                    address,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesign.spaceMD),
            
            // Status indicators
            Row(
              children: [
                _buildStatusIndicator(
                  icon: Icons.battery_charging_full_rounded,
                  value: '$batteryLevel%',
                  color: _getBatteryColor(batteryLevel),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                _buildStatusIndicator(
                  icon: Icons.local_gas_station_rounded,
                  value: '$fuel%',
                  color: _getFuelColor(fuel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSafetyColor(int score) {
    if (score >= 90) return AppColors.successColor;
    if (score >= 70) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getBatteryColor(int level) {
    if (level >= 70) return AppColors.successColor;
    if (level >= 30) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getFuelColor(int level) {
    if (level >= 50) return AppColors.successColor;
    if (level >= 25) return AppColors.warningColor;
    return AppColors.errorColor;
  }
}