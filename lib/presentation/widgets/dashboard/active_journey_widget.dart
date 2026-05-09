import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/bus_model.dart';
import '../../controllers/dashboard_controller.dart';
import '../../pages/maps/map_page.dart';
import '../nfc/nfc_tap_sheet.dart';

class ActiveJourneyWidget extends ConsumerWidget {
  const ActiveJourneyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final activeJourney = dashboardState.activeJourney;
    final th = ThemeHelper.of(context);

    return Container(
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: th.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: activeJourney != null
            ? _buildActiveJourneyContent(context, ref, activeJourney)
            : _buildNoActiveJourneyContent(context),
      ),
    );
  }

  Widget _buildActiveJourneyContent(
      BuildContext context, WidgetRef ref, BusModel activeJourney) {
    final th = ThemeHelper.of(context);
    final routeText = activeJourney.routeNumber.trim().isEmpty
        ? 'Route details unavailable'
        : 'Route ${activeJourney.routeNumber}';
    final driverText = activeJourney.driverName?.trim().isNotEmpty == true
        ? activeJourney.driverName!
        : 'Driver not assigned';
    final locationText = activeJourney.currentLocation?.displayString ??
        activeJourney.statusDisplay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.directions_bus,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bus ${activeJourney.busNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: th.textPrimary,
                    ),
                  ),
                  Text(
                    routeText,
                    style: TextStyle(
                      fontSize: 14,
                      color: th.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ACTIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.person, color: AppColors.primaryColor, size: 16),
            const SizedBox(width: 8),
            Text(
              'Active Driver:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: th.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          driverText,
          style: TextStyle(
            fontSize: 14,
            color: th.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 16),
            const SizedBox(width: 8),
            Text(
              'Current Location:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: th.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          locationText,
          style: TextStyle(
            fontSize: 14,
            color: th.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapPage()),
                  );
                },
                icon: const Icon(Icons.my_location, size: 18),
                label: Text(AppLocalizations.of(context).trackLive),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _shareBusDetails(
                      activeJourney, routeText, driverText, locationText);
                },
                icon: const Icon(Icons.share, size: 18),
                label: Text(AppLocalizations.of(context).share),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _EndJourneySlider(
            onConfirmed: () async {
              await ref
                  .read(dashboardControllerProvider.notifier)
                  .endActiveJourney(activeJourney);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Journey ended for Bus ${activeJourney.busNumber}'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _shareBusDetails(
    BusModel bus,
    String routeText,
    String driverText,
    String locationText,
  ) async {
    final message = '''
SafeDriver active journey
Bus: ${bus.busNumber}
$routeText
Driver: $driverText
Location: $locationText
Status: ${bus.statusDisplay}
''';

    await Share.share(message.trim(),
        subject: 'SafeDriver Bus ${bus.busNumber}');
  }

  Widget _buildNoActiveJourneyContent(BuildContext context) {
    final th = ThemeHelper.of(context);
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor.withOpacity(0.1),
                AppColors.primaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.directions_bus_outlined,
            size: 40,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No Active Journey',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: th.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Scan a QR code or search for a bus\nto start tracking your journey',
          style: TextStyle(
            fontSize: 14,
            color: th.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/qr-scanner');
                },
                icon: const Icon(Icons.qr_code_scanner, size: 20),
                label: Text(AppLocalizations.of(context).scanQR),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to search tab instead of pushing new page
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.search, size: 20),
                label: Text(AppLocalizations.of(context).search),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              showNfcTapSheet(context);
            },
            icon: const Icon(Icons.nfc_rounded, size: 20),
            label: const Text('Tap NFC to Start'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EndJourneySlider extends StatefulWidget {
  final Future<void> Function() onConfirmed;

  const _EndJourneySlider({required this.onConfirmed});

  @override
  State<_EndJourneySlider> createState() => _EndJourneySliderState();
}

class _EndJourneySliderState extends State<_EndJourneySlider> {
  double _dragValue = 0;
  bool _isEnding = false;

  Future<void> _confirm() async {
    if (_isEnding) return;

    setState(() => _isEnding = true);
    try {
      await widget.onConfirmed();
    } finally {
      if (mounted) {
        setState(() {
          _isEnding = false;
          _dragValue = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const knobSize = 52.0;
        const edgePadding = 3.0;
        final maxDrag = constraints.maxWidth > knobSize + edgePadding * 2
            ? constraints.maxWidth - knobSize - edgePadding * 2
            : 1.0;
        final knobLeft = edgePadding + (_dragValue * maxDrag);

        return GestureDetector(
          onHorizontalDragUpdate: _isEnding
              ? null
              : (details) {
                  setState(() {
                    _dragValue = (_dragValue + details.delta.dx / maxDrag)
                        .clamp(0.0, 1.0);
                  });
                },
          onHorizontalDragEnd: _isEnding
              ? null
              : (_) {
                  if (_dragValue > 0.72) {
                    _confirm();
                  } else {
                    setState(() => _dragValue = 0);
                  }
                },
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 66, right: 18),
                  child: Text(
                    _isEnding ? 'Ending journey...' : 'Slide to end journey',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  left: knobLeft,
                  child: Container(
                    width: knobSize,
                    height: knobSize,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _isEnding
                        ? const Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.arrow_forward,
                            color: Colors.green,
                            size: 30,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
