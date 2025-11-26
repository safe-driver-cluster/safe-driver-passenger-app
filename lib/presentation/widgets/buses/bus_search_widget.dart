import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class BusSearchWidget extends StatefulWidget {
  const BusSearchWidget({super.key});

  @override
  State<BusSearchWidget> createState() => _BusSearchWidgetState();
}

class _BusSearchWidgetState extends State<BusSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _buildBusList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceXS),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: Colors.white,
              size: AppDesign.iconLG,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Your Bus',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Search and track buses in real-time',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        0,
        AppDesign.spaceLG,
        AppDesign.spaceMD,
      ),
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: 'Search by route number, destination...',
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
            vertical: AppDesign.spaceMD,
            horizontal: AppDesign.spaceLG,
          ),
        ),
      ),
    );
  }

  Widget _buildBusList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('vehicles')
          .where('isActive', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.errorColor,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                const Text(
                  'Unable to load buses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_bus_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDesign.spaceMD),
                Text(
                  'No buses available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Check back later for bus updates',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // Filter buses based on search query
        final buses = snapshot.data!.docs.where((doc) {
          if (_searchQuery.isEmpty) return true;

          final data = doc.data() as Map<String, dynamic>;
          final routeNumber =
              (data['routeNumber'] ?? '').toString().toLowerCase();
          final destination =
              (data['destination'] ?? '').toString().toLowerCase();
          final driverName =
              (data['driverName'] ?? '').toString().toLowerCase();

          return routeNumber.contains(_searchQuery) ||
              destination.contains(_searchQuery) ||
              driverName.contains(_searchQuery);
        }).toList();

        if (buses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDesign.spaceMD),
                Text(
                  'No buses found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDesign.spaceXS),
                Text(
                  'Try different search terms',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          itemCount: buses.length,
          itemBuilder: (context, index) {
            final busDoc = buses[index];
            final busData = busDoc.data() as Map<String, dynamic>;
            return _buildBusCard(busData, busDoc.id);
          },
        );
      },
    );
  }

  Widget _buildBusCard(Map<String, dynamic> busData, String busId) {
    final routeNumber = busData['routeNumber'] ?? 'Unknown';
    final destination = busData['destination'] ?? 'Unknown Destination';
    final driverName = busData['driverName'] ?? 'Unknown Driver';
    final capacity = busData['capacity'] ?? 0;
    final currentPassengers = busData['currentPassengers'] ?? 0;
    final isActive = busData['isActive'] ?? false;

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
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/buses');
        },
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        child: Padding(
          padding: const EdgeInsets.all(AppDesign.spaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDesign.spaceSM),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                    ),
                    child: Icon(
                      Icons.directions_bus,
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
                      size: AppDesign.iconMD,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Route $routeNumber',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDesign.spaceSM,
                                vertical: AppDesign.spaceXS,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.successColor.withOpacity(0.1)
                                    : AppColors.errorColor.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radiusSM),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isActive
                                      ? AppColors.successColor
                                      : AppColors.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDesign.spaceXS),
                        Text(
                          destination,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDesign.spaceMD),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: AppDesign.iconSM,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDesign.spaceXS),
                  Text(
                    driverName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.people_outline,
                    size: AppDesign.iconSM,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDesign.spaceXS),
                  Text(
                    '$currentPassengers/$capacity',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
