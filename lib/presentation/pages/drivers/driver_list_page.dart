import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class DriverListPage extends StatefulWidget {
  const DriverListPage({super.key});

  @override
  State<DriverListPage> createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
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
              
              // Driver list
              Expanded(
                child: _buildDriverList(),
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
                'Our Drivers',
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
                hintText: 'Search by name, license, route...',
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

  Widget _buildDriverList() {
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
          stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
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
                      'Error loading drivers',
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

            final drivers = snapshot.data?.docs ?? [];
            
            // Filter drivers based on search query
            final filteredDrivers = drivers.where((driver) {
              final data = driver.data() as Map<String, dynamic>;
              final name = (data['name'] ?? '').toString().toLowerCase();
              final licenseNumber = (data['licenseNumber'] ?? '').toString().toLowerCase();
              final route = (data['route'] ?? '').toString().toLowerCase();
              final busNumber = (data['busNumber'] ?? '').toString().toLowerCase();
              
              return name.contains(_searchQuery) ||
                     licenseNumber.contains(_searchQuery) ||
                     route.contains(_searchQuery) ||
                     busNumber.contains(_searchQuery);
            }).toList();

            if (filteredDrivers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: AppDesign.spaceMD),
                    Text(
                      _searchQuery.isEmpty ? 'No drivers found' : 'No matching drivers',
                      style: AppTextStyles.headline6.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDesign.spaceSM),
                    Text(
                      _searchQuery.isEmpty 
                          ? 'Driver data is being updated'
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
              itemCount: filteredDrivers.length,
              itemBuilder: (context, index) {
                final driverData = filteredDrivers[index].data() as Map<String, dynamic>;
                return _buildDriverCard(driverData);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driverData) {
    final name = driverData['name'] ?? 'Unknown Driver';
    final licenseNumber = driverData['licenseNumber'] ?? 'N/A';
    final route = driverData['route'] ?? 'No Route Assigned';
    final busNumber = driverData['busNumber'] ?? 'N/A';
    final experience = driverData['experience'] ?? 'N/A';
    final phone = driverData['phone'] ?? 'N/A';
    final email = driverData['email'] ?? 'N/A';
    final safetyScore = driverData['safetyScore'] ?? 0;
    final status = driverData['status'] ?? 'off_duty';
    final address = driverData['address'] ?? 'Address not available';
    final joinDate = driverData['joinDate'] ?? '';

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
            // Header with name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppDesign.radiusFull),
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'D',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                              name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'License: $licenseNumber',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                    border: Border.all(
                      color: _getStatusColor(status).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getStatusText(status),
                        style: TextStyle(
                          color: _getStatusColor(status),
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
            
            // Route and bus information
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesign.spaceSM,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDesign.radiusSM),
                  ),
                  child: Text(
                    busNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesign.spaceMD),
            
            // Driver details
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.work_rounded,
                    label: 'Experience',
                    value: experience,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.security_rounded,
                    label: 'Safety Score',
                    value: '$safetyScore%',
                    valueColor: _getSafetyColor(safetyScore),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppDesign.spaceSM),
            
            // Contact information
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: phone,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: email,
                  ),
                ),
              ],
            ),
            
            if (joinDate.isNotEmpty) ...[
              const SizedBox(height: AppDesign.spaceSM),
              _buildInfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Joined',
                value: joinDate,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDesign.spaceXS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on_duty':
        return AppColors.successColor;
      case 'off_duty':
        return AppColors.textSecondary;
      case 'break':
        return AppColors.warningColor;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'on_duty':
        return 'On Duty';
      case 'off_duty':
        return 'Off Duty';
      case 'break':
        return 'On Break';
      default:
        return 'Unknown';
    }
  }

  Color _getSafetyColor(int score) {
    if (score >= 90) return AppColors.successColor;
    if (score >= 70) return AppColors.warningColor;
    return AppColors.errorColor;
  }
}