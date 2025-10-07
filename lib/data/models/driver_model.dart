class DriverModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String licenseNumber;
  final String licenseType; // Missing property
  final DateTime licenseExpiryDate;
  final List<Certification> certifications;
  final DriverExperience experience;
  final DriverStatus status;
  final double safetyScore;
  final double alertnessLevel;
  final List<String> specializations;
  final EmergencyContact emergencyContact;
  final DriverPerformance performance;
  final List<TrainingRecord> trainingHistory;
  final HealthRecord healthRecord;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final String? currentBusId;
  final String? currentRoute;
  // Missing properties
  final double rating; // Overall driver rating

  DriverModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.licenseNumber,
    required this.licenseType,
    required this.licenseExpiryDate,
    required this.certifications,
    required this.experience,
    required this.status,
    required this.safetyScore,
    required this.alertnessLevel,
    required this.specializations,
    required this.emergencyContact,
    required this.performance,
    required this.trainingHistory,
    required this.healthRecord,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.currentBusId,
    this.currentRoute,
    this.rating = 0.0, // Default rating
  });

  String get fullName => '$firstName $lastName';

  String get name => fullName; // Alias for compatibility

  String get displayName => firstName.isNotEmpty ? firstName : 'Driver';

  bool get isOnDuty =>
      status == DriverStatus.active || status == DriverStatus.driving;

  bool get licenseExpiringSoon {
    final daysUntilExpiry = licenseExpiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }

  String get statusDisplay {
    switch (status) {
      case DriverStatus.active:
        return 'Active';
      case DriverStatus.driving:
        return 'Driving';
      case DriverStatus.resting:
        return 'On Break';
      case DriverStatus.offDuty:
        return 'Off Duty';
      case DriverStatus.unavailable:
        return 'Unavailable';
      case DriverStatus.emergency:
        return 'Emergency';
      case DriverStatus.available:
        return 'Available';
      case DriverStatus.onDuty:
        return 'On Duty';
      case DriverStatus.onBreak:
        return 'On Break';
    }
  }

  String get alertnessLevelDisplay {
    if (alertnessLevel >= 0.8) return 'Alert';
    if (alertnessLevel >= 0.6) return 'Moderate';
    if (alertnessLevel >= 0.4) return 'Low';
    return 'Critical';
  }

  bool get isHighPerformer => safetyScore >= 85.0;

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: DateTime.parse(
          json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      licenseNumber: json['licenseNumber'] ?? '',
      licenseType: json['licenseType'] ?? 'Standard',
      licenseExpiryDate: DateTime.parse(
          json['licenseExpiryDate'] ?? DateTime.now().toIso8601String()),
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e))
              .toList() ??
          [],
      experience: DriverExperience.fromJson(json['experience'] ?? {}),
      status: DriverStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => DriverStatus.offDuty,
      ),
      safetyScore: json['safetyScore']?.toDouble() ?? 0.0,
      alertnessLevel: json['alertnessLevel']?.toDouble() ?? 1.0,
      specializations: List<String>.from(json['specializations'] ?? []),
      emergencyContact:
          EmergencyContact.fromJson(json['emergencyContact'] ?? {}),
      performance: DriverPerformance.fromJson(json['performance'] ?? {}),
      trainingHistory: (json['trainingHistory'] as List<dynamic>?)
              ?.map((e) => TrainingRecord.fromJson(e))
              .toList() ??
          [],
      healthRecord: HealthRecord.fromJson(json['healthRecord'] ?? {}),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      currentBusId: json['currentBusId'],
      currentRoute: json['currentRoute'],
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'licenseNumber': licenseNumber,
      'licenseType': licenseType,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'experience': experience.toJson(),
      'status': status.toString().split('.').last,
      'safetyScore': safetyScore,
      'alertnessLevel': alertnessLevel,
      'specializations': specializations,
      'emergencyContact': emergencyContact.toJson(),
      'performance': performance.toJson(),
      'trainingHistory': trainingHistory.map((e) => e.toJson()).toList(),
      'healthRecord': healthRecord.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'currentBusId': currentBusId,
      'currentRoute': currentRoute,
      'rating': rating,
    };
  }

  DriverModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? licenseNumber,
    String? licenseType,
    DateTime? licenseExpiryDate,
    List<Certification>? certifications,
    DriverExperience? experience,
    DriverStatus? status,
    double? safetyScore,
    double? alertnessLevel,
    List<String>? specializations,
    EmergencyContact? emergencyContact,
    DriverPerformance? performance,
    List<TrainingRecord>? trainingHistory,
    HealthRecord? healthRecord,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? currentBusId,
    String? currentRoute,
    double? rating,
  }) {
    return DriverModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseType: licenseType ?? this.licenseType,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      certifications: certifications ?? this.certifications,
      experience: experience ?? this.experience,
      status: status ?? this.status,
      safetyScore: safetyScore ?? this.safetyScore,
      alertnessLevel: alertnessLevel ?? this.alertnessLevel,
      specializations: specializations ?? this.specializations,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      performance: performance ?? this.performance,
      trainingHistory: trainingHistory ?? this.trainingHistory,
      healthRecord: healthRecord ?? this.healthRecord,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      currentBusId: currentBusId ?? this.currentBusId,
      currentRoute: currentRoute ?? this.currentRoute,
      rating: rating ?? this.rating,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DriverModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DriverModel(id: $id, fullName: $fullName, status: $status, safetyScore: $safetyScore)';
  }
}

enum DriverStatus {
  active,
  driving,
  resting,
  offDuty,
  unavailable,
  emergency,
  // Missing constants used in driver_controller
  available,
  onDuty,
  onBreak,
}

class Certification {
  final String id;
  final String name;
  final String issuingAuthority;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String? certificateNumber;
  final bool isValid;

  Certification({
    required this.id,
    required this.name,
    required this.issuingAuthority,
    required this.issuedDate,
    required this.expiryDate,
    this.certificateNumber,
    required this.isValid,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  bool get expiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      issuingAuthority: json['issuingAuthority'] ?? '',
      issuedDate: DateTime.parse(
          json['issuedDate'] ?? DateTime.now().toIso8601String()),
      expiryDate: DateTime.parse(
          json['expiryDate'] ?? DateTime.now().toIso8601String()),
      certificateNumber: json['certificateNumber'],
      isValid: json['isValid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuingAuthority': issuingAuthority,
      'issuedDate': issuedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'certificateNumber': certificateNumber,
      'isValid': isValid,
    };
  }
}

class DriverExperience {
  final int totalYears;
  final int totalKilometers;
  final int totalTrips;
  final List<String> previousEmployers;
  final List<String> routesExperience;
  final DateTime startDate;
  final String specialNotes;

  DriverExperience({
    required this.totalYears,
    required this.totalKilometers,
    required this.totalTrips,
    required this.previousEmployers,
    required this.routesExperience,
    required this.startDate,
    required this.specialNotes,
  });

  factory DriverExperience.fromJson(Map<String, dynamic> json) {
    return DriverExperience(
      totalYears: json['totalYears'] ?? 0,
      totalKilometers: json['totalKilometers'] ?? 0,
      totalTrips: json['totalTrips'] ?? 0,
      previousEmployers: List<String>.from(json['previousEmployers'] ?? []),
      routesExperience: List<String>.from(json['routesExperience'] ?? []),
      startDate:
          DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      specialNotes: json['specialNotes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalYears': totalYears,
      'totalKilometers': totalKilometers,
      'totalTrips': totalTrips,
      'previousEmployers': previousEmployers,
      'routesExperience': routesExperience,
      'startDate': startDate.toIso8601String(),
      'specialNotes': specialNotes,
    };
  }
}

class DriverPerformance {
  final double overallRating;
  final int totalRatings;
  final double punctualityScore;
  final double safetyIncidents;
  final double fuelEfficiencyScore;
  final double customerSatisfaction;
  final int compliments;
  final int complaints;
  final List<PerformanceMetric> monthlyMetrics;
  final DateTime lastEvaluationDate;

  DriverPerformance({
    required this.overallRating,
    required this.totalRatings,
    required this.punctualityScore,
    required this.safetyIncidents,
    required this.fuelEfficiencyScore,
    required this.customerSatisfaction,
    required this.compliments,
    required this.complaints,
    required this.monthlyMetrics,
    required this.lastEvaluationDate,
  });

  factory DriverPerformance.fromJson(Map<String, dynamic> json) {
    return DriverPerformance(
      overallRating: json['overallRating']?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] ?? 0,
      punctualityScore: json['punctualityScore']?.toDouble() ?? 0.0,
      safetyIncidents: json['safetyIncidents']?.toDouble() ?? 0.0,
      fuelEfficiencyScore: json['fuelEfficiencyScore']?.toDouble() ?? 0.0,
      customerSatisfaction: json['customerSatisfaction']?.toDouble() ?? 0.0,
      compliments: json['compliments'] ?? 0,
      complaints: json['complaints'] ?? 0,
      monthlyMetrics: (json['monthlyMetrics'] as List<dynamic>?)
              ?.map((e) => PerformanceMetric.fromJson(e))
              .toList() ??
          [],
      lastEvaluationDate: DateTime.parse(
          json['lastEvaluationDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallRating': overallRating,
      'totalRatings': totalRatings,
      'punctualityScore': punctualityScore,
      'safetyIncidents': safetyIncidents,
      'fuelEfficiencyScore': fuelEfficiencyScore,
      'customerSatisfaction': customerSatisfaction,
      'compliments': compliments,
      'complaints': complaints,
      'monthlyMetrics': monthlyMetrics.map((e) => e.toJson()).toList(),
      'lastEvaluationDate': lastEvaluationDate.toIso8601String(),
    };
  }
}

class PerformanceMetric {
  final DateTime month;
  final double rating;
  final int trips;
  final double safetyScore;
  final int incidents;
  final double punctuality;

  PerformanceMetric({
    required this.month,
    required this.rating,
    required this.trips,
    required this.safetyScore,
    required this.incidents,
    required this.punctuality,
  });

  factory PerformanceMetric.fromJson(Map<String, dynamic> json) {
    return PerformanceMetric(
      month: DateTime.parse(json['month'] ?? DateTime.now().toIso8601String()),
      rating: json['rating']?.toDouble() ?? 0.0,
      trips: json['trips'] ?? 0,
      safetyScore: json['safetyScore']?.toDouble() ?? 0.0,
      incidents: json['incidents'] ?? 0,
      punctuality: json['punctuality']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month.toIso8601String(),
      'rating': rating,
      'trips': trips,
      'safetyScore': safetyScore,
      'incidents': incidents,
      'punctuality': punctuality,
    };
  }
}

class TrainingRecord {
  final String id;
  final String name;
  final String description;
  final DateTime completedDate;
  final String instructor;
  final double score;
  final bool passed;
  final String? certificateUrl;

  TrainingRecord({
    required this.id,
    required this.name,
    required this.description,
    required this.completedDate,
    required this.instructor,
    required this.score,
    required this.passed,
    this.certificateUrl,
  });

  factory TrainingRecord.fromJson(Map<String, dynamic> json) {
    return TrainingRecord(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      completedDate: DateTime.parse(
          json['completedDate'] ?? DateTime.now().toIso8601String()),
      instructor: json['instructor'] ?? '',
      score: json['score']?.toDouble() ?? 0.0,
      passed: json['passed'] ?? false,
      certificateUrl: json['certificateUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'completedDate': completedDate.toIso8601String(),
      'instructor': instructor,
      'score': score,
      'passed': passed,
      'certificateUrl': certificateUrl,
    };
  }
}

class HealthRecord {
  final DateTime lastMedicalExam;
  final DateTime nextMedicalExam;
  final bool isHealthy;
  final List<String> medicalConditions;
  final List<String> medications;
  final bool hasRestrictions;
  final String? restrictions;

  HealthRecord({
    required this.lastMedicalExam,
    required this.nextMedicalExam,
    required this.isHealthy,
    required this.medicalConditions,
    required this.medications,
    required this.hasRestrictions,
    this.restrictions,
  });

  bool get medicalExamDue => DateTime.now().isAfter(nextMedicalExam);

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      lastMedicalExam: DateTime.parse(
          json['lastMedicalExam'] ?? DateTime.now().toIso8601String()),
      nextMedicalExam: DateTime.parse(
          json['nextMedicalExam'] ?? DateTime.now().toIso8601String()),
      isHealthy: json['isHealthy'] ?? true,
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      hasRestrictions: json['hasRestrictions'] ?? false,
      restrictions: json['restrictions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastMedicalExam': lastMedicalExam.toIso8601String(),
      'nextMedicalExam': nextMedicalExam.toIso8601String(),
      'isHealthy': isHealthy,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'hasRestrictions': hasRestrictions,
      'restrictions': restrictions,
    };
  }
}

class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;
  final String? email;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.email,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      relationship: json['relationship'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'email': email,
    };
  }
}
