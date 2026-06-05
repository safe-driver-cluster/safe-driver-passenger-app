import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/firebase_service.dart';
import '../data/models/passenger_model.dart';
import '../data/services/auth_service.dart';
import '../data/services/biometric_service.dart';
import '../data/services/passenger_service.dart';
import '../data/services/phone_auth_service.dart';
import '../data/services/sms_gateway_service.dart';

// Auth service providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final phoneAuthServiceProvider =
    Provider<PhoneAuthService>((ref) => PhoneAuthService());
final smsGatewayServiceProvider =
    Provider<SmsGatewayService>((ref) => SmsGatewayService());
final biometricServiceProvider =
    Provider<BiometricService>((ref) => BiometricService());

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

  // Set phone auth user after successful SMS verification
  void setPhoneAuthUser(User user, PassengerModel? profile, bool isNewUser) {
    state = state.copyWith(
      user: user,
      passengerProfile: profile,
      isLoading: false,
      error: null,
      currentStep: isNewUser || profile?.firstName.isEmpty == true
          ? AuthStep.signUp
          : AuthStep.signIn,
    );
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

  // Sign in with phone number and password
  Future<AuthResult> signInWithPhone({
    required String phoneNumber,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🎯 Starting sign in with phone: $phoneNumber');
      state = state.copyWith(isLoading: true, error: null);

      await _signOutDriverSessionIfNeeded();

      // Format phone number to match storage format
      final smsGateway = _ref.read(smsGatewayServiceProvider);
      final formattedPhone = smsGateway.formatSriLankanPhoneNumber(phoneNumber);
      print('📞 Formatted phone: $formattedPhone');

      // Look up user by phone number in Firestore to get email.
      // Web can otherwise return a stale empty cached result before login.
      final userEmail = await _lookupPassengerEmailByPhone(formattedPhone);

      if (userEmail == null || userEmail.isEmpty) {
        print(
            '⚠️ Email not found in Firestore profile for phone: $formattedPhone');
        throw Exception('No account found with this phone number');
      }

      print('📧 Found email: $userEmail');

      // Sign in with Firebase Auth using email and password
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in: User is null');
      }

      print('✅ Firebase Auth sign in successful!');
      print('👤 User UID: ${user.uid}');

      // Load passenger profile from Firestore using Firebase Auth UID
      final profile = await _passengerService.getPassengerProfile(user.uid);

      state = state.copyWith(
        user: user,
        passengerProfile: profile,
        isLoading: false,
        isRemembered: rememberMe,
        isEmailVerified: user.emailVerified,
        currentStep: AuthStep.signIn,
      );

      print('🎉 Sign in successful!');
      return AuthResult(
        success: true,
        message: 'Sign in successful',
        user: user,
      );
    } catch (e) {
      print('💥 Sign in error: $e');
      final errorMessage = _getFirebaseErrorMessage(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return AuthResult(success: false, message: errorMessage);
    }
  }

  Future<String?> _lookupPassengerEmailByPhone(String formattedPhone) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('passenger_details')
          .where('phoneNumber', isEqualTo: formattedPhone)
          .limit(1)
          .get(const GetOptions(source: Source.server));

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        return userData['email'] as String?;
      }

      print(
          'Phone lookup returned empty from Firestore server, trying Cloud Function fallback');
    } on FirebaseException catch (e) {
      print(
          'Firestore phone lookup failed (${e.code}), trying Cloud Function fallback');
    }

    try {
      final callable = FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('lookupPassengerByPhone');
      final result = await callable.call({'phoneNumber': formattedPhone});
      final data = Map<String, dynamic>.from(result.data as Map);

      if (data['success'] == true) {
        return data['email'] as String?;
      }
    } on FirebaseFunctionsException catch (e) {
      if (e.code != 'not-found') {
        print('Cloud Function phone lookup failed: ${e.code} - ${e.message}');
      }
    } catch (e) {
      print('Cloud Function phone lookup error: $e');
    }

    return null;
  }

  Future<void> _signOutDriverSessionIfNeeded() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null &&
        currentUser.uid.toLowerCase().startsWith('driver_')) {
      print(
          '⚠️ Driver FirebaseAuth session found in passenger login. Signing out: ${currentUser.uid}');
      await FirebaseAuth.instance.signOut();
    }
  }

  // Sign in with email and password (fallback/alternative)
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🎯 Starting sign in with email: $email');
      state = state.copyWith(isLoading: true, error: null);

      // Sign in with Firebase Auth
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in: User is null');
      }

      print('✅ Firebase Auth sign in successful!');
      print('👤 User UID: ${user.uid}');

      // Load passenger profile from Firestore using Firebase Auth UID
      final profile = await _passengerService.getPassengerProfile(user.uid);

      state = state.copyWith(
        user: user,
        passengerProfile: profile,
        isLoading: false,
        isRemembered: rememberMe,
        isEmailVerified: user.emailVerified,
        currentStep: AuthStep.signIn,
      );

      print('🎉 Email sign in successful!');
      return AuthResult(
        success: true,
        message: 'Sign in successful',
        user: user,
      );
    } catch (e) {
      print('💥 Email sign in error: $e');
      final errorMessage = _getFirebaseErrorMessage(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return AuthResult(success: false, message: errorMessage);
    }
  }

  // Sign up with email and password (after OTP verification)
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      print('🚀 Creating Firebase Auth user for email: $email');

      // Validate email is not empty
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }

      // Create Firebase Auth user with email and password
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user: User is null');
      }

      final uid = user.uid;
      print('✅ Firebase Auth user created successfully');
      print('👤 User UID: $uid');

      print('📧 Email to save in Firestore: $email');
      print('📝 Creating passenger profile in Firestore...');

      // Save user data to Firestore (using Firebase Auth UID as document ID)
      // PASSWORD IS NOT STORED - it's in Firebase Auth
      try {
        await _passengerService.createPassengerProfile(
          userId: uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
        );
      } catch (profileError) {
        print('Error creating passenger profile: $profileError');
        // Delete the Firebase Auth user since profile creation failed
        await user.delete();
        throw Exception('Failed to create passenger profile: $profileError');
      }

      print('✅ Passenger profile created successfully with email: $email');

      state = state.copyWith(
        user: user,
        isLoading: false,
        currentStep: AuthStep.signIn,
      );

      return AuthResult(
        success: true,
        message: 'Account created successfully.',
        user: user,
      );
    } catch (e) {
      print('❌ SignUp error: $e');
      String errorMessage = 'Failed to create account: ${e.toString()}';

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );

      return AuthResult(
        success: false,
        message: errorMessage,
      );
    }
  }

  // Google Sign In
  Future<AuthResult> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final firebaseService = FirebaseService.instance;
      final userCredential = await firebaseService.signInWithGoogle();

      if (userCredential?.user != null) {
        // Create or update passenger profile for Google users with error handling
        try {
          final existingProfile = await _passengerService
              .getPassengerProfile(userCredential!.user!.uid);

          if (existingProfile == null) {
            // Create new profile with Google account data
            final names =
                userCredential.user!.displayName?.split(' ') ?? ['', ''];
            await _passengerService.createPassengerProfile(
              userId: userCredential.user!.uid,
              firstName: names.first,
              lastName: names.length > 1 ? names.last : '',
              email: userCredential.user!.email ?? '',
              phoneNumber: userCredential.user!.phoneNumber ?? '',
            );
          }
        } catch (profileError) {
          // Handle profile creation error gracefully
          print('Error with passenger profile: $profileError');

          // Check if it's the PigeonUserInfo error - if so, continue anyway
          if (profileError.toString().contains('PigeonUserInfo') ||
              profileError.toString().contains('List<Object?>')) {
            print('Ignoring PigeonUserInfo error - Google sign in successful');
          } else {
            // For other errors, still allow sign in but log the error
            print(
                'Profile creation failed but allowing sign in: $profileError');
          }
        }

        state = state.copyWith(isLoading: false);

        return AuthResult(
          success: true,
          message: 'Google sign in successful',
          user: userCredential!.user,
        );
      }

      throw Exception('Google sign in failed - no user returned');
    } catch (e) {
      // Handle Google Sign In specific errors
      String errorMessage;
      if (e.toString().contains('PigeonUserInfo') ||
          e.toString().contains('List<Object?>')) {
        errorMessage =
            'Google Sign In completed but with minor issues. Please try signing in again.';
      } else if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Google Sign In was canceled';
      } else if (e.toString().contains('network_error')) {
        errorMessage =
            'Network error during Google Sign In. Please check your connection.';
      } else {
        errorMessage = _getFirebaseErrorMessage(e.toString());
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return AuthResult(success: false, message: errorMessage);
    }
  }

  // Send email verification
  Future<AuthResult> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return const AuthResult(
          success: true,
          message: 'Verification email sent successfully',
        );
      }
      return const AuthResult(
        success: false,
        message: 'No user found or email already verified',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: _getFirebaseErrorMessage(e.toString()),
      );
    }
  }

  // Check email verification status
  Future<void> checkEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;
        if (updatedUser != null && updatedUser.emailVerified) {
          state = state.copyWith(
            isEmailVerified: true,
            currentStep: AuthStep.signIn,
          );
        }
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
  }

  // Send password reset email
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);

      return const AuthResult(
        success: true,
        message: 'Password reset email sent successfully',
      );
    } catch (e) {
      final errorMessage = _getFirebaseErrorMessage(e.toString());
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return AuthResult(success: false, message: errorMessage);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      await _authService.signOut();
      state = state.copyWith(
        user: null,
        passengerProfile: null,
        isLoading: false,
        isRemembered: false,
        isEmailVerified: false,
        currentStep: AuthStep.signIn,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _getFirebaseErrorMessage(e.toString()),
      );
    }
  }

  // Refresh passenger profile data from Firebase
  Future<void> refreshPassengerProfile() async {
    try {
      final user = state.user;
      if (user == null) return;

      state = state.copyWith(isLoading: true, error: null);

      // Fetch fresh passenger profile from Firebase
      final profile = await _passengerService.getPassengerProfile(user.uid);

      state = state.copyWith(
        passengerProfile: profile,
        isLoading: false,
        error: null,
      );
      print('✅ Passenger profile refreshed successfully');
    } catch (e) {
      print('❌ Error refreshing passenger profile: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to refresh profile: $e',
      );
    }
  }

  // Biometric authentication
  Future<bool> authenticateWithBiometric({
    String reason = 'Authenticate to access SafeDriver',
  }) async {
    try {
      final biometricService = BiometricService();
      await biometricService.initialize();
      final isAuthenticated = await biometricService.authenticate(
        reason: reason,
        useErrorDialogs: true,
      );
      return isAuthenticated;
    } catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }

  // Reset password (deprecated - use sendPasswordResetEmail instead)
  Future<void> resetPassword(String email) async {
    await sendPasswordResetEmail(email);
  }

  // Get saved email
  Future<String?> getSavedEmail() async {
    return await _authService.getSavedEmail();
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Set current auth step
  void setAuthStep(AuthStep step) {
    state = state.copyWith(currentStep: step);
  }

  // Get Firebase error message
  String _getFirebaseErrorMessage(String error) {
    if (error.contains('No account found with this phone number')) {
      return 'No account found with this phone number.';
    } else if (error.contains('Incorrect password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('Invalid verification code') ||
        error.contains('invalid verification')) {
      return 'Invalid verification code. Please try again.';
    } else if (error.contains('OTP has expired') ||
        error.contains('deadline-exceeded')) {
      return 'OTP has expired. Please request a new one.';
    } else if (error.contains('Too many verification attempts') ||
        error.contains('resource-exhausted')) {
      return 'Too many attempts. Please try again later.';
    } else if (error.contains('user-not-found')) {
      return 'No account found with this email address.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('email-already-in-use')) {
      return 'An account already exists with this email address.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address format.';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled. Please contact support.';
    } else if (error.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('operation-not-allowed')) {
      return 'This sign-in method is not enabled. Please contact support.';
    } else if (error.contains('invalid-credential')) {
      return 'Invalid credentials. Please check your email and password.';
    } else if (error.contains('account-exists-with-different-credential')) {
      return 'An account already exists with the same email but different sign-in credentials.';
    } else if (error.contains('requires-recent-login')) {
      return 'This operation requires recent authentication. Please sign in again.';
    }

    // Clean up generic error messages
    if (error.contains('Exception:')) {
      return error.split('Exception:').last.trim();
    }

    return 'An unexpected error occurred. Please try again.';
  }

  // Check if phone number exists in the system
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('passenger_details')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking phone number: $e');
      return false;
    }
  }

  // Send OTP for password reset (placeholder)
  Future<AuthResult> sendPasswordResetOTP(String phoneNumber) async {
    try {
      // For now, just simulate sending OTP
      await Future.delayed(const Duration(seconds: 1));

      return const AuthResult(
        success: true,
        message: 'OTP sent successfully',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Failed to send OTP: ${e.toString()}',
      );
    }
  }

  // Reset password with phone number and OTP
  Future<AuthResult> resetPasswordWithPhone({
    required String phoneNumber,
    required String newPassword,
    required String otpCode,
    required String verificationId,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('passenger_details')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No account found with this phone number');
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final email = userData['email'] as String?;

      if (email == null || email.isEmpty) {
        throw Exception('Account found but no email associated');
      }

      final callable = FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('resetPassword');

      final result = await callable.call({
        'email': email,
        'phoneNumber': phoneNumber,
        'newPassword': newPassword,
        'otpCode': otpCode,
        'verificationId': verificationId,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Failed to reset password');
      }

      print('✅ Password reset successful for phone: $phoneNumber');

      return const AuthResult(
        success: true,
        message: 'Password reset successfully',
      );
    } catch (e) {
      print('Password reset error: $e');
      return AuthResult(
        success: false,
        message: e.toString().contains('Exception:')
            ? e.toString().split('Exception:').last.trim()
            : 'Failed to reset password',
      );
    }
  }
}
