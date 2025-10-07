import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/firebase_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

// Auth state enum
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

// Auth controller state class
class AuthControllerState {
  final AuthState state;
  final UserModel? user;
  final String? error;
  final bool isLoading;

  const AuthControllerState({
    required this.state,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthControllerState copyWith({
    AuthState? state,
    UserModel? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthControllerState(
      state: state ?? this.state,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Auth controller
class AuthController extends StateNotifier<AuthControllerState> {
  final FirebaseService _firebaseService;
  final StorageService _storageService;
  final NotificationService _notificationService;
  final UserRepository _userRepository;

  StreamSubscription? _authStateSubscription;

  AuthController({
    required FirebaseService firebaseService,
    required StorageService storageService,
    required NotificationService notificationService,
    required UserRepository userRepository,
  })  : _firebaseService = firebaseService,
        _storageService = storageService,
        _notificationService = notificationService,
        _userRepository = userRepository,
        super(const AuthControllerState(state: AuthState.initial)) {
    _initializeAuthListener();
  }

  /// Initialize authentication state listener
  void _initializeAuthListener() {
    _authStateSubscription = _firebaseService.authStateChanges.listen(
      (user) async {
        if (user != null) {
          await _handleUserAuthenticated(user.uid);
        } else {
          await _handleUserUnauthenticated();
        }
      },
      onError: (error) {
        state = state.copyWith(
          state: AuthState.error,
          error: 'Authentication error: $error',
          isLoading: false,
        );
      },
    );
  }

  /// Handle user authenticated
  Future<void> _handleUserAuthenticated(String uid) async {
    try {
      state = state.copyWith(isLoading: true);

      // Get user data from repository
      final userData = await _userRepository.getUserById(uid);

      if (userData != null) {
        // Cache user data locally
        await _storageService.saveUserProfile(userData.toJson());

        // Set up notifications
        await _setupUserNotifications(userData);

        state = state.copyWith(
          state: AuthState.authenticated,
          user: userData,
          isLoading: false,
          error: null,
        );
      } else {
        // User data not found, redirect to profile completion
        state = state.copyWith(
          state: AuthState.unauthenticated,
          isLoading: false,
          error: 'User profile not found. Please complete your profile.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: 'Failed to load user data: $e',
        isLoading: false,
      );
    }
  }

  /// Handle user unauthenticated
  Future<void> _handleUserUnauthenticated() async {
    // Clear local data
    await _storageService.clearUserProfile();
    await _storageService.clearUserToken();

    state = state.copyWith(
      state: AuthState.unauthenticated,
      user: null,
      isLoading: false,
      error: null,
    );
  }

  /// Set up user notifications
  Future<void> _setupUserNotifications(UserModel user) async {
    try {
      // Get FCM token
      final fcmToken = await _notificationService.getFCMToken();
      if (fcmToken != null) {
        // Update user FCM token in database
        await _userRepository.updateUserFCMToken(user.id, fcmToken);
      }

      // Subscribe to user-specific topics
      await _notificationService.subscribeToTopic('user_${user.id}');

      // Subscribe to general topics based on user preferences
      if (user.preferences.safetyAlertsEnabled) {
        await _notificationService.subscribeToTopic('safety_alerts');
      }

      if (user.preferences.journeyUpdatesEnabled) {
        await _notificationService.subscribeToTopic('bus_updates');
      }
    } catch (e) {
      print('Failed to setup notifications: $e');
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential = await _firebaseService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential?.user != null) {
        // Save user token
        final token = await userCredential!.user!.getIdToken();
        if (token != null) {
          await _storageService.saveUserToken(token);
        }

        // Auth state listener will handle the rest
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Create account with email and password
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential =
          await _firebaseService.createUserWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential?.user != null) {
        // Save user token
        final token = await userCredential!.user!.getIdToken();
        if (token != null) {
          await _storageService.saveUserToken(token);
        }

        // Create basic user profile with required fields
        final basicUser = UserModel(
          id: userCredential.user!.uid,
          firstName: '',
          lastName: '',
          email: email,
          phoneNumber: '',
          dateOfBirth: DateTime.now()
              .subtract(const Duration(days: 365 * 18)), // Default 18 years ago
          gender: '',
          address: Address(
            street: '',
            city: '',
            state: '',
            zipCode: '',
            country: '',
          ),
          emergencyContact: EmergencyContact(
            name: '',
            phoneNumber: '',
            relationship: '',
          ),
          preferences: UserPreferences(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(basicUser);
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Register user with complete details
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential =
          await _firebaseService.createUserWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential?.user != null) {
        // Save user token
        final token = await userCredential!.user!.getIdToken();
        if (token != null) {
          await _storageService.saveUserToken(token);
        }

        // Update display name
        final fullName = '$firstName $lastName';
        await userCredential.user!.updateDisplayName(fullName);

        // Create complete user profile
        final userModel = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: DateTime.now()
              .subtract(const Duration(days: 365 * 18)), // Default 18 years ago
          gender: '',
          address: Address(
            street: '',
            city: '',
            state: '',
            zipCode: '',
            country: '',
          ),
          emergencyContact: EmergencyContact(
            name: '',
            phoneNumber: '',
            relationship: '',
          ),
          preferences: UserPreferences(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(userModel);

        // Auth state listener will handle the rest
        return true;
      } else {
        state = state.copyWith(
          state: AuthState.error,
          error: 'Registration failed',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final userCredential = await _firebaseService.signInWithGoogle();

      if (userCredential?.user != null) {
        // Save user token
        final token = await userCredential!.user!.getIdToken();
        if (token != null) {
          await _storageService.saveUserToken(token);
        }

        // Auth state listener will handle the rest
        return true;
      } else {
        state = state.copyWith(
          state: AuthState.error,
          error: 'Google sign-in was cancelled',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: e.toString(),
        isLoading: false,
      );
      return false;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firebaseService.sendPasswordResetEmail(email);

      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);

      // Unsubscribe from notifications
      if (state.user != null) {
        await _notificationService
            .unsubscribeFromTopic('user_${state.user!.id}');
        await _notificationService.unsubscribeFromTopic('safety_alerts');
        await _notificationService.unsubscribeFromTopic('bus_updates');
      }

      await _firebaseService.signOut();

      // Auth state listener will handle clearing the state
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: 'Sign out failed: $e',
        isLoading: false,
      );
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      state = state.copyWith(isLoading: true);

      await _userRepository.updateUser(updatedUser);

      // Update local cache
      await _storageService.saveUserProfile(updatedUser.toJson());

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: 'Failed to update profile: $e',
        isLoading: false,
      );
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      state = state.copyWith(isLoading: true);

      await _firebaseService.deleteAccount();

      // Auth state listener will handle clearing the state
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: 'Failed to delete account: $e',
        isLoading: false,
      );
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state.state == AuthState.authenticated;

  /// Get current user
  UserModel? get currentUser => state.user;

  /// Check authentication status on app start
  Future<void> checkAuthenticationStatus() async {
    try {
      state = state.copyWith(isLoading: true);

      final currentUser = _firebaseService.currentUser;

      if (currentUser != null) {
        // User is signed in, get user data
        await _handleUserAuthenticated(currentUser.uid);
      } else {
        // Check for cached user token
        final cachedToken = _storageService.getUserToken();
        if (cachedToken != null) {
          // Try to validate cached token
          // This would typically involve verifying the token with the server
          // For now, we'll just check if Firebase auth is still valid
          if (_firebaseService.currentUser != null) {
            await _handleUserAuthenticated(_firebaseService.currentUser!.uid);
          } else {
            await _handleUserUnauthenticated();
          }
        } else {
          await _handleUserUnauthenticated();
        }
      }
    } catch (e) {
      state = state.copyWith(
        state: AuthState.error,
        error: 'Failed to check authentication status: $e',
        isLoading: false,
      );
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    if (state.user != null) {
      try {
        final userData = await _userRepository.getUserById(state.user!.id);
        if (userData != null) {
          await _storageService.saveUserProfile(userData.toJson());
          state = state.copyWith(user: userData);
        }
      } catch (e) {
        print('Failed to refresh user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}

// Providers
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  return AuthController(
    firebaseService: ref.read(firebaseServiceProvider),
    storageService: ref.read(storageServiceProvider),
    notificationService: ref.read(notificationServiceProvider),
    userRepository: ref.read(userRepositoryProvider),
  );
});

// Helper providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authControllerProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).state == AuthState.authenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).error;
});
