import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';

/// Provider for Firebase Auth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provider for current user stream
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  return auth.authStateChanges();
});

/// Provider for current user data
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        // Return a demo user for now - replace with actual user data fetching
        return UserModel(
          id: user.uid,
          firstName: user.displayName?.split(' ').first ?? 'John',
          lastName: user.displayName?.split(' ').last ?? 'Doe',
          email: user.email ?? 'user@example.com',
          phoneNumber: user.phoneNumber ?? '+1234567890',
          profileImageUrl: user.photoURL,
          dateOfBirth: DateTime.now().subtract(const Duration(days: 10000)),
          gender: 'Male',
          address: Address(
            street: '123 Main St',
            city: 'City',
            state: 'State',
            zipCode: '12345',
            country: 'Country',
            latitude: 0.0,
            longitude: 0.0,
          ),
          emergencyContact: EmergencyContact(
            name: 'Emergency Contact',
            phoneNumber: '+1234567890',
            relationship: 'Friend',
          ),
          preferences: UserPreferences(
            language: 'en',
            theme: 'light',
            notificationsEnabled: true,
            locationSharingEnabled: true,
            biometricAuthEnabled: false,
            emailNotificationsEnabled: true,
            smsNotificationsEnabled: false,
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
          updatedAt: DateTime.now(),
          isVerified: true,
          isActive: true,
        );
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for user authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Simple user data provider for immediate use
final simpleUserProvider = Provider<Map<String, String>>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user != null) {
        return {
          'id': user.uid,
          'name': user.displayName ?? 'John Doe',
          'email': user.email ?? 'user@example.com',
        };
      }
      // Return demo user if not authenticated
      return {
        'id': 'demo_user_001',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
      };
    },
    loading: () => {
      'id': 'demo_user_001',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    },
    error: (_, __) => {
      'id': 'demo_user_001',
      'name': 'John Doe',
      'email': 'john.doe@example.com',
    },
  );
});
