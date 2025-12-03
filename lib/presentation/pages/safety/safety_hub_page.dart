import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

import '../../../core/constants/color_constants.dart';

class SafetyHubPage extends StatelessWidget {
  const SafetyHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).safetyHub),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red[400]!,
                    Colors.red[600]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).safetyFirst,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).safetyDescription,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Emergency Section
            Text(
              AppLocalizations.of(context).emergencyActions,
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
                  child: _buildEmergencyCard(
                    context,
                    icon: Icons.warning,
                    title: AppLocalizations.of(context).emergency,
                    subtitle: AppLocalizations.of(context).callForHelp,
                    color: Colors.red,
                    onTap: () {
                      Navigator.pushNamed(context, '/emergency');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildEmergencyCard(
                    context,
                    icon: Icons.report_problem,
                    title: AppLocalizations.of(context).reportIssue,
                    subtitle: AppLocalizations.of(context).reportIncident,
                    color: Colors.orange,
                    onTap: () {
                      _showReportDialog(context);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Safety Features
            Text(
              AppLocalizations.of(context).safetyFeatures,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            _buildFeatureCard(
              context,
              icon: Icons.notifications_active,
              title: AppLocalizations.of(context).safetyAlerts,
              subtitle: AppLocalizations.of(context).realTimeSafetyNotifications,
              onTap: () {
                Navigator.pushNamed(context, '/safety-alerts');
              },
            ),

            const SizedBox(height: 12),

            _buildFeatureCard(
              context,
              icon: Icons.dangerous,
              title: AppLocalizations.of(context).hazardZones,
              subtitle: AppLocalizations.of(context).viewKnownHazardousAreas,
              onTap: () {
                Navigator.pushNamed(context, '/hazard-zones');
              },
            ),

            const SizedBox(height: 12),

            _buildFeatureCard(
              context,
              icon: Icons.info_outline,
              title: AppLocalizations.of(context).safetyTips,
              subtitle: AppLocalizations.of(context).learnSafetyBestPractices,
              onTap: () {
                _showSafetyTipsDialog(context);
              },
            ),

            const SizedBox(height: 32),

            // Contact Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).emergencyContacts,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.local_police, AppLocalizations.of(context).police, '911'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.local_hospital, AppLocalizations.of(context).medical, '911'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.local_fire_department, AppLocalizations.of(context).fire, '911'),
                  const SizedBox(height: 8),
                  _buildContactRow(
                      Icons.support_agent, AppLocalizations.of(context).support, '1-800-SAFE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String number) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          number,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).reportSafetyIssue),
        content: Text(
          AppLocalizations.of(context).reportSafetyDialogContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to incident report page when implemented
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .incidentReportingImplemented),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(AppLocalizations.of(context).report,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSafetyTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).safetyTipsTitle),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• Always wear your seatbelt',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              Text(
                '• Stay alert and aware of your surroundings',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              Text(
                '• Keep emergency contacts readily available',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              Text(
                '• Report any suspicious activity immediately',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              Text(
                '• Follow bus safety protocols and driver instructions',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: Text(AppLocalizations.of(context).gotIt,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
