import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import '../../../core/constants/color_constants.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).emergencyContactsTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Emergency Contacts Page - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
