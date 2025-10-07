import 'location_model.dart';

class SafetyAlertModel {
  final String id;
  final AlertType type;
  final AlertPriority priority;
  final String title;
  final String description;
  final String? busId;
  final String? driverId;
  final String? routeId;
  final LocationModel? location;
  final DateTime timestamp;
  final AlertStatus status;
  final List<String> affectedAreas;
  final Map<String, dynamic> additionalData;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> tags;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolution;
  final bool isActive;
  final int severity; // 1-10 scale
  final Duration? estimatedDuration;
  final List<String> recommendedActions;

  SafetyAlertModel({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.description,
    this.busId,
    this.driverId,
    this.routeId,
    this.location,
    required this.timestamp,
    required this.status,
    required this.affectedAreas,
    required this.additionalData,
    this.imageUrl,
    this.videoUrl,
    required this.tags,
    this.resolvedAt,
    this.resolvedBy,
    this.resolution,
    this.isActive = true,
    required this.severity,
    this.estimatedDuration,
    required this.recommendedActions,
  });

  String get priorityDisplay {
    switch (priority) {
      case AlertPriority.low:
        return 'Low';
      case AlertPriority.medium:
        return 'Medium';
      case AlertPriority.high:
        return 'High';
      case AlertPriority.critical:
        return 'Critical';
      case AlertPriority.emergency:
        return 'Emergency';
    }
  }

  String get typeDisplay {
    switch (type) {
      case AlertType.driverDrowsiness:
        return 'Driver Drowsiness';
      case AlertType.driverDistraction:
        return 'Driver Distraction';
      case AlertType.speedViolation:
        return 'Speed Violation';
      case AlertType.harshBraking:
        return 'Harsh Braking';
      case AlertType.harshAcceleration:
        return 'Harsh Acceleration';
      case AlertType.weatherWarning:
        return 'Weather Warning';
      case AlertType.roadHazard:
        return 'Road Hazard';
      case AlertType.vehicleMalfunction:
        return 'Vehicle Malfunction';
      case AlertType.emergencyBraking:
        return 'Emergency Braking';
      case AlertType.accidentAlert:
        return 'Accident Alert';
      case AlertType.trafficCongestion:
        return 'Traffic Congestion';
      case AlertType.routeDeviation:
        return 'Route Deviation';
      case AlertType.maintenanceRequired:
        return 'Maintenance Required';
      case AlertType.systemFailure:
        return 'System Failure';
      case AlertType.securityBreach:
        return 'Security Breach';
      // New cases for missing constants
      case AlertType.emergency:
        return 'Emergency';
      case AlertType.accident:
        return 'Accident';
      case AlertType.breakdown:
        return 'Breakdown';
      case AlertType.hazard:
        return 'Hazard';
      case AlertType.weather:
        return 'Weather';
      case AlertType.traffic:
        return 'Traffic';
      case AlertType.security:
        return 'Security';
    }
  }

  String get statusDisplay {
    switch (status) {
      case AlertStatus.active:
        return 'Active';
      case AlertStatus.acknowledged:
        return 'Acknowledged';
      case AlertStatus.inProgress:
        return 'In Progress';
      case AlertStatus.resolved:
        return 'Resolved';
      case AlertStatus.dismissed:
        return 'Dismissed';
      case AlertStatus.escalated:
        return 'Escalated';
    }
  }

  bool get isResolved => status == AlertStatus.resolved;

  bool get requiresImmediateAction =>
      priority == AlertPriority.critical || priority == AlertPriority.emergency;

  Duration get timeSinceCreated => DateTime.now().difference(timestamp);

  String get timeAgo {
    final duration = timeSinceCreated;
    if (duration.inMinutes < 1) return 'Just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
    if (duration.inHours < 24) return '${duration.inHours}h ago';
    return '${duration.inDays}d ago';
  }

  factory SafetyAlertModel.fromJson(Map<String, dynamic> json) {
    return SafetyAlertModel(
      id: json['id'] ?? '',
      type: AlertType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AlertType.systemFailure,
      ),
      priority: AlertPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => AlertPriority.low,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      busId: json['busId'],
      driverId: json['driverId'],
      routeId: json['routeId'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      status: AlertStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AlertStatus.active,
      ),
      affectedAreas: List<String>.from(json['affectedAreas'] ?? []),
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      resolvedBy: json['resolvedBy'],
      resolution: json['resolution'],
      isActive: json['isActive'] ?? true,
      severity: json['severity'] ?? 1,
      estimatedDuration: json['estimatedDuration'] != null
          ? Duration(seconds: json['estimatedDuration'])
          : null,
      recommendedActions: List<String>.from(json['recommendedActions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'title': title,
      'description': description,
      'busId': busId,
      'driverId': driverId,
      'routeId': routeId,
      'location': location?.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
      'affectedAreas': affectedAreas,
      'additionalData': additionalData,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'tags': tags,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'resolution': resolution,
      'isActive': isActive,
      'severity': severity,
      'estimatedDuration': estimatedDuration?.inSeconds,
      'recommendedActions': recommendedActions,
    };
  }

  SafetyAlertModel copyWith({
    String? id,
    AlertType? type,
    AlertPriority? priority,
    String? title,
    String? description,
    String? busId,
    String? driverId,
    String? routeId,
    LocationModel? location,
    DateTime? timestamp,
    AlertStatus? status,
    List<String>? affectedAreas,
    Map<String, dynamic>? additionalData,
    String? imageUrl,
    String? videoUrl,
    List<String>? tags,
    DateTime? resolvedAt,
    String? resolvedBy,
    String? resolution,
    bool? isActive,
    int? severity,
    Duration? estimatedDuration,
    List<String>? recommendedActions,
  }) {
    return SafetyAlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      busId: busId ?? this.busId,
      driverId: driverId ?? this.driverId,
      routeId: routeId ?? this.routeId,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      affectedAreas: affectedAreas ?? this.affectedAreas,
      additionalData: additionalData ?? this.additionalData,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      tags: tags ?? this.tags,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolution: resolution ?? this.resolution,
      isActive: isActive ?? this.isActive,
      severity: severity ?? this.severity,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      recommendedActions: recommendedActions ?? this.recommendedActions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafetyAlertModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SafetyAlertModel(id: $id, type: $type, priority: $priority, status: $status)';
  }
}

enum AlertType {
  driverDrowsiness,
  driverDistraction,
  speedViolation,
  harshBraking,
  harshAcceleration,
  weatherWarning,
  roadHazard,
  vehicleMalfunction,
  emergencyBraking,
  accidentAlert,
  trafficCongestion,
  routeDeviation,
  maintenanceRequired,
  systemFailure,
  securityBreach,
  // Missing constants used in widgets
  emergency,
  accident,
  breakdown,
  hazard,
  weather,
  traffic,
  security,
}

enum AlertPriority {
  low,
  medium,
  high,
  critical,
  emergency,
}

enum AlertStatus {
  active,
  acknowledged,
  inProgress,
  resolved,
  dismissed,
  escalated,
}

// AlertSeverity class used in widgets
class AlertSeverity {
  static const int low = 1;
  static const int medium = 2;
  static const int high = 3;
  static const int critical = 4;
  static const int emergency = 5;

  static String getSeverityName(int severity) {
    switch (severity) {
      case low:
        return 'Low';
      case medium:
        return 'Medium';
      case high:
        return 'High';
      case critical:
        return 'Critical';
      case emergency:
        return 'Emergency';
      default:
        return 'Unknown';
    }
  }
}

// Helper class for grouping alerts
class AlertGroup {
  final AlertType type;
  final List<SafetyAlertModel> alerts;
  final int count;
  final AlertPriority highestPriority;

  AlertGroup({
    required this.type,
    required this.alerts,
    required this.count,
    required this.highestPriority,
  });

  factory AlertGroup.fromAlerts(AlertType type, List<SafetyAlertModel> alerts) {
    final filteredAlerts = alerts.where((alert) => alert.type == type).toList();
    final highestPriority = filteredAlerts.isEmpty
        ? AlertPriority.low
        : filteredAlerts
            .map((alert) => alert.priority)
            .reduce((a, b) => a.index > b.index ? a : b);

    return AlertGroup(
      type: type,
      alerts: filteredAlerts,
      count: filteredAlerts.length,
      highestPriority: highestPriority,
    );
  }
}

// Helper class for alert statistics
class AlertStatistics {
  final int totalAlerts;
  final int activeAlerts;
  final int resolvedAlerts;
  final int criticalAlerts;
  final int emergencyAlerts;
  final Map<AlertType, int> alertsByType;
  final Map<AlertPriority, int> alertsByPriority;
  final Map<AlertStatus, int> alertsByStatus;

  AlertStatistics({
    required this.totalAlerts,
    required this.activeAlerts,
    required this.resolvedAlerts,
    required this.criticalAlerts,
    required this.emergencyAlerts,
    required this.alertsByType,
    required this.alertsByPriority,
    required this.alertsByStatus,
  });

  factory AlertStatistics.fromAlerts(List<SafetyAlertModel> alerts) {
    final alertsByType = <AlertType, int>{};
    final alertsByPriority = <AlertPriority, int>{};
    final alertsByStatus = <AlertStatus, int>{};

    for (final alert in alerts) {
      alertsByType[alert.type] = (alertsByType[alert.type] ?? 0) + 1;
      alertsByPriority[alert.priority] =
          (alertsByPriority[alert.priority] ?? 0) + 1;
      alertsByStatus[alert.status] = (alertsByStatus[alert.status] ?? 0) + 1;
    }

    return AlertStatistics(
      totalAlerts: alerts.length,
      activeAlerts:
          alerts.where((alert) => alert.status == AlertStatus.active).length,
      resolvedAlerts:
          alerts.where((alert) => alert.status == AlertStatus.resolved).length,
      criticalAlerts: alerts
          .where((alert) => alert.priority == AlertPriority.critical)
          .length,
      emergencyAlerts: alerts
          .where((alert) => alert.priority == AlertPriority.emergency)
          .length,
      alertsByType: alertsByType,
      alertsByPriority: alertsByPriority,
      alertsByStatus: alertsByStatus,
    );
  }

  double get resolutionRate {
    return totalAlerts > 0 ? resolvedAlerts / totalAlerts : 0.0;
  }

  double get criticalAlertRate {
    return totalAlerts > 0
        ? (criticalAlerts + emergencyAlerts) / totalAlerts
        : 0.0;
  }
}
