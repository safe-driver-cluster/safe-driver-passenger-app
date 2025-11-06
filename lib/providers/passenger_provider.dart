import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/firebase_service.dart';
import '../data/models/passenger_model.dart';
import '../data/services/passenger_service.dart';

/// Provider for the current passenger's user ID
final currentUserIdProvider = StateProvider<String?>((ref) => null);

/// Provider for the current authenticated user
final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseService.instance.auth.authStateChanges();
});

/// Provider for passenger service
final passengerServiceProvider = Provider<PassengerService>((ref) {
  return PassengerService.instance;
});

/// Provider for current passenger profile
final currentPassengerProvider = StreamProvider<PassengerModel?>((ref) {
  final user = ref.watch(currentUserProvider);

  return user.when(
    data: (user) {
      if (user != null) {
        final passengerService = ref.watch(passengerServiceProvider);
        return passengerService.getPassengerProfileStream(user.uid);
      } else {
        return Stream.value(null);
      }
    },
    loading: () => Stream.value(null),
    error: (error, stackTrace) => Stream.value(null),
  );
});

/// Provider for passenger controller
final passengerControllerProvider =
    StateNotifierProvider<PassengerController, AsyncValue<void>>((ref) {
  return PassengerController(ref);
});

/// Controller for managing passenger operations
class PassengerController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  late final PassengerService _passengerService;

  PassengerController(this._ref) : super(const AsyncValue.data(null)) {
    _passengerService = _ref.read(passengerServiceProvider);
  }

  /// Update passenger profile
  Future<void> updateProfile(PassengerModel passenger) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.updatePassengerProfile(
        userId: passenger.id,
        passenger: passenger,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update passenger preferences
  Future<void> updatePreferences({
    required String userId,
    required PassengerPreferences preferences,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.updatePassengerPreferences(
        userId: userId,
        preferences: preferences,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update passenger stats
  Future<void> updateStats({
    required String userId,
    required PassengerStats stats,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.updatePassengerStats(
        userId: userId,
        stats: stats,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Add favorite route
  Future<void> addFavoriteRoute({
    required String userId,
    required String routeId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.addFavoriteRoute(
        userId: userId,
        routeId: routeId,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Remove favorite route
  Future<void> removeFavoriteRoute({
    required String userId,
    required String routeId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.removeFavoriteRoute(
        userId: userId,
        routeId: routeId,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Add favorite bus
  Future<void> addFavoriteBus({
    required String userId,
    required String busId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.addFavoriteBus(
        userId: userId,
        busId: busId,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Remove favorite bus
  Future<void> removeFavoriteBus({
    required String userId,
    required String busId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.removeFavoriteBus(
        userId: userId,
        busId: busId,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Add recent search
  Future<void> addRecentSearch({
    required String userId,
    required String searchQuery,
  }) async {
    try {
      await _passengerService.addRecentSearch(
        userId: userId,
        searchQuery: searchQuery,
      );
    } catch (e) {
      // Don't set loading state for recent searches as it's a background operation
      print('Failed to add recent search: $e');
    }
  }

  /// Update profile image
  Future<void> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.updateProfileImage(
        userId: userId,
        imageUrl: imageUrl,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update specific passenger fields
  Future<void> updateFields({
    required String userId,
    required Map<String, dynamic> fields,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.updatePassengerFields(
        userId: userId,
        fields: fields,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Mark passenger as verified
  Future<void> markVerified(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.markPassengerVerified(userId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Deactivate passenger account
  Future<void> deactivateAccount(String userId) async {
    state = const AsyncValue.loading();
    try {
      await _passengerService.deactivatePassenger(userId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
