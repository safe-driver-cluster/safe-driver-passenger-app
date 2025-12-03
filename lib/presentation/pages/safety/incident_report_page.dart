import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import '../../../core/constants/color_constants.dart';

class IncidentReportPage extends StatelessWidget {
  final String? busId;
  final String? driverId;
  final String? tripId;

  const IncidentReportPage({super.key, this.busId, this.driverId, this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).reportIncidentTitle),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Incident Report Page - Coming Soon',
              style: TextStyle(fontSize: 18),
            ),
            if (busId != null) ...[
              const SizedBox(height: 8),
              Text('Bus ID: $busId'),
            ],
            if (driverId != null) ...[
              const SizedBox(height: 8),
              Text('Driver ID: $driverId'),
            ],
            if (tripId != null) ...[
              const SizedBox(height: 8),
              Text('Trip ID: $tripId'),
            ],
          ],
        ),
      ),
    );
  }
}
