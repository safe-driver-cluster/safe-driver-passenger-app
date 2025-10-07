import 'package:cloud_firestore/cloud_firestore.dart';

class HazardZone {
  final String id;
  final String name;
  final String description;
  final List<GeoPoint> coordinates; // Polygon coordinates
  final HazardType type;
  final SeverityLevel severity;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? reportedBy;
  final double radius; // In meters
  final Map<String, dynamic>? additionalInfo;

  HazardZone({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.type,
    required this.severity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.reportedBy,
    required this.radius,
    this.additionalInfo,
  });

  factory HazardZone.fromJson(Map<String, dynamic> json) {
    return HazardZone(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((coord) => GeoPoint(coord['latitude'], coord['longitude']))
              .toList() ??
          [],
      type: HazardType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => HazardType.other,
      ),
      severity: SeverityLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
        orElse: () => SeverityLevel.low,
      ),
      isActive: json['isActive'] ?? true,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      reportedBy: json['reportedBy'],
      radius: json['radius']?.toDouble() ?? 100.0,
      additionalInfo: json['additionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coordinates': coordinates
          .map((coord) =>
              {'latitude': coord.latitude, 'longitude': coord.longitude})
          .toList(),
      'type': type.toString().split('.').last,
      'severity': severity.toString().split('.').last,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reportedBy': reportedBy,
      'radius': radius,
      'additionalInfo': additionalInfo,
    };
  }

  HazardZone copyWith({
    String? id,
    String? name,
    String? description,
    List<GeoPoint>? coordinates,
    HazardType? type,
    SeverityLevel? severity,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reportedBy,
    double? radius,
    Map<String, dynamic>? additionalInfo,
  }) {
    return HazardZone(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coordinates: coordinates ?? this.coordinates,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reportedBy: reportedBy ?? this.reportedBy,
      radius: radius ?? this.radius,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  String toString() {
    return 'HazardZone(id: $id, name: $name, type: $type, severity: $severity)';
  }
}

enum HazardType {
  construction,
  accident,
  badWeather,
  roadDamage,
  flooding,
  landslide,
  heavyTraffic,
  schoolZone,
  other,
}

enum SeverityLevel {
  low,
  medium,
  high,
  critical,
}

class HazardAlert {
  final String id;
  final String hazardZoneId;
  final String busId;
  final String driverId;
  final DateTime timestamp;
  final String message;
  final bool isAcknowledged;
  final DateTime? acknowledgedAt;
  final AlertType alertType;

  HazardAlert({
    required this.id,
    required this.hazardZoneId,
    required this.busId,
    required this.driverId,
    required this.timestamp,
    required this.message,
    required this.isAcknowledged,
    this.acknowledgedAt,
    required this.alertType,
  });

  factory HazardAlert.fromJson(Map<String, dynamic> json) {
    return HazardAlert(
      id: json['id'] ?? '',
      hazardZoneId: json['hazardZoneId'] ?? '',
      busId: json['busId'] ?? '',
      driverId: json['driverId'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      message: json['message'] ?? '',
      isAcknowledged: json['isAcknowledged'] ?? false,
      acknowledgedAt: json['acknowledgedAt'] != null
          ? DateTime.parse(json['acknowledgedAt'])
          : null,
      alertType: AlertType.values.firstWhere(
        (e) => e.toString().split('.').last == json['alertType'],
        orElse: () => AlertType.warning,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hazardZoneId': hazardZoneId,
      'busId': busId,
      'driverId': driverId,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'isAcknowledged': isAcknowledged,
      'acknowledgedAt': acknowledgedAt?.toIso8601String(),
      'alertType': alertType.toString().split('.').last,
    };
  }
}

enum AlertType {
  info,
  warning,
  danger,
  critical,
}

extension HazardTypeExtension on HazardType {
  String get displayName {
    switch (this) {
      case HazardType.construction:
        return 'Construction';
      case HazardType.accident:
        return 'Accident';
      case HazardType.badWeather:
        return 'Bad Weather';
      case HazardType.roadDamage:
        return 'Road Damage';
      case HazardType.flooding:
        return 'Flooding';
      case HazardType.landslide:
        return 'Landslide';
      case HazardType.heavyTraffic:
        return 'Heavy Traffic';
      case HazardType.schoolZone:
        return 'School Zone';
      case HazardType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case HazardType.construction:
        return '🚧';
      case HazardType.accident:
        return '⚠️';
      case HazardType.badWeather:
        return '🌧️';
      case HazardType.roadDamage:
        return '🕳️';
      case HazardType.flooding:
        return '🌊';
      case HazardType.landslide:
        return '⛰️';
      case HazardType.heavyTraffic:
        return '🚗';
      case HazardType.schoolZone:
        return '🏫';
      case HazardType.other:
        return '❗';
    }
  }
}

extension SeverityLevelExtension on SeverityLevel {
  String get displayName {
    switch (this) {
      case SeverityLevel.low:
        return 'Low';
      case SeverityLevel.medium:
        return 'Medium';
      case SeverityLevel.high:
        return 'High';
      case SeverityLevel.critical:
        return 'Critical';
    }
  }
}
