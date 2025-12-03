import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import '../../../core/constants/color_constants.dart';

class SafetyTipsPage extends StatelessWidget {
  const SafetyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).safetyTipsTitle),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Safety Tips Page - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
