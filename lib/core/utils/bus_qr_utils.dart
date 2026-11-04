import 'dart:convert';

import '../constants/app_constants.dart';

class BusQrPayload {
  final String rawValue;
  final String? busId;
  final String? busNumber;

  const BusQrPayload({
    required this.rawValue,
    this.busId,
    this.busNumber,
  });

  String? get lookupKey => busId ?? busNumber;

  List<String> get primaryLookupCandidates {
    final primary = lookupKey;
    if (primary == null) return const [];

    final withoutPrefix = BusQrUtils.stripPrefix(primary);
    return {
      withoutPrefix,
      withoutPrefix.toUpperCase(),
      primary.trim(),
      primary.trim().toUpperCase(),
    }.where((value) => value.trim().isNotEmpty).toList();
  }

  List<String> get lookupCandidates {
    final candidates = <String>{
      rawValue.trim(),
      if (busId != null) busId!.trim(),
      if (busNumber != null) busNumber!.trim(),
    }..removeWhere((value) => value.isEmpty);

    return candidates
        .expand((candidate) {
          final withoutPrefix = BusQrUtils.stripPrefix(candidate);
          return {
            candidate,
            candidate.toUpperCase(),
            withoutPrefix,
            withoutPrefix.toUpperCase(),
            '${AppConstants.qrCodePrefix}$withoutPrefix',
            '${AppConstants.qrCodePrefix}${withoutPrefix.toUpperCase()}',
          };
        })
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList();
  }
}

class BusQrUtils {
  static BusQrPayload? parse(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;

    final jsonPayload = _parseJsonPayload(raw);
    if (jsonPayload != null) return jsonPayload;

    final uriPayload = _parseUriPayload(raw);
    if (uriPayload != null) return uriPayload;

    final id = stripPrefix(raw);
    if (id.length < 3) return null;

    return BusQrPayload(
      rawValue: raw,
      busId: id,
      busNumber: id,
    );
  }

  static String qrCodeForBusId(String busId) {
    return '${AppConstants.qrCodePrefix}${stripPrefix(busId.trim())}';
  }

  static String stripPrefix(String value) {
    final trimmed = value.trim();
    if (trimmed.toUpperCase().startsWith(AppConstants.qrCodePrefix)) {
      return trimmed.substring(AppConstants.qrCodePrefix.length).trim();
    }
    return trimmed;
  }

  static BusQrPayload? _parseJsonPayload(String raw) {
    if (!raw.startsWith('{')) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;

      final type = decoded['type']?.toString();
      final busId = decoded['busId']?.toString().trim();
      final busNumber = decoded['busNumber']?.toString().trim();

      if (type != null && !type.toLowerCase().contains('bus')) {
        return null;
      }

      if ((busId == null || busId.isEmpty) &&
          (busNumber == null || busNumber.isEmpty)) {
        return null;
      }

      return BusQrPayload(
        rawValue: raw,
        busId: busId?.isEmpty == true ? null : busId,
        busNumber: busNumber?.isEmpty == true ? null : busNumber,
      );
    } catch (_) {
      return null;
    }
  }

  static BusQrPayload? _parseUriPayload(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) return null;

    final busId = _firstNonEmpty([
      uri.queryParameters['busId'],
      uri.queryParameters['bus_id'],
      uri.queryParameters['vehicleId'],
      uri.queryParameters['vehicle_id'],
      uri.queryParameters['id'],
    ]);
    final busNumber = _firstNonEmpty([
      uri.queryParameters['busNumber'],
      uri.queryParameters['bus_number'],
      uri.queryParameters['busNumberPlate'],
      uri.queryParameters['bus_number_plate'],
      uri.queryParameters['plate'],
      uri.queryParameters['bus'],
    ]);

    if (busId != null || busNumber != null) {
      return BusQrPayload(
        rawValue: raw,
        busId: busId == null ? null : stripPrefix(busId),
        busNumber: busNumber == null ? null : stripPrefix(busNumber),
      );
    }

    final segments = uri.pathSegments
        .map(Uri.decodeComponent)
        .where((segment) => segment.trim().isNotEmpty)
        .toList();
    if (segments.isEmpty) return null;

    String? candidate;
    final lowerHost = uri.host.toLowerCase();
    if (lowerHost == 'bus' || lowerHost == 'vehicle') {
      candidate = segments.first;
    } else {
      for (var i = 0; i < segments.length - 1; i++) {
        final segment = segments[i].toLowerCase();
        if (segment == 'bus' ||
            segment == 'buses' ||
            segment == 'vehicle' ||
            segment == 'vehicles') {
          candidate = segments[i + 1];
          break;
        }
      }
    }

    if (candidate == null || candidate.trim().length < 3) return null;
    final id = stripPrefix(candidate);
    return BusQrPayload(
      rawValue: raw,
      busId: id,
      busNumber: id,
    );
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
  }
}
