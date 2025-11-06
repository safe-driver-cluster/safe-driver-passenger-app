import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for passenger details stored in passenger_details collection
class PassengerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final PassengerAddress? address;
  final PassengerEmergencyContact? emergencyContact;
  final PassengerPreferences preferences;
  final PassengerStats stats;
  final List<String> favoriteRoutes;
  final List<String> favoriteBuses;
  final List<String> recentSearches;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final bool isActive;

  PassengerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.emergencyContact,
    required this.preferences,
    required this.stats,
    this.favoriteRoutes = const [],
    this.favoriteBuses = const [],
    this.recentSearches = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  String get displayName => firstName.isNotEmpty ? firstName : email;

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    return PassengerModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? (json['dateOfBirth'] is Timestamp 
              ? (json['dateOfBirth'] as Timestamp).toDate()
              : DateTime.parse(json['dateOfBirth']))
          : null,
      gender: json['gender'],
      address: json['address'] != null 
          ? PassengerAddress.fromJson(json['address']) 
          : null,
      emergencyContact: json['emergencyContact'] != null
          ? PassengerEmergencyContact.fromJson(json['emergencyContact'])
          : null,
      preferences: PassengerPreferences.fromJson(json['preferences'] ?? {}),
      stats: PassengerStats.fromJson(json['stats'] ?? {}),
      favoriteRoutes: List<String>.from(json['favoriteRoutes'] ?? []),
      favoriteBuses: List<String>.from(json['favoriteBuses'] ?? []),
      recentSearches: List<String>.from(json['recentSearches'] ?? []),
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] is Timestamp 
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? (json['updatedAt'] is Timestamp 
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  factory PassengerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PassengerModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address?.toJson(),
      'emergencyContact': emergencyContact?.toJson(),
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'favorites': {
        'routes': favoriteRoutes,
        'buses': favoriteBuses,
      },
      'recentSearches': recentSearches,
      'isVerified': isVerified,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PassengerModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    PassengerAddress? address,
    PassengerEmergencyContact? emergencyContact,
    PassengerPreferences? preferences,
    PassengerStats? stats,
    List<String>? favoriteRoutes,
    List<String>? favoriteBuses,
    List<String>? recentSearches,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
  }) {
    return PassengerModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      favoriteRoutes: favoriteRoutes ?? this.favoriteRoutes,
      favoriteBuses: favoriteBuses ?? this.favoriteBuses,
      recentSearches: recentSearches ?? this.recentSearches,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'PassengerModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
  }
}

class PassengerAddress {
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final double? latitude;
  final double? longitude;

  PassengerAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  String get fullAddress => '$street, $city, $postalCode, $country';

  factory PassengerAddress.fromJson(Map<String, dynamic> json) {
    return PassengerAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      latitude: json['coordinates']?['latitude']?.toDouble(),
      longitude: json['coordinates']?['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}

class PassengerEmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;

  PassengerEmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  factory PassengerEmergencyContact.fromJson(Map<String, dynamic> json) {
    return PassengerEmergencyContact(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      relationship: json['relationship'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }
}

class PassengerPreferences {
  final String language;
  final String theme;
  final PassengerNotificationSettings notifications;
  final PassengerPrivacySettings privacy;

  PassengerPreferences({
    this.language = 'en',
    this.theme = 'system',
    PassengerNotificationSettings? notifications,
    PassengerPrivacySettings? privacy,
  }) : notifications = notifications ?? PassengerNotificationSettings(),
       privacy = privacy ?? PassengerPrivacySettings();

  factory PassengerPreferences.fromJson(Map<String, dynamic> json) {
    return PassengerPreferences(
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      notifications: PassengerNotificationSettings.fromJson(json['notifications'] ?? {}),
      privacy: PassengerPrivacySettings.fromJson(json['privacy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notifications': notifications.toJson(),
      'privacy': privacy.toJson(),
    };
  }
}

class PassengerNotificationSettings {
  final bool safetyAlerts;
  final bool journeyUpdates;
  final bool emergencyAlerts;
  final bool systemAnnouncements;

  PassengerNotificationSettings({
    this.safetyAlerts = true,
    this.journeyUpdates = true,
    this.emergencyAlerts = true,
    this.systemAnnouncements = true,
  });

  factory PassengerNotificationSettings.fromJson(Map<String, dynamic> json) {
    return PassengerNotificationSettings(
      safetyAlerts: json['safetyAlerts'] ?? true,
      journeyUpdates: json['journeyUpdates'] ?? true,
      emergencyAlerts: json['emergencyAlerts'] ?? true,
      systemAnnouncements: json['systemAnnouncements'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'safetyAlerts': safetyAlerts,
      'journeyUpdates': journeyUpdates,
      'emergencyAlerts': emergencyAlerts,
      'systemAnnouncements': systemAnnouncements,
    };
  }
}

class PassengerPrivacySettings {
  final bool shareLocation;
  final bool shareJourneyData;

  PassengerPrivacySettings({
    this.shareLocation = true,
    this.shareJourneyData = true,
  });

  factory PassengerPrivacySettings.fromJson(Map<String, dynamic> json) {
    return PassengerPrivacySettings(
      shareLocation: json['shareLocation'] ?? true,
      shareJourneyData: json['shareJourneyData'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shareLocation': shareLocation,
      'shareJourneyData': shareJourneyData,
    };
  }
}

class PassengerStats {
  final int todayTrips;
  final int totalTrips;
  final double carbonSaved;
  final int pointsEarned;
  final double safetyScore;

  PassengerStats({
    this.todayTrips = 0,
    this.totalTrips = 0,
    this.carbonSaved = 0.0,
    this.pointsEarned = 0,
    this.safetyScore = 5.0,
  });

  factory PassengerStats.fromJson(Map<String, dynamic> json) {
    return PassengerStats(
      todayTrips: json['todayTrips']?.toInt() ?? 0,
      totalTrips: json['totalTrips']?.toInt() ?? 0,
      carbonSaved: json['carbonSaved']?.toDouble() ?? 0.0,
      pointsEarned: json['pointsEarned']?.toInt() ?? 0,
      safetyScore: json['safetyScore']?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayTrips': todayTrips,
      'totalTrips': totalTrips,
      'carbonSaved': carbonSaved,
      'pointsEarned': pointsEarned,
      'safetyScore': safetyScore,
    };
  }
}