import 'location_model.dart';

class SafetyIncident {
  final String id;
  final String driverId;
  final String? busId;
  final String? routeId;
  final IncidentType type;
  final IncidentSeverity severity;
  final String description;
  final LocationModel? location;
  final DateTime timestamp;
  final IncidentStatus status;
  final Map<String, dynamic> additionalData;

  SafetyIncident({
    required this.id,
    required this.driverId,
    this.busId,
    this.routeId,
    required this.type,
    required this.severity,
    required this.description,
    this.location,
    required this.timestamp,
    required this.status,
    required this.additionalData,
  });

  factory SafetyIncident.fromJson(Map<String, dynamic> json) {
    return SafetyIncident(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      busId: json['busId'],
      routeId: json['routeId'],
      type: IncidentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => IncidentType.other,
      ),
      severity: IncidentSeverity.values.firstWhere(
        (e) => e.toString().split('.').last == json['severity'],
        orElse: () => IncidentSeverity.low,
      ),
      description: json['description'] ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      status: IncidentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => IncidentStatus.reported,
      ),
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'busId': busId,
      'routeId': routeId,
      'type': type.toString().split('.').last,
      'severity': severity.toString().split('.').last,
      'description': description,
      'location': location?.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
      'additionalData': additionalData,
    };
  }
}

enum IncidentType {
  collision,
  nearMiss,
  harshBraking,
  speeding,
  drowsiness,
  distraction,
  maintenance,
  other,
}

enum IncidentSeverity {
  low,
  medium,
  high,
  critical,
}

enum IncidentStatus {
  reported,
  investigating,
  resolved,
  dismissed,
}

class AlertnessLevel {
  final double level; // 0.0 to 1.0
  final DateTime timestamp;
  final String? description;

  AlertnessLevel({
    required this.level,
    required this.timestamp,
    this.description,
  });

  String get levelDescription {
    if (level >= 0.8) return 'Alert';
    if (level >= 0.6) return 'Moderate';
    if (level >= 0.4) return 'Low';
    return 'Critical';
  }

  bool get isAlert => level >= 0.8;
  bool get isCritical => level < 0.4;

  factory AlertnessLevel.fromJson(Map<String, dynamic> json) {
    return AlertnessLevel(
      level: json['level']?.toDouble() ?? 0.0,
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }
}
