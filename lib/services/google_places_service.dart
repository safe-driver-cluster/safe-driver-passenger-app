import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/config/google_api.dart';

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
    final structuredFormatting = json['structured_formatting'] as Map<String, dynamic>?;
    return Prediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
      mainText: structuredFormatting?['main_text'] as String?,
      secondaryText: structuredFormatting?['secondary_text'] as String?,
    );
  }
}

/// Represents a nearby place returned by Google Nearby Search.
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

/// A single transit step from the Directions API response.
class TransitStep {
  final String instructions;
  final String travelMode;
  final LatLng startLocation;
  final LatLng endLocation;
  final String duration;
  final String distance;
  final int durationSeconds;
  final int distanceMeters;
  final String polyline; // encoded polyline for this step

  // Transit-specific fields (only set when travelMode == 'TRANSIT')
  final String? lineName;       // e.g. "138"
  final String? lineShortName;  // e.g. "138"
  final String? vehicleType;    // e.g. "BUS"
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
    required this.durationSeconds,
    required this.distanceMeters,
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

    String? lineName;
    String? lineShortName;
    String? vehicleType;
    String? departureStop;
    String? arrivalStop;
    String? departureTime;
    String? arrivalTime;
    int? numStops;

    final transitDetails = json['transit_details'] as Map<String, dynamic>?;
    if (transitDetails != null) {
      final line = transitDetails['line'] as Map<String, dynamic>?;
      if (line != null) {
        lineName = line['name'] as String?;
        lineShortName = line['short_name'] as String?;
        final vehicle = line['vehicle'] as Map<String, dynamic>?;
        vehicleType = vehicle?['type'] as String?;
      }
      departureStop =
          (transitDetails['departure_stop'] as Map<String, dynamic>?)?['name']
              as String?;
      arrivalStop =
          (transitDetails['arrival_stop'] as Map<String, dynamic>?)?['name']
              as String?;
      departureTime =
          (transitDetails['departure_time'] as Map<String, dynamic>?)?['text']
              as String?;
      arrivalTime =
          (transitDetails['arrival_time'] as Map<String, dynamic>?)?['text']
              as String?;
      numStops = transitDetails['num_stops'] as int?;
    }

    return TransitStep(
      instructions:
          (json['html_instructions'] as String?)?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '',
      travelMode: json['travel_mode'] as String? ?? 'UNKNOWN',
      startLocation: LatLng(
        (startLoc['lat'] as num).toDouble(),
        (startLoc['lng'] as num).toDouble(),
      ),
      endLocation: LatLng(
        (endLoc['lat'] as num).toDouble(),
        (endLoc['lng'] as num).toDouble(),
      ),
      duration: (json['duration'] as Map<String, dynamic>?)?['text'] as String? ?? '',
      distance: (json['distance'] as Map<String, dynamic>?)?['text'] as String? ?? '',
      durationSeconds:
          (json['duration'] as Map<String, dynamic>?)?['value'] as int? ?? 0,
      distanceMeters:
          (json['distance'] as Map<String, dynamic>?)?['value'] as int? ?? 0,
      polyline:
          (json['polyline'] as Map<String, dynamic>?)?['points'] as String? ?? '',
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

/// Full directions result.
class DirectionsResult {
  final String totalDuration;
  final String totalDistance;
  final int totalDurationSeconds;
  final int totalDistanceMeters;
  final String overviewPolyline;
  final List<TransitStep> steps;
  final LatLng startLocation;
  final LatLng endLocation;
  final String? departureTime;
  final String? arrivalTime;

  DirectionsResult({
    required this.totalDuration,
    required this.totalDistance,
    required this.totalDurationSeconds,
    required this.totalDistanceMeters,
    required this.overviewPolyline,
    required this.steps,
    required this.startLocation,
    required this.endLocation,
    this.departureTime,
    this.arrivalTime,
  });
}

class GooglePlacesService {
  final String _apiKey = GoogleMapsConfig.apiKey;

  // ──────────────── Autocomplete (locked to Sri Lanka) ────────────────

  Future<List<Prediction>> autocomplete(
    String input, {
    String? types,
    LatLng? locationBias,
    int? radiusMeters,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = {
      'input': input,
      'key': _apiKey,
      if (types != null) 'types': types,
      if (locationBias != null)
        'location': '${locationBias.latitude},${locationBias.longitude}',
      if (radiusMeters != null) 'radius': '$radiusMeters',
      'components': 'country:lk', // locked to Sri Lanka
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      params,
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Places autocomplete failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != null && status != 'OK' && status != 'ZERO_RESULTS') {
      throw Exception('Places API error: $status');
    }

    final predictions = (body['predictions'] as List<dynamic>?) ?? [];
    return predictions
        .map((p) => Prediction.fromJson(p as Map<String, dynamic>))
        .toList();
  }


  // ──────────────── Place Details ────────────────

  Future<LatLng> getPlaceLatLng(String placeId) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = {
      'place_id': placeId,
      'fields': 'geometry',
      'key': _apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      params,
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

    final location = (body['result'] as Map<String, dynamic>)['geometry']
        ['location'] as Map<String, dynamic>;
    final lat = (location['lat'] as num).toDouble();
    final lng = (location['lng'] as num).toDouble();
    return LatLng(lat, lng);
  }

  // ──────────────── Nearby Bus Stops ────────────────

  /// Finds bus stops near [lat],[lng] within [radiusMeters] (default 200m).
  Future<List<NearbyPlace>> nearbyBusStops(
    double lat,
    double lng, {
    int radiusMeters = 200,
  }) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = {
      'location': '$lat,$lng',
      'radius': '$radiusMeters',
      'type': 'bus_station',
      'key': _apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      params,
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

    final results = (body['results'] as List<dynamic>?) ?? [];
    return results
        .map((r) => NearbyPlace.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  // ──────────────── Directions (transit / bus) ────────────────

  /// Gets bus transit directions from [origin] to [destination].
  Future<DirectionsResult?> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': 'transit',
      'transit_mode': 'bus',
      'region': 'lk',
      'key': _apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      params,
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Directions API failed: ${res.statusCode}');
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;

    if (status == 'ZERO_RESULTS') return null;
    if (status != null && status != 'OK') {
      throw Exception('Directions API error: $status');
    }

    final routes = body['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return null;

    final route = routes.first as Map<String, dynamic>;
    final leg = (route['legs'] as List<dynamic>).first as Map<String, dynamic>;

    final overviewPolyline =
        (route['overview_polyline'] as Map<String, dynamic>)['points']
            as String;

    final steps = (leg['steps'] as List<dynamic>)
        .map((s) => TransitStep.fromJson(s as Map<String, dynamic>))
        .toList();

    final startLoc = leg['start_location'] as Map<String, dynamic>;
    final endLoc = leg['end_location'] as Map<String, dynamic>;

    return DirectionsResult(
      totalDuration: (leg['duration'] as Map<String, dynamic>)['text'] as String,
      totalDistance: (leg['distance'] as Map<String, dynamic>)['text'] as String,
      totalDurationSeconds:
          (leg['duration'] as Map<String, dynamic>)['value'] as int? ?? 0,
      totalDistanceMeters:
          (leg['distance'] as Map<String, dynamic>)['value'] as int? ?? 0,
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
    );
  }

  // ──────────────── Polyline Decoder ────────────────

  /// Decodes an encoded polyline string into a list of [LatLng].
  static List<LatLng> decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int b;
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
