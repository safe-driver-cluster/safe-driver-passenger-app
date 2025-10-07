import 'location_model.dart';

class BusModel {
  final String id;
  final String busNumber;
  final String routeNumber;
  final String registration;
  final BusType busType;
  final int passengerCapacity;
  final String driverId;
  final String? driverName;
  final String? imageUrl;
  final BusStatus status;
  final LocationModel? currentLocation;
  final double? currentSpeed;
  final double? heading;
  final double safetyScore;
  final List<String> amenities;
  final BusSpecifications specifications;
  final MaintenanceInfo maintenanceInfo;
  final DateTime lastUpdated;
  final bool isActive;
  final List<SafetyFeature> safetyFeatures;

  BusModel({
    required this.id,
    required this.busNumber,
    required this.routeNumber,
    required this.registration,
    required this.busType,
    required this.passengerCapacity,
    required this.driverId,
    this.driverName,
    this.imageUrl,
    required this.status,
    this.currentLocation,
    this.currentSpeed,
    this.heading,
    required this.safetyScore,
    required this.amenities,
    required this.specifications,
    required this.maintenanceInfo,
    required this.lastUpdated,
    this.isActive = true,
    required this.safetyFeatures,
  });

  String get displayName => 'Bus $busNumber';

  String get routeDisplay => 'Route $routeNumber';

  bool get isOnline =>
      status == BusStatus.online || status == BusStatus.inTransit;

  bool get isTracking => currentLocation != null && isOnline;

  String get statusDisplay {
    switch (status) {
      case BusStatus.online:
        return 'Online';
      case BusStatus.offline:
        return 'Offline';
      case BusStatus.inTransit:
        return 'In Transit';
      case BusStatus.atStop:
        return 'At Stop';
      case BusStatus.maintenance:
        return 'Maintenance';
      case BusStatus.emergency:
        return 'Emergency';
      case BusStatus.active:
        return 'Active';
      case BusStatus.enRoute:
        return 'En Route';
    }
  }

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'] ?? '',
      busNumber: json['busNumber'] ?? '',
      routeNumber: json['routeNumber'] ?? '',
      registration: json['registration'] ?? '',
      busType: BusType.values.firstWhere(
        (e) => e.toString().split('.').last == json['busType'],
        orElse: () => BusType.standard,
      ),
      passengerCapacity: json['passengerCapacity'] ?? 0,
      driverId: json['driverId'] ?? '',
      driverName: json['driverName'],
      imageUrl: json['imageUrl'],
      status: BusStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BusStatus.offline,
      ),
      currentLocation: json['currentLocation'] != null
          ? LocationModel.fromJson(json['currentLocation'])
          : null,
      currentSpeed: json['currentSpeed']?.toDouble(),
      heading: json['heading']?.toDouble(),
      safetyScore: json['safetyScore']?.toDouble() ?? 0.0,
      amenities: List<String>.from(json['amenities'] ?? []),
      specifications: BusSpecifications.fromJson(json['specifications'] ?? {}),
      maintenanceInfo: MaintenanceInfo.fromJson(json['maintenanceInfo'] ?? {}),
      lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      safetyFeatures: (json['safetyFeatures'] as List<dynamic>?)
              ?.map((e) => SafetyFeature.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busNumber': busNumber,
      'routeNumber': routeNumber,
      'registration': registration,
      'busType': busType.toString().split('.').last,
      'passengerCapacity': passengerCapacity,
      'driverId': driverId,
      'driverName': driverName,
      'imageUrl': imageUrl,
      'status': status.toString().split('.').last,
      'currentLocation': currentLocation?.toJson(),
      'currentSpeed': currentSpeed,
      'heading': heading,
      'safetyScore': safetyScore,
      'amenities': amenities,
      'specifications': specifications.toJson(),
      'maintenanceInfo': maintenanceInfo.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'isActive': isActive,
      'safetyFeatures': safetyFeatures.map((e) => e.toJson()).toList(),
    };
  }

  BusModel copyWith({
    String? id,
    String? busNumber,
    String? routeNumber,
    String? registration,
    BusType? busType,
    int? passengerCapacity,
    String? driverId,
    String? driverName,
    String? imageUrl,
    BusStatus? status,
    LocationModel? currentLocation,
    double? currentSpeed,
    double? heading,
    double? safetyScore,
    List<String>? amenities,
    BusSpecifications? specifications,
    MaintenanceInfo? maintenanceInfo,
    DateTime? lastUpdated,
    bool? isActive,
    List<SafetyFeature>? safetyFeatures,
  }) {
    return BusModel(
      id: id ?? this.id,
      busNumber: busNumber ?? this.busNumber,
      routeNumber: routeNumber ?? this.routeNumber,
      registration: registration ?? this.registration,
      busType: busType ?? this.busType,
      passengerCapacity: passengerCapacity ?? this.passengerCapacity,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      currentLocation: currentLocation ?? this.currentLocation,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      heading: heading ?? this.heading,
      safetyScore: safetyScore ?? this.safetyScore,
      amenities: amenities ?? this.amenities,
      specifications: specifications ?? this.specifications,
      maintenanceInfo: maintenanceInfo ?? this.maintenanceInfo,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      safetyFeatures: safetyFeatures ?? this.safetyFeatures,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BusModel(id: $id, busNumber: $busNumber, routeNumber: $routeNumber, status: $status)';
  }
}

enum BusStatus {
  online,
  offline,
  inTransit,
  atStop,
  maintenance,
  emergency,
  active, // Missing constant used in widgets
  enRoute, // Missing constant used in dashboard_controller
}

enum BusType {
  standard,
  electric,
  hybrid,
  articulated,
  miniVan,
  coach,
}

class BusSpecifications {
  final String manufacturer;
  final String model;
  final int year;
  final String engineType;
  final double fuelCapacity;
  final double maxSpeed;
  final String transmissionType;
  final double length;
  final double width;
  final double height;
  final double weight;

  BusSpecifications({
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.engineType,
    required this.fuelCapacity,
    required this.maxSpeed,
    required this.transmissionType,
    required this.length,
    required this.width,
    required this.height,
    required this.weight,
  });

  factory BusSpecifications.fromJson(Map<String, dynamic> json) {
    return BusSpecifications(
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      engineType: json['engineType'] ?? '',
      fuelCapacity: json['fuelCapacity']?.toDouble() ?? 0.0,
      maxSpeed: json['maxSpeed']?.toDouble() ?? 0.0,
      transmissionType: json['transmissionType'] ?? '',
      length: json['length']?.toDouble() ?? 0.0,
      width: json['width']?.toDouble() ?? 0.0,
      height: json['height']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'year': year,
      'engineType': engineType,
      'fuelCapacity': fuelCapacity,
      'maxSpeed': maxSpeed,
      'transmissionType': transmissionType,
      'length': length,
      'width': width,
      'height': height,
      'weight': weight,
    };
  }
}

class MaintenanceInfo {
  final DateTime lastServiceDate;
  final DateTime nextServiceDate;
  final int mileage;
  final List<MaintenanceRecord> history;
  final bool isServiceDue;
  final List<String> upcomingMaintenance;

  MaintenanceInfo({
    required this.lastServiceDate,
    required this.nextServiceDate,
    required this.mileage,
    required this.history,
    required this.isServiceDue,
    required this.upcomingMaintenance,
  });

  factory MaintenanceInfo.fromJson(Map<String, dynamic> json) {
    return MaintenanceInfo(
      lastServiceDate: DateTime.parse(
          json['lastServiceDate'] ?? DateTime.now().toIso8601String()),
      nextServiceDate: DateTime.parse(
          json['nextServiceDate'] ?? DateTime.now().toIso8601String()),
      mileage: json['mileage'] ?? 0,
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => MaintenanceRecord.fromJson(e))
              .toList() ??
          [],
      isServiceDue: json['isServiceDue'] ?? false,
      upcomingMaintenance: List<String>.from(json['upcomingMaintenance'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastServiceDate': lastServiceDate.toIso8601String(),
      'nextServiceDate': nextServiceDate.toIso8601String(),
      'mileage': mileage,
      'history': history.map((e) => e.toJson()).toList(),
      'isServiceDue': isServiceDue,
      'upcomingMaintenance': upcomingMaintenance,
    };
  }
}

class MaintenanceRecord {
  final String id;
  final DateTime date;
  final String type;
  final String description;
  final double cost;
  final String technician;
  final int mileageAtService;

  MaintenanceRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.cost,
    required this.technician,
    required this.mileageAtService,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) {
    return MaintenanceRecord(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      cost: json['cost']?.toDouble() ?? 0.0,
      technician: json['technician'] ?? '',
      mileageAtService: json['mileageAtService'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'description': description,
      'cost': cost,
      'technician': technician,
      'mileageAtService': mileageAtService,
    };
  }
}

class SafetyFeature {
  final String name;
  final String description;
  final bool isActive;
  final DateTime lastChecked;
  final SafetyFeatureStatus status;

  SafetyFeature({
    required this.name,
    required this.description,
    required this.isActive,
    required this.lastChecked,
    required this.status,
  });

  factory SafetyFeature.fromJson(Map<String, dynamic> json) {
    return SafetyFeature(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? false,
      lastChecked: DateTime.parse(
          json['lastChecked'] ?? DateTime.now().toIso8601String()),
      status: SafetyFeatureStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => SafetyFeatureStatus.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isActive': isActive,
      'lastChecked': lastChecked.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}

enum SafetyFeatureStatus {
  operational,
  warning,
  error,
  maintenance,
  unknown,
}
