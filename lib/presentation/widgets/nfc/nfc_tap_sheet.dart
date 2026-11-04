import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/bus_qr_utils.dart';
import '../../../core/utils/theme_helper.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/qr_controller.dart';

Future<void> showNfcTapSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NfcTapSheet(),
  );
}

class _NfcTapSheet extends ConsumerStatefulWidget {
  const _NfcTapSheet();

  @override
  ConsumerState<_NfcTapSheet> createState() => _NfcTapSheetState();
}

class _NfcTapSheetState extends ConsumerState<_NfcTapSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _isProcessing = false;
  String _status = 'Checking NFC availability...';

  static const Map<int, String> _uriPrefixes = {
    0x00: '',
    0x01: 'http://www.',
    0x02: 'https://www.',
    0x03: 'http://',
    0x04: 'https://',
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
      lowerBound: 0.94,
      upperBound: 1.06,
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  Future<void> _startSession() async {
    try {
      final available = await NfcManager.instance.isAvailable();
      if (!mounted) return;

      if (!available) {
        setState(() => _status = 'NFC is not available on this device.');
        return;
      }

      setState(() => _status = 'Hold your phone near the bus NFC tag.');

      await NfcManager.instance.startSession(
        pollingOptions: const {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        alertMessageIos: 'Hold your phone near the bus NFC tag.',
        onDiscovered: (tag) => unawaited(_handleTag(tag)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = _friendlyNfcError(e));
    }
  }

  Future<void> _handleTag(NfcTag tag) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _status = 'Tag detected. Starting journey...';
    });

    try {
      final payload = await _readBusPayload(tag);
      if (payload == null || BusQrUtils.parse(payload) == null) {
        await _stopSession(errorMessage: 'Invalid SafeDriver bus tag.');
        if (!mounted) return;
        setState(() {
          _isProcessing = false;
          _status = 'Invalid NFC tag. Please tap a SafeDriver bus tag.';
        });
        return;
      }

      final bus =
          await ref.read(qrControllerProvider.notifier).validateQrCode(payload);

      if (!mounted) return;

      if (bus == null) {
        await _stopSession(errorMessage: 'Bus not found.');
        final error = ref.read(qrControllerProvider).error ??
            'Bus not found. Check the NFC tag and try again.';
        setState(() {
          _isProcessing = false;
          _status = error;
        });
        return;
      }

      ref.read(dashboardControllerProvider.notifier)
        ..updateActiveJourney(bus)
        ..addRecentActivity('Started journey on Bus ${bus.busNumber}');

      await _stopSession(alertMessage: 'Journey started.');
      HapticFeedback.mediumImpact();

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Bus ${bus.busNumber} selected'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (e) {
      await _stopSession(errorMessage: 'Unable to read NFC tag.');
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _status = _friendlyNfcError(e);
      });
    }
  }

  String _friendlyNfcError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('not_supported') ||
        message.contains('not supported') ||
        message.contains('unsupported')) {
      return 'NFC is not supported on this device.';
    }
    if (message.contains('disabled') || message.contains('off')) {
      return 'Please turn on NFC in your device settings and try again.';
    }
    if (message.contains('session_already_exists')) {
      return 'NFC is already active. Please try again.';
    }
    return 'Unable to read NFC right now. Please try again.';
  }

  Future<String?> _readBusPayload(NfcTag tag) async {
    final message = await _readNdefMessage(tag);
    if (message == null || message.records.isEmpty) return null;

    final decodedRecords = message.records
        .map(_decodeRecord)
        .whereType<String>()
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    for (final value in decodedRecords) {
      if (BusQrUtils.parse(value) != null) return value;
    }

    return decodedRecords.isEmpty ? null : decodedRecords.first;
  }

  Future<NdefMessage?> _readNdefMessage(NfcTag tag) async {
    final androidNdef = NdefAndroid.from(tag);
    if (androidNdef != null) {
      return androidNdef.cachedNdefMessage ??
          await androidNdef.getNdefMessage();
    }

    final iosNdef = NdefIos.from(tag);
    if (iosNdef != null) {
      return iosNdef.cachedNdefMessage ?? await iosNdef.readNdef();
    }

    return null;
  }

  String? _decodeRecord(NdefRecord record) {
    if (record.typeNameFormat == TypeNameFormat.wellKnown) {
      final type = ascii.decode(record.type, allowInvalid: true);
      if (type == 'T') return _decodeTextPayload(record.payload);
      if (type == 'U') return _decodeUriPayload(record.payload);
    }

    if (record.typeNameFormat == TypeNameFormat.absoluteUri) {
      return ascii.decode(record.type, allowInvalid: true);
    }

    final mediaType = ascii.decode(record.type, allowInvalid: true);
    if (mediaType.toLowerCase().startsWith('text/')) {
      return utf8.decode(record.payload, allowMalformed: true);
    }

    return null;
  }

  String? _decodeTextPayload(Uint8List payload) {
    if (payload.isEmpty) return null;
    final textStart = 1 + (payload.first & 0x3F);
    if (payload.length <= textStart) return null;
    return utf8.decode(payload.sublist(textStart), allowMalformed: true);
  }

  String? _decodeUriPayload(Uint8List payload) {
    if (payload.isEmpty) return null;
    final prefix = _uriPrefixes[payload.first] ?? '';
    final body = utf8.decode(payload.sublist(1), allowMalformed: true);
    return '$prefix$body';
  }

  Future<void> _stopSession({
    String? alertMessage,
    String? errorMessage,
  }) async {
    try {
      await NfcManager.instance.stopSession(
        alertMessageIos: alertMessage,
        errorMessageIos: errorMessage,
      );
    } catch (_) {
      // The platform may already have closed the NFC session.
    }
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDesign.spaceXL),
          decoration: BoxDecoration(
            color: th.cardBackground,
            borderRadius: BorderRadius.circular(AppDesign.radiusXL),
            border: Border.all(color: th.border),
            boxShadow: [
              BoxShadow(
                color: th.shadowMedium,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: th.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _stopSession();
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: th.textSecondary,
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: AppDesign.spaceXL),
              ScaleTransition(
                scale: _pulseController,
                child: Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isProcessing ? Icons.sync_rounded : Icons.nfc_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: AppDesign.spaceXL),
              Text(
                'Tap Bus NFC Tag',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: th.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppDesign.spaceSM),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: th.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppDesign.spaceLG),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    unawaited(_stopSession());
    super.dispose();
  }
}
