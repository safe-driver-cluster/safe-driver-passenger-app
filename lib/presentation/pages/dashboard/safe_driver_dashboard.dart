import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../bus/live_tracking_page.dart';
import '../driver/driver_info_page.dart';
import '../hazard/hazard_zone_intelligence_page.dart';
import '../qr/qr_scanner_page.dart';

class SafeDriverDashboard extends ConsumerWidget {
  const SafeDriverDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SafeDriver',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to SafeDriver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your comprehensive bus safety monitoring platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Main Features Section
            const Text(
              'Main Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Features Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  context,
                  'QR Scanner',
                  'Scan bus QR codes to get instant information',
                  Icons.qr_code_scanner,
                  AppColors.primaryColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrScannerPage(),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  'Live Tracking',
                  'Real-time bus location tracking with maps',
                  Icons.location_on,
                  AppColors.successColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiveTrackingPage(
                        busId: 'demo-bus-001', // Demo bus ID
                      ),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  'Driver Info',
                  'Detailed driver information and performance',
                  Icons.person,
                  AppColors.warningColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DriverInfoPage(
                        driverId: 'demo-driver-001', // Demo driver ID
                        driverName: 'John Doe',
                      ),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  'Hazard Zones',
                  'Monitor dangerous areas and safety alerts',
                  Icons.warning,
                  AppColors.errorColor,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HazardZoneIntelligencePage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Quick Stats Section
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Active Buses',
                    '12',
                    Icons.directions_bus,
                    AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Safety Score',
                    '94%',
                    Icons.shield,
                    AppColors.successColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Drivers',
                    '8',
                    Icons.group,
                    AppColors.warningColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Hazard Zones',
                    '3',
                    Icons.warning_amber,
                    AppColors.errorColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Activity Section
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildActivityItem(
                      'Bus QR code scanned',
                      '2 minutes ago',
                      Icons.qr_code_scanner,
                      AppColors.primaryColor,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      'Safety alert acknowledged',
                      '15 minutes ago',
                      Icons.check_circle,
                      AppColors.successColor,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      'New hazard zone reported',
                      '1 hour ago',
                      Icons.warning,
                      AppColors.warningColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textSecondary,
      ),
    );
  }
}
