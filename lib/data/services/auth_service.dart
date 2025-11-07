import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageService _storage = StorageService.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  bool _initialized = false;

  // Storage keys for remember me functionality
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _autoLoginKey = 'auto_login';

  /// Initialize the auth service
  Future<void> initialize() async {
    if (!_initialized) {
      await _storage.initialize();
      _initialized = true;
      print('🔐 AuthService initialized');
    }
  }

  /// Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  /// Auth state stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🔐 Attempting Firebase Auth sign in with email: $email');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Firebase Auth successful for user: ${userCredential.user?.uid}');

      // Save credentials if remember me is enabled
      if (rememberMe) {
        print('💾 Saving credentials for remember me');
        await _saveCredentials(email, password);
        await _storage.saveBool(_rememberMeKey, true);
        await _storage.saveBool(_autoLoginKey, true);
      } else {
        await _clearSavedCredentials();
      }

      return userCredential;
    } catch (e) {
      print('❌ Firebase Auth error: $e');
      throw _handleAuthError(e);
    }
  }

  /// Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Clear any saved credentials when creating new account
      await _clearSavedCredentials();

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Clear auto-login but keep saved credentials if remember me was checked
      await _storage.saveBool(_autoLoginKey, false);

      // If user explicitly signs out, we should also clear remember me
      await _clearSavedCredentials();

      await _firebaseAuth.signOut();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    await initialize(); // Ensure storage is initialized
    return _storage.getBool(_rememberMeKey) ?? false;
  }

  /// Check if auto login is enabled
  Future<bool> isAutoLoginEnabled() async {
    await initialize(); // Ensure storage is initialized
    return _storage.getBool(_autoLoginKey) ?? false;
  }

  /// Get saved email
  Future<String?> getSavedEmail() async {
    await initialize(); // Ensure storage is initialized
    final rememberMe = await isRememberMeEnabled();
    if (rememberMe) {
      return _storage.getString(_savedEmailKey);
    }
    return null;
  }

  /// Get saved password (for auto-login only)
  Future<String?> _getSavedPassword() async {
    await initialize(); // Ensure storage is initialized
    final autoLogin = await isAutoLoginEnabled();
    if (autoLogin) {
      return _storage.getString(_savedPasswordKey);
    }
    return null;
  }

  /// Attempt auto login
  Future<bool> attemptAutoLogin() async {
    try {
      final autoLogin = await isAutoLoginEnabled();
      if (!autoLogin) return false;

      final email = await getSavedEmail();
      final password = await _getSavedPassword();

      if (email != null && password != null) {
        await signInWithEmailAndPassword(
          email: email,
          password: password,
          rememberMe: true, // Keep remember me enabled
        );
        return true;
      }
    } catch (e) {
      print('Auto login failed: $e');
      // Clear invalid credentials
      await _clearSavedCredentials();
    }
    return false;
  }

  /// Save credentials locally
  Future<void> _saveCredentials(String email, String password) async {
    await initialize(); // Ensure storage is initialized
    await _storage.saveString(_savedEmailKey, email);
    await _storage.saveString(_savedPasswordKey, password);
  }

  /// Clear saved credentials
  Future<void> _clearSavedCredentials() async {
    await initialize(); // Ensure storage is initialized
    await _storage.saveBool(_rememberMeKey, false);
    await _storage.saveBool(_autoLoginKey, false);
    await _storage.saveString(_savedEmailKey, '');
    await _storage.saveString(_savedPasswordKey, '');
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Handle authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'user-disabled':
          return 'This account has been disabled. Contact support.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Password is too weak. Please use a stronger password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return error.message ?? 'An authentication error occurred.';
      }
    }
    return error.toString();
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      await _clearSavedCredentials();
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  /// Reload user to get updated verification status
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Google sign out failed: $e');
    }
  }
}
