import 'package:cloud_firestore/cloud_firestore.dart';

class MapHazard {
  final String id;
  final String name;
  final String type;
  final String location;
  final double latitude;
  final double longitude;
  final double radius;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MapHazard({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.createdAt,
    this.updatedAt,
  });

  String get typeLabel {
    if (type.trim().isEmpty) return 'Unknown';
    return type
        .trim()
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }

  String get radiusLabel => '${radius.toStringAsFixed(0)} m';

  static MapHazard? fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final latitude = _readDouble(data['latitude']);
    final longitude = _readDouble(data['longitude']);
    if (latitude == null || longitude == null) return null;

    return MapHazard(
      id: doc.id,
      name: _readString(data['name'], fallback: 'Hazard'),
      type: _readString(data['type'], fallback: 'other'),
      location: _readString(data['location'], fallback: 'Detected Location'),
      latitude: latitude,
      longitude: longitude,
      radius: _readDouble(data['radius']) ?? 100,
      createdAt: _readDateTime(data['createdAt']),
      updatedAt: _readDateTime(data['updatedAt']),
    );
  }

  static String _readString(Object? value, {required String fallback}) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }

  static double? _readDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
