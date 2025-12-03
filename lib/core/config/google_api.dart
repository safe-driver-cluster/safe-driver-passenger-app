import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapsConfig {
  // Reads the API key from .env file
  // Make sure to call dotenv.load() in main.dart before using this
  static String get apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static bool get isConfigured => apiKey.isNotEmpty;
}

