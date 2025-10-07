import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseService.currentUser;
      if (user != null) {
        final userDoc = await _firebaseService.firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          return UserModel.fromJson({
            'id': user.uid,
            ...userDoc.data()!,
          });
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (credential?.user != null) {
        // Update last login time
        await _updateLastLoginTime(credential!.user!.uid);
        return await getCurrentUser();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Create user with email and password
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      final credential = await _firebaseService.createUserWithEmailAndPassword(
        email,
        password,
      );

      if (credential?.user != null) {
        // Update display name
        await credential!.user!.updateDisplayName(name);

        // Create user document in Firestore
        final userModel = UserModel(
          id: credential.user!.uid,
          firstName: name.split(' ').first,
          lastName: name.split(' ').length > 1 ? name.split(' ').last : '',
          email: email,
          phoneNumber: phone,
          dateOfBirth: DateTime.now().subtract(
              const Duration(days: 365 * 18)), // Default to 18 years ago
          gender: '', // Will be updated later
          address: Address(
            street: '',
            city: '',
            state: '',
            zipCode: '',
            country: '',
          ),
          emergencyContact: EmergencyContact(
            name: '',
            relationship: '',
            phoneNumber: '',
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          preferences: UserPreferences(),
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'firstName': userModel.firstName,
          'lastName': userModel.lastName,
          'email': email,
          'phoneNumber': phone,
          'createdAt': DateTime.now().toIso8601String(),
          'lastLoginAt': DateTime.now().toIso8601String(),
          'isEmailVerified': false,
          'isPhoneVerified': false,
          'preferences': UserPreferences().toJson(),
          'emergencyContacts': [],
          'dateOfBirth': userModel.dateOfBirth.toIso8601String(),
          'gender': userModel.gender,
          'address': userModel.address.toJson(),
          'emergencyContact': userModel.emergencyContact.toJson(),
          'updatedAt': DateTime.now().toIso8601String(),
        });

        return userModel;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final userCredential = await _firebaseService.signInWithGoogle();

      if (userCredential?.user != null) {
        // Check if user document exists, if not create it
        final userDoc = await _firebaseService.firestore
            .collection('users')
            .doc(userCredential!.user!.uid)
            .get();

        if (!userDoc.exists) {
          await _firebaseService.firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'firstName':
                userCredential.user!.displayName?.split(' ').first ?? '',
            'lastName':
                (userCredential.user!.displayName?.split(' ').length ?? 0) > 1
                    ? userCredential.user!.displayName?.split(' ').last ?? ''
                    : '',
            'email': userCredential.user!.email ?? '',
            'phoneNumber': userCredential.user!.phoneNumber ?? '',
            'profileImage': userCredential.user!.photoURL,
            'createdAt': DateTime.now().toIso8601String(),
            'lastLoginAt': DateTime.now().toIso8601String(),
            'isEmailVerified': userCredential.user!.emailVerified,
            'isPhoneVerified': false,
            'preferences': UserPreferences().toJson(),
            'emergencyContacts': [],
            'dateOfBirth': DateTime.now()
                .subtract(const Duration(days: 365 * 18))
                .toIso8601String(),
            'gender': '',
            'address': Address(
                    street: '', city: '', state: '', zipCode: '', country: '')
                .toJson(),
            'emergencyContact':
                EmergencyContact(name: '', phoneNumber: '', relationship: '')
                    .toJson(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
        } else {
          await _updateLastLoginTime(userCredential.user!.uid);
        }

        return await getCurrentUser();
      }
      return null;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Verify OTP
  Future<UserModel?> verifyOtp(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential =
          await _firebaseService.auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _updateLastLoginTime(userCredential.user!.uid);
        return await getCurrentUser();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  // Send OTP
  Future<void> sendOtp(
    String phoneNumber,
    Function(String) onCodeSent,
    Function(String) onVerificationFailed,
  ) async {
    try {
      await _firebaseService.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseService.auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(_handleAuthException(e));
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseService.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firebaseService.firestore
          .collection('users')
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Update last login time
  Future<void> _updateLastLoginTime(String userId) async {
    try {
      await _firebaseService.firestore.collection('users').doc(userId).update({
        'lastLoginAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log error but don't throw as it's not critical
      // print('Failed to update last login time: $e');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'invalid-verification-id':
        return 'Invalid verification ID.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
