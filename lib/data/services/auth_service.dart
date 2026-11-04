import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/email_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StorageService _storage = StorageService.instance;

  bool _initialized = false;

  // Storage keys for remember me functionality
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _autoLoginKey = 'auto_login';
  static const String _persistentLoginKey = 'persistent_login';

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

      // ✅ Save device token for push notifications
      await _saveDeviceToken(userCredential.user!.uid);

      // Enable persistent login by default for all logins
      await enablePersistentLogin();

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

      // ✅ Save device token for push notifications
      await _saveDeviceToken(userCredential.user!.uid);

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

      // Clear persistent login when user explicitly signs out
      await _storage.saveBool(_persistentLoginKey, false);

      await _firebaseAuth.signOut();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Enable persistent login (keeps session alive after app close)
  Future<void> enablePersistentLogin() async {
    try {
      await _storage.saveBool(_persistentLoginKey, true);
      print('💾 Persistent login enabled');
    } catch (e) {
      print('❌ Error enabling persistent login: $e');
    }
  }

  /// Disable persistent login
  Future<void> disablePersistentLogin() async {
    try {
      await _storage.saveBool(_persistentLoginKey, false);
      print('💾 Persistent login disabled');
    } catch (e) {
      print('❌ Error disabling persistent login: $e');
    }
  }

  /// Check if persistent login is enabled
  Future<bool> isPersistentLoginEnabled() async {
    await initialize();
    return _storage.getBool(_persistentLoginKey) ?? false;
  }

  /// Check for persistent session (user should remain logged in)
  /// This is called on app startup
  Future<bool> checkPersistentSession() async {
    try {
      final isPersistent = await isPersistentLoginEnabled();
      if (isPersistent && currentUser != null) {
        print('✅ Persistent session found - user remains logged in');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error checking persistent session: $e');
      return false;
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

  /// Update only the saved password after a successful password change.
  Future<void> updateSavedPassword(String password) async {
    await initialize();
    final savedEmail = _storage.getString(_savedEmailKey);
    final rememberMe = _storage.getBool(_rememberMeKey) ?? false;
    final autoLogin = _storage.getBool(_autoLoginKey) ?? false;

    if (savedEmail != null &&
        savedEmail.isNotEmpty &&
        (rememberMe || autoLogin)) {
      await _storage.saveString(_savedPasswordKey, password);
    }
  }

  /// Clear saved credentials
  Future<void> _clearSavedCredentials() async {
    await initialize(); // Ensure storage is initialized
    await _storage.saveBool(_rememberMeKey, false);
    await _storage.saveBool(_autoLoginKey, false);
    await _storage.saveString(_savedEmailKey, '');
    await _storage.saveString(_savedPasswordKey, '');
  }

  /// Save device token to Firestore for push notifications
  Future<void> _saveDeviceToken(String userId) async {
    try {
      final token = await NotificationService.instance.getFCMToken();
      if (token != null && token.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('passenger_details')
            .doc(userId)
            .update({
          'deviceTokens': FieldValue.arrayUnion([token]),
        }).catchError((e) {
          print('⚠️ Error saving device token: $e');
          // Don't throw - token saving shouldn't fail auth flow
        });
        print('✅ Device token saved for user: $userId');
      }
    } catch (e) {
      print('⚠️ Error getting FCM token: $e');
      // Don't throw - token saving shouldn't fail auth flow
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Change password for signed-in email/password users.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw 'Please sign in again to change your password.';
      }

      final email = user.email;
      final hasPasswordProvider = user.providerData
          .any((provider) => provider.providerId == 'password');

      if (!hasPasswordProvider || email == null || email.isEmpty) {
        throw 'Password change is only available for email sign-in accounts.';
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      await user.reload();
      await updateSavedPassword(newPassword);

      try {
        await EmailService().sendPasswordChangedEmail(
          source: 'in_app_change',
        );
      } on FirebaseFunctionsException catch (error) {
        print(
          'Warning: password changed but email notification failed: '
          '${error.code} ${error.message}',
        );
      } catch (error) {
        print(
          'Warning: password changed but email notification failed: $error',
        );
      }
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
        case 'requires-recent-login':
          return 'Please sign in again before changing your password.';
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
}
