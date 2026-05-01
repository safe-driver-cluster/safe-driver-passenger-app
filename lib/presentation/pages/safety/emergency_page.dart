import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safedriver_passenger_app/core/services/sos_service.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';
import 'package:safedriver_passenger_app/presentation/widgets/sos/sos_contacts_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final SosService _sosService = SosService();
  bool _isSendingSos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: _isSendingSos
          ? _buildSosSendingOverlay(context)
          : Container(
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
                child: const CustomBackButton(
                  color: AppColors.white,
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
      (
        title: 'Police Emergency',
        number: '119',
        icon: Icons.local_police_rounded,
        color: AppColors.dangerColor,
        description: 'Call for immediate police assistance',
      ),
      (
        title: 'Ambulance',
        number: '1990',
        icon: Icons.local_hospital_rounded,
        color: AppColors.criticalColor,
        description: 'Medical emergency services',
      ),
      (
        title: 'Fire Department',
        number: '110',
        icon: Icons.fire_truck_rounded,
        color: AppColors.warningColor,
        description: 'Fire and rescue services',
      ),
      (
        title: 'SLTB General Hotline',
        number: '1958',
        icon: Icons.directions_bus_rounded,
        color: AppColors.primaryColor,
        description: 'Bus-related emergencies',
      ),
    ];

    return contacts.asMap().entries.map((entry) {
      final index = entry.key;
      final contact = entry.value;

      return Column(
        children: [
          _buildEmergencyContactTile(
            contact.title,
            contact.number,
            contact.icon,
            contact.color,
            contact.description,
          ),
          if (index < contacts.length - 1)
            const SizedBox(height: AppDesign.spaceMD),
        ],
      );
    }).toList();
  }

  Widget _buildEmergencyContactTile(
    String title,
    String number,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDesign.spaceMD),
        leading: Container(
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          title,
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
              number,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => _makeCall(number),
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
                      '🆘 SOS Alert',
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
                      'SOS Contacts',
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
    // First check if user has SOS contacts configured
    final contacts = await _sosService.getContacts();

    if (contacts.isEmpty) {
      if (mounted) {
        await showSosContactsDialog(context);
      }
      return;
    }

    // Show confirmation dialog before sending
    if (mounted) {
      final confirmed = await _showSosConfirmationDialog(context, contacts);
      if (confirmed != true) return;
    }

    setState(() => _isSendingSos = true);

    try {
      debugPrint('Emergency Page: Starting SOS alert...');
      final result = await _sosService.sendSosAlert();

      debugPrint('Emergency Page: SOS alert completed');
      debugPrint(
          'Emergency Page: Result - SMS: ${result.smsSent}/${result.totalContacts}, WhatsApp: ${result.whatsappLaunched}/${result.totalContacts}');

      if (mounted) {
        setState(() => _isSendingSos = false);

        // Show result dialog with detailed feedback
        _showSosResultDialog(result);

        // Also log the result for debugging
        if (result.isCompleteSuccess) {
          debugPrint('Emergency Page: SOS alert was completely successful');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ SOS Alert sent to all contacts'),
              backgroundColor: AppColors.successColor,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (result.isPartialSuccess) {
          debugPrint('Emergency Page: SOS alert had partial success');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠ SOS Alert partially sent: ${result.summary}'),
              backgroundColor: AppColors.warningColor,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          debugPrint('Emergency Page: SOS alert failed completely');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✗ SOS Alert failed: ${result.summary}'),
              backgroundColor: AppColors.dangerColor,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Emergency Page: Unexpected error during SOS: $e');
      if (mounted) {
        setState(() => _isSendingSos = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SOS Error: ${e.toString()}'),
            backgroundColor: AppColors.dangerColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<bool?> _showSosConfirmationDialog(
      BuildContext context, List<SosContact> contacts) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: const Icon(
                Icons.sos_rounded,
                color: AppColors.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Text(
              'Send SOS Alert?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will send your location and SOS message to:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            ...contacts.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDesign.spaceSM),
                  child: Row(
                    children: [
                      Icon(
                        c.sendSms ? Icons.sms_rounded : Icons.chat_rounded,
                        size: 16,
                        color: c.sendSms
                            ? AppColors.primaryColor
                            : AppColors.successColor,
                      ),
                      const SizedBox(width: AppDesign.spaceSM),
                      Text(
                        '${c.name} (${c.phoneNumber})',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
            ),
            child: const Text('🆘 Send SOS'),
          ),
        ],
      ),
    );
  }

  void _showSosResultDialog(SosAlertResult result) {
    final isSuccess = result.isPartialSuccess;
    final isCompleteSuccess = result.isCompleteSuccess;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: isCompleteSuccess
                    ? AppColors.successColor.withOpacity(0.1)
                    : isSuccess
                        ? AppColors.warningColor.withOpacity(0.1)
                        : AppColors.dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: Icon(
                isCompleteSuccess
                    ? Icons.check_circle_rounded
                    : isSuccess
                        ? Icons.warning_amber_rounded
                        : Icons.error_rounded,
                color: isCompleteSuccess
                    ? AppColors.successColor
                    : isSuccess
                        ? AppColors.warningColor
                        : AppColors.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Expanded(
              child: Text(
                isCompleteSuccess
                    ? 'SOS Alert Sent Successfully!'
                    : isSuccess
                        ? 'SOS Partially Sent'
                        : 'SOS Alert Failed',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main status message
              Text(
                result.summary,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppDesign.spaceMD),

              // Detailed breakdown
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                  border: Border.all(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusRow('SMS Sent', result.smsSent,
                        result.totalContacts, AppColors.successColor),
                    if (result.smsFailed > 0)
                      _buildStatusRow('SMS Failed', result.smsFailed,
                          result.totalContacts, AppColors.dangerColor),
                    if (result.whatsappLaunched > 0)
                      _buildStatusRow('WhatsApp Sent', result.whatsappLaunched,
                          result.totalContacts, AppColors.successColor),
                    if (result.whatsappFailed > 0)
                      _buildStatusRow('WhatsApp Failed', result.whatsappFailed,
                          result.totalContacts, AppColors.dangerColor),
                  ],
                ),
              ),

              // Errors section if any
              if (result.errors.isNotEmpty) ...[
                const SizedBox(height: AppDesign.spaceMD),
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.dangerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                    border: Border.all(
                      color: AppColors.dangerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.dangerColor,
                            size: 18,
                          ),
                          SizedBox(width: AppDesign.spaceSM),
                          Text(
                            'Issues Encountered:',
                            style: TextStyle(
                              color: AppColors.dangerColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDesign.spaceSM),
                      ...result.errors.map((e) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDesign.spaceXS),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],

              // Recommendation
              if (!isCompleteSuccess) ...[
                const SizedBox(height: AppDesign.spaceMD),
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDesign.radiusMD),
                    border: Border.all(
                      color: AppColors.accentColor.withOpacity(0.2),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            color: AppColors.accentColor,
                            size: 18,
                          ),
                          SizedBox(width: AppDesign.spaceSM),
                          Text(
                            'What to do next:',
                            style: TextStyle(
                              color: AppColors.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDesign.spaceSM),
                      Text(
                        '1. Manually call your emergency contacts\n2. Call police emergency: 119\n3. Check SMS settings if SMS failed\n4. Verify contact numbers are correct',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (isSuccess)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleteSuccess
                  ? AppColors.successColor
                  : isSuccess
                      ? AppColors.warningColor
                      : AppColors.dangerColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
            ),
            child: Text(isSuccess ? '✓ OK' : 'Dismiss'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, int total, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceSM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                count > 0 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
                size: 16,
              ),
              const SizedBox(width: AppDesign.spaceXS),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesign.spaceMD,
              vertical: AppDesign.spaceXS,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSosSendingOverlay(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dangerColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing SOS icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 1000),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.sos_rounded,
                      color: AppColors.white,
                      size: 60,
                    ),
                  ),
                );
              },
              onEnd: () => setState(() {}),
            ),
            const SizedBox(height: AppDesign.space2XL),
            const Text(
              'Sending SOS Alert...',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDesign.spaceMD),
            Text(
              'Sending your location and emergency message to all contacts',
              style: TextStyle(
                color: AppColors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDesign.space2XL),
            const CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
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
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).locationPermissionRequired),
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
              content: Text(
                  'Location permission is permanently denied. Please enable it from settings.'),
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
      String locationUrl =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

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

  void _viewEmergencyContacts(BuildContext context) {
    showSosContactsDialog(context);
  }
}
