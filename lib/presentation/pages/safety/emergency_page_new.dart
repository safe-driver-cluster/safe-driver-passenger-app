import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../widgets/common/professional_widgets.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          // Professional Emergency Header
          _buildEmergencyHeader(context),

          // Emergency Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Column(
                children: [
                  // Emergency Contacts
                  _buildEmergencyContactsSection(),

                  const SizedBox(height: AppDesign.space2XL),

                  // Quick Actions
                  _buildQuickActionsSection(),

                  const SizedBox(height: AppDesign.space2XL),

                  // Safety Tips
                  _buildSafetyTipsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDesign.spaceLG,
        60,
        AppDesign.spaceLG,
        AppDesign.space2XL,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dangerColor,
            AppColors.criticalColor,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDesign.space2XL),
          bottomRight: Radius.circular(AppDesign.space2XL),
        ),
      ),
      child: Column(
        children: [
          // Header with back button
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: AppDesign.iconMD,
                  ),
                ),
              ),

              const SizedBox(width: AppDesign.spaceLG),

              Expanded(
                child: Text(
                  'Emergency',
                  style: AppTextStyles.headline3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Emergency indicator
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: AppDesign.iconLG,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDesign.space2XL),

          // Emergency message
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceLG),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusXL),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_rounded,
                  color: Colors.white,
                  size: AppDesign.iconMD,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Text(
                    'Tap any contact below for immediate assistance',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
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

  Widget _buildEmergencyContactsSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.phone_enabled_rounded,
                  color: AppColors.dangerColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                'Emergency Contacts',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ..._buildEmergencyContacts(),
        ],
      ),
    );
  }

  List<Widget> _buildEmergencyContacts() {
    final contacts = [
      EmergencyContact(
        'Police Emergency',
        '999',
        Icons.local_police_rounded,
        AppColors.dangerColor,
        'Call for immediate police assistance',
      ),
      EmergencyContact(
        'Ambulance',
        '995',
        Icons.local_hospital_rounded,
        AppColors.criticalColor,
        'Medical emergency services',
      ),
      EmergencyContact(
        'Fire Department',
        '998',
        Icons.fire_truck_rounded,
        AppColors.warningColor,
        'Fire and rescue services',
      ),
      EmergencyContact(
        'Bus Emergency Hotline',
        '1800-BUS-HELP',
        Icons.directions_bus_rounded,
        AppColors.primaryColor,
        'Bus-related emergencies',
      ),
    ];

    return contacts.asMap().entries.map((entry) {
      final index = entry.key;
      final contact = entry.value;

      return Column(
        children: [
          _buildEmergencyContactTile(contact),
          if (index < contacts.length - 1)
            const SizedBox(height: AppDesign.spaceMD),
        ],
      );
    }).toList();
  }

  Widget _buildEmergencyContactTile(EmergencyContact contact) {
    return Container(
      decoration: BoxDecoration(
        color: contact.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: contact.color.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDesign.spaceMD),
        leading: Container(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: contact.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Icon(
            contact.icon,
            color: contact.color,
            size: AppDesign.iconMD,
          ),
        ),
        title: Text(
          contact.title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              contact.number,
              style: AppTextStyles.headline6.copyWith(
                color: contact.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              contact.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: contact.color,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            boxShadow: [
              BoxShadow(
                color: contact.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _makeCall(contact.number),
            icon: const Icon(
              Icons.phone_rounded,
              color: Colors.white,
              size: AppDesign.iconSM,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  color: AppColors.accentColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                'Quick Actions',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'SOS Alert',
                  Icons.sos_rounded,
                  AppColors.dangerColor,
                  () => _sendSOSAlert(),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildQuickActionButton(
                  'Share Location',
                  Icons.my_location_rounded,
                  AppColors.primaryColor,
                  () => _shareLocation(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Report Incident',
                  Icons.report_rounded,
                  AppColors.warningColor,
                  () => _reportIncident(),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildQuickActionButton(
                  'Emergency Contacts',
                  Icons.contacts_rounded,
                  AppColors.successColor,
                  () => _viewEmergencyContacts(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: AppDesign.iconLG,
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTipsSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.tips_and_updates_rounded,
                  color: AppColors.successColor,
                  size: AppDesign.iconMD,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                'Emergency Safety Tips',
                style: AppTextStyles.headline6.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),
          ..._buildSafetyTips(),
        ],
      ),
    );
  }

  List<Widget> _buildSafetyTips() {
    final tips = [
      'Stay calm and assess the situation',
      'Call the appropriate emergency service',
      'Provide clear location information',
      'Follow instructions from authorities',
      'Keep your phone charged for emergencies',
      'Share your location with trusted contacts',
    ];

    return tips
        .map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppDesign.spaceMD),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.successColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Future<void> _makeCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendSOSAlert() {
    // Implement SOS alert functionality
  }

  void _shareLocation() {
    // Implement location sharing functionality
  }

  void _reportIncident() {
    // Implement incident reporting functionality
  }

  void _viewEmergencyContacts() {
    // Implement emergency contacts view
  }
}

class EmergencyContact {
  final String title;
  final String number;
  final IconData icon;
  final Color color;
  final String description;

  EmergencyContact(
    this.title,
    this.number,
    this.icon,
    this.color,
    this.description,
  );
}
