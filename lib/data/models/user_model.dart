import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final Address address;
  final EmergencyContact emergencyContact;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final bool isActive;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.emergencyContact,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  String get displayName => firstName.isNotEmpty ? firstName : email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      dateOfBirth: DateTime.parse(
          json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      gender: json['gender'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      emergencyContact:
          EmergencyContact.fromJson(json['emergencyContact'] ?? {}),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
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
      'gender': gender,
      'address': address.toJson(),
      'emergencyContact': emergencyContact.toJson(),
      'preferences': preferences.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVerified': isVerified,
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    Address? address,
    EmergencyContact? emergencyContact,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
  }) {
    return UserModel(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, email: $email)';
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  String get fullAddress => '$street, $city, $state $zipCode, $country';

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
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

  EmergencyContact copyWith({
    String? name,
    String? phoneNumber,
    String? relationship,
    String? email,
  }) {
    return EmergencyContact(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      email: email ?? this.email,
    );
  }
}

class UserPreferences {
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final bool notificationsEnabled;
  final bool locationSharingEnabled;
  final bool biometricAuthEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final bool safetyAlertsEnabled;
  final bool journeyUpdatesEnabled;
  final bool emergencyAlertsEnabled;
  final bool systemAnnouncementsEnabled;

  UserPreferences({
    this.language = 'en',
    this.theme = 'system',
    this.notificationsEnabled = true,
    this.locationSharingEnabled = true,
    this.biometricAuthEnabled = false,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = true,
    this.safetyAlertsEnabled = true,
    this.journeyUpdatesEnabled = true,
    this.emergencyAlertsEnabled = true,
    this.systemAnnouncementsEnabled = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'system',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      locationSharingEnabled: json['locationSharingEnabled'] ?? true,
      biometricAuthEnabled: json['biometricAuthEnabled'] ?? false,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? true,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] ?? true,
      safetyAlertsEnabled: json['safetyAlertsEnabled'] ?? true,
      journeyUpdatesEnabled: json['journeyUpdatesEnabled'] ?? true,
      emergencyAlertsEnabled: json['emergencyAlertsEnabled'] ?? true,
      systemAnnouncementsEnabled: json['systemAnnouncementsEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'locationSharingEnabled': locationSharingEnabled,
      'biometricAuthEnabled': biometricAuthEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'safetyAlertsEnabled': safetyAlertsEnabled,
      'journeyUpdatesEnabled': journeyUpdatesEnabled,
      'emergencyAlertsEnabled': emergencyAlertsEnabled,
      'systemAnnouncementsEnabled': systemAnnouncementsEnabled,
    };
  }

  UserPreferences copyWith({
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? locationSharingEnabled,
    bool? biometricAuthEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? safetyAlertsEnabled,
    bool? journeyUpdatesEnabled,
    bool? emergencyAlertsEnabled,
    bool? systemAnnouncementsEnabled,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      emailNotificationsEnabled:
          emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled:
          smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      safetyAlertsEnabled: safetyAlertsEnabled ?? this.safetyAlertsEnabled,
      journeyUpdatesEnabled:
          journeyUpdatesEnabled ?? this.journeyUpdatesEnabled,
      emergencyAlertsEnabled:
          emergencyAlertsEnabled ?? this.emergencyAlertsEnabled,
      systemAnnouncementsEnabled:
          systemAnnouncementsEnabled ?? this.systemAnnouncementsEnabled,
    );
  }
}
