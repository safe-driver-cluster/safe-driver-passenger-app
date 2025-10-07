import 'dart:math' as math;

/// Location model for representing GPS coordinates and location data
class LocationModel {
  final String? id;
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final String? name;
  final String? address;
  final String? description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const LocationModel({
    this.id,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.speed,
    this.heading,
    this.name,
    this.address,
    this.description,
    required this.timestamp,
    this.metadata,
  });

  /// Calculate distance to another location in meters
  double distanceTo(LocationModel other) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLngRad = (other.longitude - longitude) * (math.pi / 180);

    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calculate bearing to another location in degrees
  double bearingTo(LocationModel other) {
    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLngRad = (other.longitude - longitude) * (math.pi / 180);

    final double y = math.sin(deltaLngRad) * math.cos(lat2Rad);
    final double x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(deltaLngRad);

    final double bearingRad = math.atan2(y, x);
    final double bearingDeg = bearingRad * (180 / math.pi);

    return (bearingDeg + 360) % 360;
  }

  /// Check if location is valid
  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Get display string for coordinates
  String get coordinatesString {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Get formatted address or coordinates
  String get displayString {
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return coordinatesString;
  }

  /// Create a copy with updated values
  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    double? speed,
    double? heading,
    String? name,
    String? address,
    String? description,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'accuracy': accuracy,
      'speed': speed,
      'heading': heading,
      'name': name,
      'address': address,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: json['altitude']?.toDouble(),
      accuracy: json['accuracy']?.toDouble(),
      speed: json['speed']?.toDouble(),
      heading: json['heading']?.toDouble(),
      name: json['name'],
      address: json['address'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, latitude, longitude, timestamp);
  }

  @override
  String toString() {
    return 'LocationModel{id: $id, lat: $latitude, lng: $longitude, name: $name}';
  }
}

/// Location accuracy levels
enum LocationAccuracy {
  low, // 500m or more
  medium, // 100-500m
  high, // 10-100m
  best, // Less than 10m
}

/// Extension methods for LocationModel
extension LocationModelExtensions on LocationModel {
  /// Get accuracy level based on accuracy value
  LocationAccuracy get accuracyLevel {
    if (accuracy == null) return LocationAccuracy.low;
    if (accuracy! < 10) return LocationAccuracy.best;
    if (accuracy! < 100) return LocationAccuracy.high;
    if (accuracy! < 500) return LocationAccuracy.medium;
    return LocationAccuracy.low;
  }

  /// Check if location is recent (within specified minutes)
  bool isRecent([int minutes = 5]) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes <= minutes;
  }

  /// Get age of location in human readable format
  String get ageString {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
