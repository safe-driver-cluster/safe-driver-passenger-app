import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/auth_service.dart';
import '../data/services/passenger_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Firebase user provider that listens to Firebase Auth state
final firebaseUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Auth state provider for UI
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

// Auth state model
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isRemembered;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isRemembered = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isRemembered,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRemembered: isRemembered ?? this.isRemembered,
    );
  }
}

// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._ref) : super(const AuthState()) {
    _initialize();
  }

  final Ref _ref;
  late final AuthService _authService;
  late final PassengerService _passengerService;

  void _initialize() {
    _authService = _ref.read(authServiceProvider);
    _passengerService = PassengerService.instance;

    // Listen to Firebase Auth state changes
    _ref.listen(firebaseUserProvider, (previous, next) {
      next.when(
        data: (user) {
          state = state.copyWith(user: user, isLoading: false, error: null);
        },
        loading: () {
          state = state.copyWith(isLoading: true, error: null);
        },
        error: (error, stackTrace) {
          state = state.copyWith(
            isLoading: false,
            error: error.toString(),
            user: null,
          );
        },
      );
    });

    // Check for auto-login on initialization
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      state = state.copyWith(isLoading: true);

      // Check if user is already signed in (Firebase persistence)
      if (_authService.currentUser != null) {
        final isRemembered = await _authService.isRememberMeEnabled();
        state = state.copyWith(
          user: _authService.currentUser,
          isLoading: false,
          isRemembered: isRemembered,
        );
        return;
      }

      // Attempt auto-login if enabled
      final autoLoginSuccess = await _authService.attemptAutoLogin();
      if (autoLoginSuccess) {
        state = state.copyWith(isRemembered: true);
      }

      final isRemembered = await _authService.isRememberMeEnabled();
      state = state.copyWith(
        isLoading: false,
        isRemembered: isRemembered,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🎯 Starting sign in process for: $email');
      state = state.copyWith(isLoading: true, error: null);

      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      print('🎉 Sign in successful!');
      state = state.copyWith(
        isLoading: false,
        isRemembered: rememberMe,
      );
    } catch (e) {
      print('💥 Sign in error in provider: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Create Firebase Auth user
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create passenger profile
        await _passengerService.createPassengerProfile(
          userId: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
        );
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      // Handle the PigeonUserDetails error gracefully
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('List<Object?>')) {
        // Check if user was actually created despite the error
        await Future.delayed(const Duration(seconds: 1));

        if (_authService.currentUser != null) {
          try {
            // Create passenger profile
            await _passengerService.createPassengerProfile(
              userId: _authService.currentUser!.uid,
              firstName: firstName,
              lastName: lastName,
              email: email,
              phoneNumber: phoneNumber,
            );

            state = state.copyWith(isLoading: false);
            return;
          } catch (profileError) {
            print('Error creating passenger profile: $profileError');
          }
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authService.signOut();
      state = state.copyWith(
        user: null,
        isLoading: false,
        isRemembered: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _authService.resetPassword(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<String?> getSavedEmail() async {
    return await _authService.getSavedEmail();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
