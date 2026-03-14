import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/config/google_api.dart';

// ══════════════════════════════════════════════════════════════════════
// Data classes
// ══════════════════════════════════════════════════════════════════════

class Prediction {
  final String description;
  final String placeId;
  final String? mainText;
  final String? secondaryText;

  Prediction({
    required this.description,
    required this.placeId,
    this.mainText,
    this.secondaryText,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    final sf = json['structured_formatting'] as Map<String, dynamic>?;
    return Prediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
      mainText: sf?['main_text'] as String?,
      secondaryText: sf?['secondary_text'] as String?,
    );
  }
}

class NearbyPlace {
  final String name;
  final double lat;
  final double lng;
  final String placeId;
  final String vicinity;

  NearbyPlace({
    required this.name,
    required this.lat,
    required this.lng,
    required this.placeId,
    required this.vicinity,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    final loc = json['geometry']['location'] as Map<String, dynamic>;
    return NearbyPlace(
      name: json['name'] as String? ?? 'Bus Stop',
      lat: (loc['lat'] as num).toDouble(),
      lng: (loc['lng'] as num).toDouble(),
      placeId: json['place_id'] as String? ?? '',
      vicinity: json['vicinity'] as String? ?? '',
    );
  }
}

/// Travel mode for Directions API.
enum TravelMode { transit, driving, walking, bicycling }

/// A single step in a route leg.
class TransitStep {
  final String instructions;
  final String travelMode;
  final LatLng startLocation;
  final LatLng endLocation;
  final String duration;
  final String distance;
  final String polyline;

  // Transit-specific
  final String? lineName;
  final String? lineShortName;
  final String? vehicleType;
  final String? departureStop;
  final String? arrivalStop;
  final String? departureTime;
  final String? arrivalTime;
  final int? numStops;

  TransitStep({
    required this.instructions,
    required this.travelMode,
    required this.startLocation,
    required this.endLocation,
    required this.duration,
    required this.distance,
    required this.polyline,
    this.lineName,
    this.lineShortName,
    this.vehicleType,
    this.departureStop,
    this.arrivalStop,
    this.departureTime,
    this.arrivalTime,
    this.numStops,
  });

  factory TransitStep.fromJson(Map<String, dynamic> json) {
    final startLoc = json['start_location'] as Map<String, dynamic>;
    final endLoc = json['end_location'] as Map<String, dynamic>;

    String? lineName, lineShortName, vehicleType;
    String? departureStop, arrivalStop, departureTime, arrivalTime;
    int? numStops;

    final td = json['transit_details'] as Map<String, dynamic>?;
    if (td != null) {
      final line = td['line'] as Map<String, dynamic>?;
      if (line != null) {
        lineName = line['name'] as String?;
        lineShortName = line['short_name'] as String?;
        vehicleType =
            (line['vehicle'] as Map<String, dynamic>?)?['type'] as String?;
      }
      departureStop =
          (td['departure_stop'] as Map<String, dynamic>?)?['name'] as String?;
      arrivalStop =
          (td['arrival_stop'] as Map<String, dynamic>?)?['name'] as String?;
      departureTime =
          (td['departure_time'] as Map<String, dynamic>?)?['text'] as String?;
      arrivalTime =
          (td['arrival_time'] as Map<String, dynamic>?)?['text'] as String?;
      numStops = td['num_stops'] as int?;
    }

    return TransitStep(
      instructions: (json['html_instructions'] as String?)
              ?.replaceAll(RegExp(r'<[^>]*>'), '') ??
          '',
      travelMode: json['travel_mode'] as String? ?? 'UNKNOWN',
      startLocation: LatLng(
        (startLoc['lat'] as num).toDouble(),
        (startLoc['lng'] as num).toDouble(),
      ),
      endLocation: LatLng(
        (endLoc['lat'] as num).toDouble(),
        (endLoc['lng'] as num).toDouble(),
      ),
      duration:
          (json['duration'] as Map<String, dynamic>?)?['text'] as String? ?? '',
      distance:
          (json['distance'] as Map<String, dynamic>?)?['text'] as String? ?? '',
      polyline:
          (json['polyline'] as Map<String, dynamic>?)?['points'] as String? ??
              '',
      lineName: lineName,
      lineShortName: lineShortName,
      vehicleType: vehicleType,
      departureStop: departureStop,
      arrivalStop: arrivalStop,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      numStops: numStops,
    );
  }
}

/// Full directions result for one route alternative.
class DirectionsResult {
  final String totalDuration;
  final String totalDistance;
  final String overviewPolyline;
  final List<TransitStep> steps;
  final LatLng startLocation;
  final LatLng endLocation;
  final String? departureTime;
  final String? arrivalTime;
  final TravelMode mode;
  final int? durationSeconds; // raw seconds for sorting
  final String summary; // route summary text

  DirectionsResult({
    required this.totalDuration,
    required this.totalDistance,
    required this.overviewPolyline,
    required this.steps,
    required this.startLocation,
    required this.endLocation,
    this.departureTime,
    this.arrivalTime,
    this.mode = TravelMode.transit,
    this.durationSeconds,
    this.summary = '',
  });
}

// ══════════════════════════════════════════════════════════════════════
// Service
// ══════════════════════════════════════════════════════════════════════

class GooglePlacesService {
  final String _apiKey = GoogleMapsConfig.apiKey;

  // ──────────────── Autocomplete ────────────────

  Future<List<Prediction>> autocomplete(
    String input, {
    String? types,
    LatLng? location,
    int? radius,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = <String, String>{
      'input': input,
      'key': _apiKey,
      if (types != null) 'types': types,
      'components': 'country:lk',
    };

    if (location != null) {
      params['location'] = '${location.latitude},${location.longitude}';
      params['radius'] = '${radius ?? 50000}';
    }

    final uri = Uri.https(
        'maps.googleapis.com', '/maps/api/place/autocomplete/json', params);

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Places autocomplete failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != null && status != 'OK' && status != 'ZERO_RESULTS') {
      throw Exception('Places API error: $status');
    }

    return ((body['predictions'] as List<dynamic>?) ?? [])
        .map((p) => Prediction.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  // ──────────────── Place Details ────────────────

  Future<LatLng> getPlaceLatLng(String placeId) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {'place_id': placeId, 'fields': 'geometry', 'key': _apiKey},
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Place details failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != null && status != 'OK') {
      throw Exception('Place details API error: $status');
    }

    final loc = (body['result'] as Map<String, dynamic>)['geometry']
        ['location'] as Map<String, dynamic>;
    return LatLng(
        (loc['lat'] as num).toDouble(), (loc['lng'] as num).toDouble());
  }

  // ──────────────── Nearby Bus Stops ────────────────

  Future<List<NearbyPlace>> nearbyBusStops(
    double lat,
    double lng, {
    int radiusMeters = 500,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      {
        'location': '$lat,$lng',
        'radius': '$radiusMeters',
        'type': 'bus_station',
        'key': _apiKey,
      },
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Nearby search failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != null && status != 'OK' && status != 'ZERO_RESULTS') {
      throw Exception('Nearby search API error: $status');
    }

    return ((body['results'] as List<dynamic>?) ?? [])
        .map((r) => NearbyPlace.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  // ──────────────── Directions (any mode) ────────────────

  /// Get directions for a single [mode]. Set [alternatives] to request
  /// multiple route options.
  Future<List<DirectionsResult>> getDirections(
    LatLng origin,
    LatLng destination, {
    TravelMode mode = TravelMode.transit,
    bool alternatives = false,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final modeStr = mode.name; // transit | driving | walking | bicycling
    final params = <String, String>{
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': modeStr,
      'region': 'lk',
      'key': _apiKey,
      if (alternatives) 'alternatives': 'true',
    };

    if (mode == TravelMode.transit) {
      params['transit_mode'] = 'bus';
    }

    final uri = Uri.https(
        'maps.googleapis.com', '/maps/api/directions/json', params);

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Directions API failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status == 'ZERO_RESULTS') return [];
    if (status != null && status != 'OK') {
      throw Exception('Directions API error: $status');
    }

    final routes = body['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return [];

    return routes.map((r) => _parseRoute(r as Map<String, dynamic>, mode)).toList();
  }

  DirectionsResult _parseRoute(Map<String, dynamic> route, TravelMode mode) {
    final leg = (route['legs'] as List<dynamic>).first as Map<String, dynamic>;
    final overviewPolyline =
        (route['overview_polyline'] as Map<String, dynamic>)['points']
            as String;

    final steps = (leg['steps'] as List<dynamic>)
        .map((s) => TransitStep.fromJson(s as Map<String, dynamic>))
        .toList();

    final startLoc = leg['start_location'] as Map<String, dynamic>;
    final endLoc = leg['end_location'] as Map<String, dynamic>;
    final durationMap = leg['duration'] as Map<String, dynamic>;
    final distanceMap = leg['distance'] as Map<String, dynamic>;

    return DirectionsResult(
      totalDuration: durationMap['text'] as String,
      totalDistance: distanceMap['text'] as String,
      overviewPolyline: overviewPolyline,
      steps: steps,
      startLocation: LatLng(
        (startLoc['lat'] as num).toDouble(),
        (startLoc['lng'] as num).toDouble(),
      ),
      endLocation: LatLng(
        (endLoc['lat'] as num).toDouble(),
        (endLoc['lng'] as num).toDouble(),
      ),
      departureTime:
          (leg['departure_time'] as Map<String, dynamic>?)?['text'] as String?,
      arrivalTime:
          (leg['arrival_time'] as Map<String, dynamic>?)?['text'] as String?,
      mode: mode,
      durationSeconds: (durationMap['value'] as num?)?.toInt(),
      summary: route['summary'] as String? ?? '',
    );
  }

  /// Fetch directions for multiple modes at once and return all results
  /// sorted by duration (shortest first). Default transit mode is first
  /// if durations are equal.
  Future<List<DirectionsResult>> getMultiModeDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    final futures = [
      getDirections(origin, destination,
          mode: TravelMode.transit, alternatives: true),
      getDirections(origin, destination, mode: TravelMode.driving),
      getDirections(origin, destination, mode: TravelMode.walking),
    ];

    final results = await Future.wait(futures);
    final all = <DirectionsResult>[];
    for (final list in results) {
      all.addAll(list);
    }

    // Sort: shortest duration first, transit wins ties
    all.sort((a, b) {
      final da = a.durationSeconds ?? 999999;
      final db = b.durationSeconds ?? 999999;
      if (da != db) return da.compareTo(db);
      if (a.mode == TravelMode.transit) return -1;
      if (b.mode == TravelMode.transit) return 1;
      return 0;
    });

    return all;
  }

  // ──────────────── Polyline Decoder ────────────────

  static List<LatLng> decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
}
