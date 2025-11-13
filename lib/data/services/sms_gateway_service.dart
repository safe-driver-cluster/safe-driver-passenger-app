import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmsGatewayService {
  static final SmsGatewayService _instance = SmsGatewayService._internal();
  factory SmsGatewayService() => _instance;
  SmsGatewayService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'asia-south1', // Same region as Cloud Functions
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send OTP to phone number via Text.lk SMS gateway
  Future<OtpSendResult> sendOtp(String phoneNumber) async {
    try {
      print('🔐 Sending OTP to: $phoneNumber');

      final HttpsCallable callable = _functions.httpsCallable('sendOTP');
      final result = await callable.call({
        'phoneNumber': phoneNumber,
      });

      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        print('✅ OTP sent successfully');
        return OtpSendResult(
          success: true,
          verificationId: data['verificationId'] as String,
          phoneNumber: data['phoneNumber'] as String,
          expiresAt: DateTime.parse(data['expiresAt'] as String),
        );
      } else {
        throw Exception(
            'Failed to send OTP: ${data['message'] ?? 'Unknown error'}');
      }
    } on FirebaseFunctionsException catch (e) {
      print('❌ Firebase Functions error: ${e.code} - ${e.message}');
      throw _handleFunctionsError(e);
    } catch (e) {
      print('❌ SMS Gateway error: $e');
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify OTP code
  Future<OtpVerifyResult> verifyOtp({
    required String verificationId,
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      print('🔐 Verifying OTP: $otpCode for verification: $verificationId');

      final HttpsCallable callable = _functions.httpsCallable('verifyOTP');
      final result = await callable.call({
        'verificationId': verificationId,
        'otp': otpCode,
        'phoneNumber': phoneNumber,
      });

      final data = result.data as Map<String, dynamic>;

      if (data['success'] == true) {
        // For now, we'll create an anonymous user and associate the phone number with it
        // This is a workaround since we can't create custom tokens without IAM permissions
        User? user = _auth.currentUser;

        if (user == null) {
          // Sign in anonymously first
          final userCredential = await _auth.signInAnonymously();
          user = userCredential.user!;
        }
        print('✅ OTP verified and user authenticated: ${user.uid}');

        // Store the phone verification status in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phoneNumber': data['phoneNumber'],
          'phoneVerified': true,
          'verificationId': verificationId,
          'verifiedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        return OtpVerifyResult(
          success: true,
          user: user,
          userId: user.uid,
          phoneNumber: data['phoneNumber'] as String,
          isNewUser: data['isNewUser'] as bool? ?? false,
        );
      } else {
        throw Exception(
            'Failed to verify OTP: ${data['message'] ?? 'Unknown error'}');
      }
    } on FirebaseFunctionsException catch (e) {
      print('❌ Firebase Functions error: ${e.code} - ${e.message}');
      throw _handleFunctionsError(e);
    } catch (e) {
      print('❌ OTP verification error: $e');
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Format phone number for Sri Lankan numbers
  String formatSriLankanPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Handle different input formats
    if (cleaned.startsWith('0')) {
      // Remove leading 0 and add +94
      cleaned = '+94${cleaned.substring(1)}';
    } else if (cleaned.startsWith('94')) {
      // Add + prefix
      cleaned = '+$cleaned';
    } else if (cleaned.length == 9) {
      // Assume it's a Sri Lankan number without country code
      cleaned = '+94$cleaned';
    } else if (!cleaned.startsWith('+94')) {
      // If it doesn't start with +94, assume it needs it
      cleaned = '+94$cleaned';
    }

    return cleaned;
  }

  /// Validate Sri Lankan phone number format
  bool isValidSriLankanPhoneNumber(String phoneNumber) {
    final formatted = formatSriLankanPhoneNumber(phoneNumber);
    final regex = RegExp(r'^\+94[1-9]\d{8}$');
    return regex.hasMatch(formatted);
  }

  /// Handle Firebase Functions errors
  String _handleFunctionsError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'invalid-argument':
        return e.message ?? 'Invalid phone number or OTP format';
      case 'resource-exhausted':
        return e.message ?? 'Too many attempts. Please try again later.';
      case 'deadline-exceeded':
        return 'OTP has expired. Please request a new one.';
      case 'not-found':
        return 'Invalid verification code. Please try again.';
      case 'failed-precondition':
        return e.message ?? 'Verification failed. Please try again.';
      case 'internal':
        return 'Service temporarily unavailable. Please try again.';
      case 'unauthenticated':
        return 'Authentication failed. Please try again.';
      default:
        return e.message ?? 'An unexpected error occurred. Please try again.';
    }
  }
}

/// Result model for OTP send operation
class OtpSendResult {
  final bool success;
  final String? verificationId;
  final String? phoneNumber;
  final DateTime? expiresAt;
  final String? error;

  const OtpSendResult({
    required this.success,
    this.verificationId,
    this.phoneNumber,
    this.expiresAt,
    this.error,
  });

  factory OtpSendResult.error(String error) {
    return OtpSendResult(
      success: false,
      error: error,
    );
  }
}

/// Result model for OTP verification operation
class OtpVerifyResult {
  final bool success;
  final User? user;
  final String? userId;
  final String? phoneNumber;
  final bool isNewUser;
  final String? error;

  const OtpVerifyResult({
    required this.success,
    this.user,
    this.userId,
    this.phoneNumber,
    this.isNewUser = false,
    this.error,
  });

  factory OtpVerifyResult.error(String error) {
    return OtpVerifyResult(
      success: false,
      error: error,
    );
  }
}
