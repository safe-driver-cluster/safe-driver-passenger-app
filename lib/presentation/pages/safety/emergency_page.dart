import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

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
              AppColors.dangerColor,
              AppColors.criticalColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildEmergencyContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Text(
                'Emergency',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Emergency message
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDesign.spaceLG),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDesign.spaceSM),
                    decoration: BoxDecoration(
                      color: AppColors.dangerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    ),
                    child: const Icon(
                      Icons.info_rounded,
                      color: AppColors.dangerColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  const Expanded(
                    child: Text(
                      'Tap any contact below for immediate assistance',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppDesign.spaceLG),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          children: [
            _buildEmergencyContactsSection(),
            const SizedBox(height: AppDesign.space2XL),
            _buildQuickActionsSection(context),
            const SizedBox(height: AppDesign.space2XL),
            _buildSafetyTipsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactsSection() {
    return Column(
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
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Text(
              'Emergency Contacts',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesign.spaceLG),
        ..._buildEmergencyContacts(),
      ],
    );
  }

  List<Widget> _buildEmergencyContacts() {
    final contacts = [
      EmergencyContact(
        'Police Emergency',
        '119',
        Icons.local_police_rounded,
        AppColors.dangerColor,
        'Call for immediate police assistance',
      ),
      EmergencyContact(
        'Ambulance',
        '1990',
        Icons.local_hospital_rounded,
        AppColors.criticalColor,
        'Medical emergency services',
      ),
      EmergencyContact(
        'Fire Department',
        '110',
        Icons.fire_truck_rounded,
        AppColors.warningColor,
        'Fire and rescue services',
      ),
      EmergencyContact(
        'SLTB General Hotline. ',
        '1958',
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
            size: 20,
          ),
        ),
        title: Text(
          contact.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              contact.number,
              style: TextStyle(
                color: contact.color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              contact.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
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
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
                      color: AppColors.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    ),
                    child: const Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppDesign.spaceMD),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
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
                      () => _shareLocation(context),
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
                      () => _viewEmergencyContacts(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildQuickActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTipsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                    color: AppColors.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                  ),
                  child: const Icon(
                    Icons.tips_and_updates_rounded,
                    color: AppColors.successColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceMD),
                const Text(
                  'Emergency Safety Tips',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDesign.spaceLG),
            ..._buildSafetyTips(),
          ],
        ),
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
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
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

  void _sendSOSAlert() async {
    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      String locationUrl = 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
      
      // Create SOS message
      String sosMessage = '🆘 EMERGENCY SOS ALERT!\n'
          'I need immediate help!\n'
          'My location: $locationUrl\n'
          'Time: ${DateTime.now().toString()}';
      
      // Share SOS message
      await Share.share(
        sosMessage,
        subject: '🆘 Emergency SOS Alert',
      );
    } catch (e) {
      // If location access fails, send SOS without location
      String sosMessage = '🆘 EMERGENCY SOS ALERT!\n'
          'I need immediate help!\n'
          'Time: ${DateTime.now().toString()}';
      
      await Share.share(
        sosMessage,
        subject: '🆘 Emergency SOS Alert',
      );
    }
  }

  void _shareLocation(BuildContext context) async {
    try {
      // Request location permission if not granted
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission is required to share location'),
                backgroundColor: AppColors.dangerColor,
              ),
            );
          }
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is permanently denied. Please enable it from settings.'),
              backgroundColor: AppColors.dangerColor,
            ),
          );
        }
        return;
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Create Google Maps link
      String locationUrl = 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
      
      // Create share message
      String shareMessage = '📍 My Current Location\n'
          'Latitude: ${position.latitude}\n'
          'Longitude: ${position.longitude}\n'
          'View on map: $locationUrl';
      
      // Share location
      await Share.share(
        shareMessage,
        subject: '📍 My Current Location',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }

  void _reportIncident() {
    // Implement incident reporting functionality
  }

  void _viewEmergencyContacts(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? emergencyNumber = prefs.getString('emergency_contact_number');
      
      if (emergencyNumber == null || emergencyNumber.isEmpty) {
        // Show dialog to set emergency contact
        if (context.mounted) {
          _showSetEmergencyContactDialog(context);
        }
      } else {
        // Call the emergency contact
        _makeCall(emergencyNumber);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
          ),
        );
      }
    }
  }
  
  void _showSetEmergencyContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.warningColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.contacts_rounded,
                  color: AppColors.warningColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Text(
                'Emergency Contact',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'You haven\'t set an emergency contact yet. Would you like to go to your profile to add one?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToProfile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: const Text(
                'Yes, Go to Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _navigateToProfile(BuildContext context) {
    // Navigate to profile/edit profile page
    Navigator.pushNamed(context, '/profile');
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
