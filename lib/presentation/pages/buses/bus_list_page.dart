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
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  String _searchQuery = '';
  int _selectedSearchType = 0; // 0: Route, 1: Bus Number, 2: Live Tracking

  @override
  void dispose() {
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _busNumberController.dispose();
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

          // Advanced Search Section
          _buildAdvancedSearchSection(),
        ],
      ),
    );
  }

  Widget _buildAdvancedSearchSection() {
    return Column(
      children: [
        // Search Type Selector
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            boxShadow: AppDesign.shadowMD,
          ),
          padding: const EdgeInsets.all(AppDesign.spaceSM),
          child: Row(
            children: [
              _buildSearchTypeTab('Route', Icons.route_rounded, 0),
              _buildSearchTypeTab('Bus #', Icons.directions_bus_rounded, 1),
              _buildSearchTypeTab('Live', Icons.live_tv_rounded, 2),
            ],
          ),
        ),

        const SizedBox(height: AppDesign.spaceMD),

        // Search Form
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            boxShadow: AppDesign.shadowMD,
          ),
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          child: Column(
            children: [
              if (_selectedSearchType == 0) ...[
                _buildSearchField(
                  controller: _fromController,
                  labelText: 'From',
                  hintText: 'Enter departure location',
                  icon: Icons.my_location_rounded,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildSearchField(
                  controller: _toController,
                  labelText: 'To',
                  hintText: 'Enter destination',
                  icon: Icons.location_on_rounded,
                ),
              ] else if (_selectedSearchType == 1) ...[
                _buildSearchField(
                  controller: _busNumberController,
                  labelText: 'Bus Number',
                  hintText: 'Enter bus number (e.g., NB-9999)',
                  icon: Icons.directions_bus_rounded,
                ),
              ] else ...[
                _buildSearchField(
                  controller: _busNumberController,
                  labelText: 'Live Tracking',
                  hintText: 'Enter bus number for live tracking',
                  icon: Icons.live_tv_rounded,
                ),
              ],

              const SizedBox(height: AppDesign.spaceLG),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: AppDesign.spaceMD),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_rounded, size: 20),
                      SizedBox(width: AppDesign.spaceSM),
                      Text(
                        'Search Buses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTypeTab(String title, IconData icon, int index) {
    final isSelected = _selectedSearchType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSearchType = index),
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
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: AppDesign.spaceXS),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDesign.spaceXS),
        TextField(
          controller: controller,
          onChanged: (value) => _updateSearchQuery(),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 20,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      controller.clear();
                      _updateSearchQuery();
                    },
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              borderSide: BorderSide(
                color: AppColors.primaryColor.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              borderSide: BorderSide(
                color: AppColors.primaryColor.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDesign.spaceMD,
              vertical: AppDesign.spaceSM,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _updateSearchQuery() {
    setState(() {
      if (_selectedSearchType == 0) {
        _searchQuery =
            '${_fromController.text.toLowerCase()} ${_toController.text.toLowerCase()}'
                .trim();
      } else {
        _searchQuery = _busNumberController.text.toLowerCase();
      }
    });
  }

  void _performSearch() {
    _updateSearchQuery();
    // The filtering will happen automatically in the StreamBuilder
  }

  Widget _buildBusList() {
    return Padding(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
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
                  const Icon(
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
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            );
          }

          final buses = snapshot.data?.docs ?? [];

          // Filter buses based on search query and type
          final filteredBuses = buses.where((bus) {
            final data = bus.data() as Map<String, dynamic>;
            final route = (data['route'] ?? '').toString().toLowerCase();
            final busNumber =
                (data['busNumberPlate'] ?? '').toString().toLowerCase();
            final driverName =
                (data['driverName'] ?? '').toString().toLowerCase();
            final location = data['location'] as Map<String, dynamic>?;
            final address =
                (location?['address'] ?? '').toString().toLowerCase();

            if (_searchQuery.isEmpty) return true;

            if (_selectedSearchType == 0) {
              // Route search
              final fromQuery = _fromController.text.toLowerCase();
              final toQuery = _toController.text.toLowerCase();

              if (fromQuery.isNotEmpty && toQuery.isNotEmpty) {
                return route.contains(fromQuery) && route.contains(toQuery);
              } else if (fromQuery.isNotEmpty) {
                return route.contains(fromQuery) || address.contains(fromQuery);
              } else if (toQuery.isNotEmpty) {
                return route.contains(toQuery) || address.contains(toQuery);
              }
              return route.contains(_searchQuery) ||
                  address.contains(_searchQuery);
            } else if (_selectedSearchType == 1) {
              // Bus number search
              return busNumber.contains(_searchQuery);
            } else {
              // Live tracking search (bus number based)
              return busNumber.contains(_searchQuery);
            }
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
            itemCount: filteredBuses.length,
            itemBuilder: (context, index) {
              final busData =
                  filteredBuses[index].data() as Map<String, dynamic>;
              return _buildBusCard(busData);
            },
          );
        },
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
                  child: const Icon(
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
                      const Icon(
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
                      const Icon(
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
                const Icon(
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
