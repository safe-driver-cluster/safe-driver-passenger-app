import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../core/config/google_api.dart';

class Prediction {
  final String description;
  final String placeId;

  Prediction({required this.description, required this.placeId});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'] as String,
      placeId: json['place_id'] as String,
    );
  }
}

class GooglePlacesService {
  final String _apiKey = GoogleMapsConfig.apiKey;

  Future<List<Prediction>> autocomplete(String input, {String? country}) async {
    if (_apiKey.isEmpty) {
      throw StateError(
          'Google API key is missing. Set GOOGLE_MAPS_API_KEY in .env file');
    }

    final params = {
      'input': input,
      'key': _apiKey,
      'types': 'geocode',
      'components': country != null ? 'country:$country' : null,
    }..removeWhere((key, value) => value == null);

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
}
