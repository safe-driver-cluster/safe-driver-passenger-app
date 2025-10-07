import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'crashlytics_service.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  FirebaseService._();

  // Firebase instances
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;
  late FirebaseMessaging _messaging;
  late FirebaseAnalytics _analytics;

  // Google Sign In
  late GoogleSignIn _googleSignIn;

  // Stream controllers
  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;
  FirebaseAnalytics get analytics => _analytics;
  GoogleSignIn get googleSignIn => _googleSignIn;

  Stream<User?> get authStateChanges => _authStateController.stream;
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;

  /// Initialize Firebase services
  Future<bool> initialize() async {
    try {
      // Initialize Firebase Core (already done in main.dart)
      // await Firebase.initializeApp();

      // Initialize services
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;

      // Initialize Google Sign In
      _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Set up auth state listener
      _auth.authStateChanges().listen((User? user) {
        _authStateController.add(user);
      });

      // Configure Firestore settings
      await _configureFirestore();

      // Request messaging permissions
      await _requestMessagingPermissions();

      return true;
    } catch (e) {
      // Log error to Crashlytics
      CrashlyticsService.instance.logError(
        e,
        StackTrace.current,
        reason: 'Firebase initialization failed',
        context: {'service': 'FirebaseService'},
      );
      print('Firebase initialization failed: $e');
      return false;
    }
  }

  /// Configure Firestore settings
  Future<void> _configureFirestore() async {
    try {
      // Enable offline persistence
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      // Log error to Crashlytics
      CrashlyticsService.instance.logError(
        e,
        StackTrace.current,
        reason: 'Firestore configuration error',
        context: {
          'service': 'FirebaseService',
          'operation': 'configureFirestore'
        },
      );
      print('Firestore configuration error: $e');
    }
  }

  /// Request messaging permissions
  Future<void> _requestMessagingPermissions() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print('Failed to request messaging permissions: $e');
    }
  }

  // Authentication Methods

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _analytics.logLogin(loginMethod: 'email');
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Sign in failed: $e');
    }
  }

  /// Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _analytics.logSignUp(signUpMethod: 'email');
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Account creation failed: $e');
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseException('Google sign-in was cancelled');
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
      final userCredential = await _auth.signInWithCredential(credential);

      await _analytics.logLogin(loginMethod: 'google');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Google sign-in failed: $e');
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

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Password reset failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Google if signed in
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await _auth.signOut();
      await _analytics.logEvent(name: 'logout');
    } catch (e) {
      throw FirebaseException('Sign out failed: $e');
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await deleteUserData(user.uid);

        // Delete user account
        await user.delete();

        await _analytics.logEvent(name: 'account_deleted');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Account deletion failed: $e');
    }
  }

  // Firestore Methods

  /// Create or update user document
  Future<void> createUserDocument(
      String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          ...userData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw FirebaseException('Failed to create user document: $e');
    }
  }

  /// Get user document
  Future<DocumentSnapshot> getUserDocument(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw FirebaseException('Failed to get user document: $e');
    }
  }

  /// Update user document
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirebaseException('Failed to update user document: $e');
    }
  }

  /// Delete user data
  Future<void> deleteUserData(String uid) async {
    try {
      final batch = _firestore.batch();

      // Delete user document
      batch.delete(_firestore.collection('users').doc(uid));

      // Delete user's feedback
      final feedbackQuery = await _firestore
          .collection('feedback')
          .where('userId', isEqualTo: uid)
          .get();

      for (final doc in feedbackQuery.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw FirebaseException('Failed to delete user data: $e');
    }
  }

  /// Get collection stream
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  /// Get document stream
  Stream<DocumentSnapshot> getDocumentStream(
      String collection, String documentId) {
    return _firestore.collection(collection).doc(documentId).snapshots();
  }

  /// Add document to collection
  Future<DocumentReference> addDocument(
      String collection, Map<String, dynamic> data) async {
    try {
      return await _firestore.collection(collection).add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirebaseException('Failed to add document: $e');
    }
  }

  /// Update document
  Future<void> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw FirebaseException('Failed to update document: $e');
    }
  }

  /// Delete document
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
    } catch (e) {
      throw FirebaseException('Failed to delete document: $e');
    }
  }

  // Storage Methods

  /// Upload file to Firebase Storage
  Future<String> uploadFile(String path, File file,
      {String? customName}) async {
    try {
      final fileName = customName ??
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final reference = _storage.ref().child(path).child(fileName);

      final uploadTask = reference.putFile(file);
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw FirebaseException('File upload failed: $e');
    }
  }

  /// Upload bytes to Firebase Storage
  Future<String> uploadBytes(
      String path, List<int> bytes, String fileName) async {
    try {
      final reference = _storage.ref().child(path).child(fileName);
      final uploadTask = reference.putData(Uint8List.fromList(bytes));
      final snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw FirebaseException('Bytes upload failed: $e');
    }
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final reference = _storage.refFromURL(downloadUrl);
      await reference.delete();
    } catch (e) {
      throw FirebaseException('File deletion failed: $e');
    }
  }

  // Analytics Methods

  /// Log custom event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Analytics event logging failed: $e');
    }
  }

  /// Set user property
  Future<void> setUserProperty(String name, String value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Analytics user property setting failed: $e');
    }
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      print('Analytics user ID setting failed: $e');
    }
  }

  // Messaging Methods

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      print('FCM token retrieval failed: $e');
      return null;
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
    } catch (e) {
      print('Topic subscription failed: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Topic unsubscription failed: $e');
    }
  }

  // Helper Methods

  /// Handle Firebase Auth exceptions
  FirebaseException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseException('No user found for this email.');
      case 'wrong-password':
        return FirebaseException('Wrong password provided.');
      case 'email-already-in-use':
        return FirebaseException('Account already exists for this email.');
      case 'weak-password':
        return FirebaseException('Password is too weak.');
      case 'invalid-email':
        return FirebaseException('Email address is invalid.');
      case 'user-disabled':
        return FirebaseException('User account has been disabled.');
      case 'too-many-requests':
        return FirebaseException('Too many requests. Please try again later.');
      case 'requires-recent-login':
        return FirebaseException('Please log in again to perform this action.');
      default:
        return FirebaseException('Authentication failed: ${e.message}');
    }
  }

  /// Check network connectivity
  Future<bool> isConnected() async {
    try {
      // Try to get a document to test connectivity
      await _firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Enable network
  Future<void> enableNetwork() async {
    try {
      await _firestore.enableNetwork();
    } catch (e) {
      print('Failed to enable network: $e');
    }
  }

  /// Disable network
  Future<void> disableNetwork() async {
    try {
      await _firestore.disableNetwork();
    } catch (e) {
      print('Failed to disable network: $e');
    }
  }

  /// Dispose service
  void dispose() {
    _authStateController.close();
  }
}

// Custom exceptions
class FirebaseException implements Exception {
  final String message;
  FirebaseException(this.message);

  @override
  String toString() => 'FirebaseException: $message';
}
