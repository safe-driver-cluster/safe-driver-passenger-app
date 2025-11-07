import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/passenger_model.dart';
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
  final PassengerModel? passengerProfile;
  final bool isLoading;
  final String? error;
  final bool isRemembered;
  final bool isEmailVerified;
  final AuthStep currentStep;

  const AuthState({
    this.user,
    this.passengerProfile,
    this.isLoading = false,
    this.error,
    this.isRemembered = false,
    this.isEmailVerified = false,
    this.currentStep = AuthStep.signIn,
  });

  AuthState copyWith({
    User? user,
    PassengerModel? passengerProfile,
    bool? isLoading,
    String? error,
    bool? isRemembered,
    bool? isEmailVerified,
    AuthStep? currentStep,
  }) {
    return AuthState(
      user: user ?? this.user,
      passengerProfile: passengerProfile ?? this.passengerProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRemembered: isRemembered ?? this.isRemembered,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool get isAuthenticated => user != null && isEmailVerified;
}

// Auth steps enum
enum AuthStep {
  signIn,
  signUp,
  emailVerification,
  forgotPassword,
  resetPassword,
}

// Authentication result model
class AuthResult {
  final bool success;
  final String? message;
  final User? user;

  const AuthResult({
    required this.success,
    this.message,
    this.user,
  });
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
          _handleUserChange(user);
        },
        loading: () {
          state = state.copyWith(isLoading: true, error: null);
        },
        error: (error, stackTrace) {
          state = state.copyWith(
            isLoading: false,
            error: 'Authentication error: ${error.toString()}',
            user: null,
            passengerProfile: null,
          );
        },
      );
    });

    // Check for auto-login on initialization
    _checkAutoLogin();
  }

  Future<void> _handleUserChange(User? user) async {
    if (user != null) {
      try {
        // Load passenger profile
        final profile = await _passengerService.getPassengerProfile(user.uid);
        state = state.copyWith(
          user: user,
          passengerProfile: profile,
          isLoading: false,
          error: null,
          isEmailVerified: user.emailVerified,
        );
      } catch (e) {
        print('Error loading passenger profile: $e');
        state = state.copyWith(
          user: user,
          isLoading: false,
          isEmailVerified: user.emailVerified,
        );
      }
    } else {
      state = state.copyWith(
        user: null,
        passengerProfile: null,
        isLoading: false,
        error: null,
        isEmailVerified: false,
      );
    }
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

  // Sign in with email and password
  Future<AuthResult> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🎯 Starting sign in process for: $email');
      state = state.copyWith(isLoading: true, error: null);

      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      // Check if email is verified
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        state = state.copyWith(
          isLoading: false,
          currentStep: AuthStep.emailVerification,
          error: 'Please verify your email address to continue.',
        );
        return const AuthResult(
          success: false,
          message: 'Email verification required',
        );
      }

      print('🎉 Sign in successful!');
      state = state.copyWith(
        isLoading: false,
        isRemembered: rememberMe,
        currentStep: AuthStep.signIn,
      );

      return AuthResult(
        success: true,
        message: 'Sign in successful',
        user: userCredential.user,
      );
    } catch (e) {
      print('💥 Sign in error in provider: $e');
      final errorMessage = _getFirebaseErrorMessage(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return AuthResult(success: false, message: errorMessage);
    }
  }

  // Sign up with email and password
  Future<AuthResult> signUp({
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
        // Update display name
        await userCredential.user!.updateDisplayName('$firstName $lastName');

        // Send email verification
        await sendEmailVerification();

        // Create passenger profile
        await _passengerService.createPassengerProfile(
          userId: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
        );

        state = state.copyWith(
          isLoading: false,
          currentStep: AuthStep.emailVerification,
        );

        return AuthResult(
          success: true,
          message: 'Account created successfully. Please verify your email.',
          user: userCredential.user,
        );
      }

      throw Exception('Failed to create user account');
    } catch (e) {
      // Handle errors gracefully
      String errorMessage = _getFirebaseErrorMessage(e.toString());

      // Check if user was actually created despite the error
      if (e.toString().contains('PigeonUserDetails') ||
          e.toString().contains('List<Object?>')) {
        await Future.delayed(const Duration(seconds: 1));

        if (_authService.currentUser != null) {
          try {
            // Update display name
            await _authService.currentUser!
                .updateDisplayName('$firstName $lastName');

            // Send email verification
            await sendEmailVerification();

            // Create passenger profile
            await _passengerService.createPassengerProfile(
              userId: _authService.currentUser!.uid,
              firstName: firstName,
              lastName: lastName,
              email: email,
              phoneNumber: phoneNumber,
            );

            state = state.copyWith(
              isLoading: false,
              currentStep: AuthStep.emailVerification,
            );

            return AuthResult(
              success: true,
              message:
                  'Account created successfully. Please verify your email.',
              user: _authService.currentUser,
            );
          } catch (profileError) {
            print('Error creating passenger profile: $profileError');
            errorMessage =
                'Account created but profile setup failed. Please try again.';
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
