import 'dart:convert';
import 'dart:math' as math;

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
    final structuredFormatting =
        json['structured_formatting'] as Map<String, dynamic>?;
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
  final String? lineName; // e.g. "138"
  final String? lineShortName; // e.g. "138"
  final String? vehicleType; // e.g. "BUS"
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
      departureStop = (transitDetails['departure_stop']
          as Map<String, dynamic>?)?['name'] as String?;
      arrivalStop = (transitDetails['arrival_stop']
          as Map<String, dynamic>?)?['name'] as String?;
      departureTime = (transitDetails['departure_time']
          as Map<String, dynamic>?)?['text'] as String?;
      arrivalTime = (transitDetails['arrival_time']
          as Map<String, dynamic>?)?['text'] as String?;
      numStops = transitDetails['num_stops'] as int?;
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
      durationSeconds:
          (json['duration'] as Map<String, dynamic>?)?['value'] as int? ?? 0,
      distanceMeters:
          (json['distance'] as Map<String, dynamic>?)?['value'] as int? ?? 0,
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
  final bool isFallback;

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
    this.isFallback = false,
  });
}

class GooglePlacesService {
  final String _apiKey = GoogleMapsConfig.apiKey;
  static const String _osmPlacePrefix = 'osm:';

  // ──────────────── Autocomplete (locked to Sri Lanka) ────────────────

  Future<List<Prediction>> autocomplete(
    String input, {
    String? types,
    LatLng? locationBias,
    int? radiusMeters,
  }) async {
    if (_apiKey.isEmpty) {
      return _autocompleteWithOpenStreetMap(input);
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
      return _autocompleteWithOpenStreetMap(input);
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status == 'ZERO_RESULTS') {
      return _autocompleteWithOpenStreetMap(input);
    }
    if (status != null && status != 'OK') {
      return _autocompleteWithOpenStreetMap(input);
    }

    final predictions = (body['predictions'] as List<dynamic>?) ?? [];
    return predictions
        .map((p) => Prediction.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  Future<List<Prediction>> _autocompleteWithOpenStreetMap(String input) async {
    if (input.trim().length < 2) return [];

    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'q': input.trim(),
        'format': 'jsonv2',
        'addressdetails': '1',
        'limit': '6',
        'countrycodes': 'lk',
      },
    );

    final res = await http.get(
      uri,
      headers: const {
        'User-Agent': 'SafeDriverPassengerApp/1.0',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Location search failed: ${res.statusCode}');
    }

    final results = json.decode(res.body) as List<dynamic>;
    return results.map((item) {
      final json = item as Map<String, dynamic>;
      final lat = double.tryParse(json['lat'] as String? ?? '');
      final lng = double.tryParse(json['lon'] as String? ?? '');
      final displayName = json['display_name'] as String? ?? 'Location';
      final name = json['name'] as String?;
      final address = json['address'] as Map<String, dynamic>?;
      final city = address?['city'] ??
          address?['town'] ??
          address?['village'] ??
          address?['county'] ??
          address?['state'];

      return Prediction(
        description: displayName,
        placeId: '$_osmPlacePrefix$lat,$lng',
        mainText:
            name?.isNotEmpty == true ? name : displayName.split(',').first,
        secondaryText: city?.toString(),
      );
    }).where((prediction) {
      final coordinates = prediction.placeId.substring(_osmPlacePrefix.length);
      return !coordinates.contains('null');
    }).toList();
  }

  // ──────────────── Place Details ────────────────

  Future<LatLng> getPlaceLatLng(String placeId) async {
    if (placeId.startsWith(_osmPlacePrefix)) {
      final coordinates = placeId.substring(_osmPlacePrefix.length).split(',');
      if (coordinates.length == 2) {
        final lat = double.tryParse(coordinates[0]);
        final lng = double.tryParse(coordinates[1]);
        if (lat != null && lng != null) return LatLng(lat, lng);
      }
      throw Exception('Invalid fallback location coordinates');
    }

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
      return _nearbyBusStopsWithOpenStreetMap(
        lat,
        lng,
        radiusMeters: radiusMeters,
      );
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
      return _nearbyBusStopsWithOpenStreetMap(
        lat,
        lng,
        radiusMeters: radiusMeters,
      );
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;
    if (status != null && status != 'OK' && status != 'ZERO_RESULTS') {
      return _nearbyBusStopsWithOpenStreetMap(
        lat,
        lng,
        radiusMeters: radiusMeters,
      );
    }

    final results = (body['results'] as List<dynamic>?) ?? [];
    return results
        .map((r) => NearbyPlace.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<List<NearbyPlace>> _nearbyBusStopsWithOpenStreetMap(
    double lat,
    double lng, {
    required int radiusMeters,
  }) async {
    final query = '''
[out:json][timeout:12];
(
  node["highway"="bus_stop"](around:$radiusMeters,$lat,$lng);
  node["public_transport"="platform"]["bus"="yes"](around:$radiusMeters,$lat,$lng);
  node["amenity"="bus_station"](around:$radiusMeters,$lat,$lng);
);
out center 20;
''';

    final uri = Uri.https(
      'overpass-api.de',
      '/api/interpreter',
      {'data': query},
    );

    try {
      final res = await http.get(
        uri,
        headers: const {
          'User-Agent': 'SafeDriverPassengerApp/1.0',
        },
      );

      if (res.statusCode != 200) return [];

      final body = json.decode(res.body) as Map<String, dynamic>;
      final elements = body['elements'] as List<dynamic>? ?? [];

      return elements.map((item) {
        final element = item as Map<String, dynamic>;
        final tags = element['tags'] as Map<String, dynamic>? ?? {};
        final stopLat = (element['lat'] as num?)?.toDouble() ??
            ((element['center'] as Map<String, dynamic>?)?['lat'] as num?)
                ?.toDouble() ??
            lat;
        final stopLng = (element['lon'] as num?)?.toDouble() ??
            ((element['center'] as Map<String, dynamic>?)?['lon'] as num?)
                ?.toDouble() ??
            lng;
        final id = element['id']?.toString() ?? '$stopLat,$stopLng';

        return NearbyPlace(
          name: tags['name'] as String? ?? 'Bus Stop',
          lat: stopLat,
          lng: stopLng,
          placeId: 'osm_bus_$id',
          vicinity: tags['operator'] as String? ?? 'Nearby bus stop',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ──────────────── Directions (transit / bus) ────────────────

  /// Gets bus transit directions from [origin] to [destination].
  Future<DirectionsResult?> getDirections(
    LatLng origin,
    LatLng destination,
  ) async {
    if (_apiKey.isEmpty) {
      return _getRoadRouteFallback(origin, destination);
    }

    final params = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': 'transit',
      'transit_mode': 'bus',
      'departure_time': 'now',
      'region': 'lk',
      'key': _apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      params,
    );

    late final http.Response res;
    try {
      res = await http.get(uri);
    } catch (_) {
      return _getRoadRouteFallback(origin, destination);
    }

    if (res.statusCode != 200) {
      return _getRoadRouteFallback(origin, destination);
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    final status = body['status'] as String?;

    if (status == 'ZERO_RESULTS') {
      return _getRoadRouteFallback(origin, destination);
    }
    if (status != null && status != 'OK') {
      return _getRoadRouteFallback(origin, destination);
    }

    final routes = body['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) return null;

    final route = routes.first as Map<String, dynamic>;
    final leg = (route['legs'] as List<dynamic>).first as Map<String, dynamic>;

    final overviewPolyline = (route['overview_polyline']
        as Map<String, dynamic>)['points'] as String;

    final steps = (leg['steps'] as List<dynamic>)
        .map((s) => TransitStep.fromJson(s as Map<String, dynamic>))
        .toList();

    final startLoc = leg['start_location'] as Map<String, dynamic>;
    final endLoc = leg['end_location'] as Map<String, dynamic>;

    return DirectionsResult(
      totalDuration:
          (leg['duration'] as Map<String, dynamic>)['text'] as String,
      totalDistance:
          (leg['distance'] as Map<String, dynamic>)['text'] as String,
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
      isFallback: false,
    );
  }

  Future<DirectionsResult?> _getRoadRouteFallback(
    LatLng origin,
    LatLng destination,
  ) async {
    return await _getOsrmRoadRouteFallback(origin, destination) ??
        await _getValhallaBusRouteFallback(origin, destination) ??
        _buildEstimatedDirectRoute(origin, destination);
  }

  Future<DirectionsResult?> _getOsrmRoadRouteFallback(
    LatLng origin,
    LatLng destination,
  ) async {
    final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}',
      {
        'overview': 'full',
        'geometries': 'polyline',
        'steps': 'false',
      },
    );

    late final http.Response res;
    try {
      res = await http.get(uri);
    } catch (_) {
      return null;
    }

    if (res.statusCode != 200) {
      return null;
    }

    final body = json.decode(res.body) as Map<String, dynamic>;
    if (body['code'] != 'Ok') {
      return null;
    }

    final routes = body['routes'] as List<dynamic>?;
    if (routes == null || routes.isEmpty) {
      return null;
    }

    final route = routes.first as Map<String, dynamic>;
    final distanceMeters = ((route['distance'] as num?) ?? 0).round();
    final drivingSeconds = ((route['duration'] as num?) ?? 0).round();
    final busSeconds = _estimateBusDurationSeconds(
      distanceMeters,
      drivingSeconds,
    );
    final polyline =
        (route['geometry'] as String?) ?? _encodeLine(origin, destination);

    return DirectionsResult(
      totalDuration: _formatDuration(busSeconds),
      totalDistance: _formatDistance(distanceMeters),
      totalDurationSeconds: busSeconds,
      totalDistanceMeters: distanceMeters,
      overviewPolyline: polyline,
      steps: [
        TransitStep(
          instructions: 'Follow the mapped road route by bus',
          travelMode: 'TRANSIT',
          startLocation: origin,
          endLocation: destination,
          duration: _formatDuration(busSeconds),
          distance: _formatDistance(distanceMeters),
          durationSeconds: busSeconds,
          distanceMeters: distanceMeters,
          polyline: polyline,
          lineName: 'Bus route',
          lineShortName: 'BUS',
          vehicleType: 'BUS',
          departureStop: 'Current location',
          arrivalStop: 'Selected destination',
          numStops: null,
        ),
      ],
      startLocation: origin,
      endLocation: destination,
      isFallback: true,
    );
  }

  Future<DirectionsResult?> _getValhallaBusRouteFallback(
    LatLng origin,
    LatLng destination,
  ) async {
    final routeJson = json.encode({
      'locations': [
        {'lat': origin.latitude, 'lon': origin.longitude},
        {'lat': destination.latitude, 'lon': destination.longitude},
      ],
      'costing': 'bus',
      'directions_options': {'units': 'kilometers'},
    });

    final uri = Uri.https(
      'valhalla1.openstreetmap.de',
      '/route',
      {'json': routeJson},
    );

    late final http.Response res;
    try {
      res = await http.get(
        uri,
        headers: const {
          'User-Agent': 'SafeDriverPassengerApp/1.0',
        },
      );
    } catch (_) {
      return null;
    }

    if (res.statusCode != 200) return null;

    final body = json.decode(res.body) as Map<String, dynamic>;
    final trip = body['trip'] as Map<String, dynamic>?;
    if (trip == null) return null;

    final summary = trip['summary'] as Map<String, dynamic>? ?? {};
    final legs = trip['legs'] as List<dynamic>? ?? [];
    if (legs.isEmpty) return null;

    final leg = legs.first as Map<String, dynamic>;
    final shape = leg['shape'] as String?;
    if (shape == null || shape.isEmpty) return null;

    final routePoints = _decodePolylineWithPrecision(shape, precision: 6);
    if (routePoints.length < 2) return null;

    final polyline = _encodePolyline(routePoints);
    var distanceMeters = (((summary['length'] as num?) ?? 0) * 1000).round();
    if (distanceMeters <= 0) {
      distanceMeters = _routeDistanceMeters(routePoints);
    }
    final routeSeconds = ((summary['time'] as num?) ?? 0).round();
    final busSeconds = _estimateBusDurationSeconds(
      distanceMeters,
      routeSeconds,
    );

    return DirectionsResult(
      totalDuration: _formatDuration(busSeconds),
      totalDistance: _formatDistance(distanceMeters),
      totalDurationSeconds: busSeconds,
      totalDistanceMeters: distanceMeters,
      overviewPolyline: polyline,
      steps: [
        TransitStep(
          instructions: 'Follow the mapped road route by bus',
          travelMode: 'TRANSIT',
          startLocation: routePoints.first,
          endLocation: routePoints.last,
          duration: _formatDuration(busSeconds),
          distance: _formatDistance(distanceMeters),
          durationSeconds: busSeconds,
          distanceMeters: distanceMeters,
          polyline: polyline,
          lineName: 'Bus route',
          lineShortName: 'BUS',
          vehicleType: 'BUS',
          departureStop: 'Current location',
          arrivalStop: 'Selected destination',
        ),
      ],
      startLocation: routePoints.first,
      endLocation: routePoints.last,
      isFallback: true,
    );
  }

  DirectionsResult _buildEstimatedDirectRoute(
    LatLng origin,
    LatLng destination,
  ) {
    final distanceMeters = _haversineDistanceMeters(origin, destination);
    final busSeconds = _estimateBusDurationSeconds(distanceMeters, 0);
    final polyline = _encodeLine(origin, destination);

    return DirectionsResult(
      totalDuration: _formatDuration(busSeconds),
      totalDistance: _formatDistance(distanceMeters),
      totalDurationSeconds: busSeconds,
      totalDistanceMeters: distanceMeters,
      overviewPolyline: polyline,
      steps: [
        TransitStep(
          instructions: 'Estimated direct bus route',
          travelMode: 'TRANSIT',
          startLocation: origin,
          endLocation: destination,
          duration: _formatDuration(busSeconds),
          distance: _formatDistance(distanceMeters),
          durationSeconds: busSeconds,
          distanceMeters: distanceMeters,
          polyline: polyline,
          lineName: 'Estimated bus route',
          lineShortName: 'BUS',
          vehicleType: 'BUS',
          departureStop: 'Current location',
          arrivalStop: 'Selected destination',
        ),
      ],
      startLocation: origin,
      endLocation: destination,
      isFallback: true,
    );
  }

  int _haversineDistanceMeters(LatLng start, LatLng end) {
    const earthRadiusMeters = 6371000.0;
    final startLat = _toRadians(start.latitude);
    final endLat = _toRadians(end.latitude);
    final deltaLat = _toRadians(end.latitude - start.latitude);
    final deltaLng = _toRadians(end.longitude - start.longitude);
    final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(startLat) *
            math.cos(endLat) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return (earthRadiusMeters * c).round();
  }

  int _routeDistanceMeters(List<LatLng> points) {
    var distance = 0;
    for (var i = 1; i < points.length; i++) {
      distance += _haversineDistanceMeters(points[i - 1], points[i]);
    }
    return distance;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  int _estimateBusDurationSeconds(int distanceMeters, int drivingSeconds) {
    if (distanceMeters <= 0) return drivingSeconds;
    final estimatedBySpeed = (distanceMeters / 1000 / 24 * 3600).round();
    return estimatedBySpeed > drivingSeconds
        ? estimatedBySpeed
        : drivingSeconds;
  }

  String _formatDistance(int meters) {
    if (meters < 1000) return '$meters m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '$hours hr';
    return '$hours hr $remainingMinutes min';
  }

  String _encodeLine(LatLng start, LatLng end) {
    return _encodePolyline([start, end]);
  }

  List<LatLng> _decodePolylineWithPrecision(
    String encoded, {
    required int precision,
  }) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    final factor = math.pow(10, precision).toDouble();

    while (index < encoded.length) {
      var shift = 0;
      var result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : result >> 1;

      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : result >> 1;

      points.add(LatLng(lat / factor, lng / factor));
    }

    return points;
  }

  String _encodePolyline(List<LatLng> points) {
    var lastLat = 0;
    var lastLng = 0;
    final result = StringBuffer();

    for (final point in points) {
      final lat = (point.latitude * 1E5).round();
      final lng = (point.longitude * 1E5).round();
      result.write(_encodeSigned(lat - lastLat));
      result.write(_encodeSigned(lng - lastLng));
      lastLat = lat;
      lastLng = lng;
    }

    return result.toString();
  }

  String _encodeSigned(int value) {
    var encoded = value < 0 ? ~(value << 1) : value << 1;
    final output = StringBuffer();

    while (encoded >= 0x20) {
      output.writeCharCode((0x20 | (encoded & 0x1f)) + 63);
      encoded >>= 5;
    }
    output.writeCharCode(encoded + 63);
    return output.toString();
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
