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
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildBusList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
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

          // Simple Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vehicles')
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.errorColor,
                ),
                SizedBox(height: AppDesign.spaceMD),
                Text(
                  'Error loading buses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDesign.spaceSM),
                Text(
                  'Please try again later',
                  style: TextStyle(
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
          final busNumber =
              (data['busNumberPlate'] ?? '').toString().toLowerCase();
          final driverName =
              (data['driverName'] ?? '').toString().toLowerCase();
          final location = data['location'] as Map<String, dynamic>?;
          final address = (location?['address'] ?? '').toString().toLowerCase();

          if (_searchQuery.isEmpty) return true;

          return route.contains(_searchQuery) ||
              busNumber.contains(_searchQuery) ||
              driverName.contains(_searchQuery) ||
              address.contains(_searchQuery);
        }).toList();

        if (filteredBuses.isEmpty) {
          return Center(
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
                  _searchQuery.isEmpty
                      ? 'No buses available'
                      : 'No buses found',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                  ),
                  child: Text(
                    busNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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

            // Driver and location
            Row(
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceLG),
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: AppDesign.spaceSM),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDesign.spaceMD),

            // Bus details and status indicators
            Row(
              children: [
                Expanded(
                  child: _buildStatusIndicator(
                    'Model',
                    model,
                    Icons.directions_bus_rounded,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildStatusIndicator(
                    'Battery',
                    '$batteryLevel%',
                    Icons.battery_full_rounded,
                    _getBatteryColor(batteryLevel),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildStatusIndicator(
                    'Fuel',
                    '$fuel%',
                    Icons.local_gas_station_rounded,
                    _getFuelColor(fuel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceSM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusSM),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(height: AppDesign.spaceXS),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSafetyScoreColor(int score) {
    if (score >= 90) return AppColors.successColor;
    if (score >= 75) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getBatteryColor(int battery) {
    if (battery >= 70) return AppColors.successColor;
    if (battery >= 30) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Color _getFuelColor(int fuel) {
    if (fuel >= 50) return AppColors.successColor;
    if (fuel >= 25) return AppColors.warningColor;
    return AppColors.errorColor;
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
          currentIndex: 1, // Buses tab is selected
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/dashboard', (route) => false);
                break;
              case 1:
                // Already on buses page
                break;
              case 2:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/dashboard', (route) => false);
                break;
              case 3:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/dashboard', (route) => false);
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.dashboard_outlined,
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
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.search,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.map_outlined,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.person_outlined,
                  size: AppDesign.iconMD,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
