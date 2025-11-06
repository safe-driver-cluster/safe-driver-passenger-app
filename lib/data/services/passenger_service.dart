import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/passenger_model.dart';

/// Service for managing passenger data in the passenger_details collection
class PassengerService {
  static final PassengerService _instance = PassengerService._internal();
  static PassengerService get instance => _instance;
  PassengerService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'passenger_details';

  /// Create a new passenger profile
  Future<void> createPassengerProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      print('🚀 Starting to create passenger profile for user: $userId');
      print('📝 Data: $firstName $lastName, $email, $phoneNumber');
      
      final now = DateTime.now();
      final passengerData = PassengerModel(
        id: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        preferences: PassengerPreferences(),
        stats: PassengerStats(),
        createdAt: now,
        updatedAt: now,
      );

      print('🔄 Converting to JSON...');
      final jsonData = passengerData.toJson();
      print('📋 JSON Data: $jsonData');

      print('🔥 Saving to Firestore collection: $_collection');
      await _firestore
          .collection(_collection)
          .doc(userId)
          .set(jsonData);
      
      print('✅ Passenger profile created successfully!');
    } catch (e) {
      print('❌ Error creating passenger profile: $e');
      print('🔍 Error type: ${e.runtimeType}');
      throw Exception('Failed to create passenger profile: $e');
    }
  }

  /// Get passenger profile by ID
  Future<PassengerModel?> getPassengerProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return PassengerModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get passenger profile: $e');
    }
  }

  /// Update passenger profile
  Future<void> updatePassengerProfile({
    required String userId,
    required PassengerModel passenger,
  }) async {
    try {
      final updatedPassenger = passenger.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(userId)
          .update(updatedPassenger.toJson());
    } catch (e) {
      throw Exception('Failed to update passenger profile: $e');
    }
  }

  /// Update specific passenger fields
  Future<void> updatePassengerFields({
    required String userId,
    Map<String, dynamic>? fields,
  }) async {
    if (fields == null || fields.isEmpty) return;

    try {
      final updateData = {
        ...fields,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection(_collection)
          .doc(userId)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update passenger fields: $e');
    }
  }

  /// Update passenger preferences
  Future<void> updatePassengerPreferences({
    required String userId,
    required PassengerPreferences preferences,
  }) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'preferences': preferences.toJson()},
      );
    } catch (e) {
      throw Exception('Failed to update passenger preferences: $e');
    }
  }

  /// Update passenger stats
  Future<void> updatePassengerStats({
    required String userId,
    required PassengerStats stats,
  }) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'stats': stats.toJson()},
      );
    } catch (e) {
      throw Exception('Failed to update passenger stats: $e');
    }
  }

  /// Add to favorite routes
  Future<void> addFavoriteRoute({
    required String userId,
    required String routeId,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .update({
        'favorites.routes': FieldValue.arrayUnion([routeId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add favorite route: $e');
    }
  }

  /// Remove from favorite routes
  Future<void> removeFavoriteRoute({
    required String userId,
    required String routeId,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .update({
        'favorites.routes': FieldValue.arrayRemove([routeId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to remove favorite route: $e');
    }
  }

  /// Add to favorite buses
  Future<void> addFavoriteBus({
    required String userId,
    required String busId,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .update({
        'favorites.buses': FieldValue.arrayUnion([busId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add favorite bus: $e');
    }
  }

  /// Remove from favorite buses
  Future<void> removeFavoriteBus({
    required String userId,
    required String busId,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .update({
        'favorites.buses': FieldValue.arrayRemove([busId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to remove favorite bus: $e');
    }
  }

  /// Add recent search
  Future<void> addRecentSearch({
    required String userId,
    required String searchQuery,
  }) async {
    try {
      final passenger = await getPassengerProfile(userId);
      if (passenger == null) return;

      List<String> recentSearches = List.from(passenger.recentSearches);

      // Remove if already exists
      recentSearches.removeWhere((search) => search == searchQuery);

      // Add to beginning
      recentSearches.insert(0, searchQuery);

      // Keep only last 10 searches
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.take(10).toList();
      }

      await updatePassengerFields(
        userId: userId,
        fields: {'recentSearches': recentSearches},
      );
    } catch (e) {
      throw Exception('Failed to add recent search: $e');
    }
  }

  /// Update profile image URL
  Future<void> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'profileImageUrl': imageUrl},
      );
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  /// Mark passenger as verified
  Future<void> markPassengerVerified(String userId) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'isVerified': true},
      );
    } catch (e) {
      throw Exception('Failed to mark passenger as verified: $e');
    }
  }

  /// Deactivate passenger account
  Future<void> deactivatePassenger(String userId) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'isActive': false},
      );
    } catch (e) {
      throw Exception('Failed to deactivate passenger: $e');
    }
  }

  /// Reactivate passenger account
  Future<void> reactivatePassenger(String userId) async {
    try {
      await updatePassengerFields(
        userId: userId,
        fields: {'isActive': true},
      );
    } catch (e) {
      throw Exception('Failed to reactivate passenger: $e');
    }
  }

  /// Delete passenger profile
  Future<void> deletePassengerProfile(String userId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete passenger profile: $e');
    }
  }

  /// Get passenger profile stream for real-time updates
  Stream<PassengerModel?> getPassengerProfileStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return PassengerModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Search passengers by name (for admin use)
  Future<List<PassengerModel>> searchPassengersByName(
      String searchQuery) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      final passengers = querySnapshot.docs
          .map((doc) => PassengerModel.fromFirestore(doc))
          .where((passenger) {
        final fullName = passenger.fullName.toLowerCase();
        final query = searchQuery.toLowerCase();
        return fullName.contains(query);
      }).toList();

      return passengers;
    } catch (e) {
      throw Exception('Failed to search passengers: $e');
    }
  }

  /// Get passenger statistics for dashboard
  Future<Map<String, dynamic>> getPassengerStatistics() async {
    try {
      final querySnapshot =
          await _firestore.collection(_collection).get();

      int totalPassengers = 0;
      int verifiedPassengers = 0;
      int activePassengers = 0;
      double totalCarbonSaved = 0.0;
      int totalTrips = 0;

      for (final doc in querySnapshot.docs) {
        final passenger = PassengerModel.fromFirestore(doc);
        totalPassengers++;

        if (passenger.isVerified) verifiedPassengers++;
        if (passenger.isActive) activePassengers++;

        totalCarbonSaved += passenger.stats.carbonSaved;
        totalTrips += passenger.stats.totalTrips;
      }

      return {
        'totalPassengers': totalPassengers,
        'verifiedPassengers': verifiedPassengers,
        'activePassengers': activePassengers,
        'totalCarbonSaved': totalCarbonSaved,
        'totalTrips': totalTrips,
      };
    } catch (e) {
      throw Exception('Failed to get passenger statistics: $e');
    }
  }
}
