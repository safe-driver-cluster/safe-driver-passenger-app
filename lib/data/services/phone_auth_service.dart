import 'package:firebase_auth/firebase_auth.dart';

import '../models/passenger_model.dart';
import 'passenger_service.dart';
import 'sms_gateway_service.dart';

class PhoneAuthService {
  static final PhoneAuthService _instance = PhoneAuthService._internal();
  factory PhoneAuthService() => _instance;
  PhoneAuthService._internal();

  final SmsGatewayService _smsGateway = SmsGatewayService();
  final PassengerService _passengerService = PassengerService.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send OTP to phone number
  Future<PhoneAuthResult> sendOtp(String phoneNumber) async {
    try {
      print('========== PHONE AUTH SEND OTP START ==========');
      print('[PhoneAuthService.sendOtp] raw phoneNumber: $phoneNumber');
      print(
          '[PhoneAuthService.sendOtp] Firebase user before cleanup: ${_auth.currentUser?.uid}');
      await _signOutDriverSessionIfNeeded();
      print(
          '[PhoneAuthService.sendOtp] Firebase user after cleanup: ${_auth.currentUser?.uid}');

      // Format and validate phone number
      final formattedPhone =
          _smsGateway.formatSriLankanPhoneNumber(phoneNumber);
      print('[PhoneAuthService.sendOtp] formatted phone: $formattedPhone');

      if (!_smsGateway.isValidSriLankanPhoneNumber(formattedPhone)) {
        print('[PhoneAuthService.sendOtp] invalid Sri Lankan phone number');
        print('========== PHONE AUTH SEND OTP END: INVALID PHONE ==========');
        return PhoneAuthResult.error(
            'Please enter a valid Sri Lankan phone number');
      }

      // Send OTP via SMS gateway
      final result = await _smsGateway.sendOtp(formattedPhone);
      print('[PhoneAuthService.sendOtp] sms gateway result: $result');

      if (result.success) {
        print('========== PHONE AUTH SEND OTP END: SUCCESS ==========');
        return PhoneAuthResult(
          success: true,
          verificationId: result.verificationId!,
          phoneNumber: result.phoneNumber!,
          expiresAt: result.expiresAt!,
        );
      } else {
        print('[PhoneAuthService.sendOtp] result success=false');
        print('========== PHONE AUTH SEND OTP END: FAILED ==========');
        return PhoneAuthResult.error(result.error ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('[PhoneAuthService.sendOtp] error: $e');
      print('========== PHONE AUTH SEND OTP END: ERROR ==========');
      return PhoneAuthResult.error(_getErrorMessage(e));
    }
  }

  /// Verify OTP - Just verify, don't create profile
  /// Profile creation happens later in auth_provider.signUp() with all required data
  Future<PhoneAuthResult> verifyOtp({
    required String verificationId,
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      print('========== PHONE AUTH VERIFY OTP START ==========');
      print('[PhoneAuthService.verifyOtp] verificationId: $verificationId');
      print('[PhoneAuthService.verifyOtp] phoneNumber: $phoneNumber');
      print('[PhoneAuthService.verifyOtp] otp length: ${otpCode.length}');
      print(
          '[PhoneAuthService.verifyOtp] Firebase user before cleanup: ${_auth.currentUser?.uid}');
      await _signOutDriverSessionIfNeeded();
      print(
          '[PhoneAuthService.verifyOtp] Firebase user after cleanup: ${_auth.currentUser?.uid}');

      // Verify OTP via SMS gateway
      final result = await _smsGateway.verifyOtp(
        verificationId: verificationId,
        otpCode: otpCode,
        phoneNumber: phoneNumber,
      );
      print('[PhoneAuthService.verifyOtp] sms gateway result: $result');

      if (result.success) {
        print('[PhoneAuthService.verifyOtp] OTP verified. Phone: ${result.phoneNumber}');
        print('========== PHONE AUTH VERIFY OTP END: SUCCESS ==========');

        // Just return verification success
        // Profile creation happens in auth_provider.signUp() with email + password + names
        return PhoneAuthResult(
          success: true,
          verificationId: verificationId,
          phoneNumber: result.phoneNumber!,
        );
      } else {
        print('[PhoneAuthService.verifyOtp] result success=false: ${result.error}');
        print('========== PHONE AUTH VERIFY OTP END: FAILED ==========');
        return PhoneAuthResult.error(result.error ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print('[PhoneAuthService.verifyOtp] error: $e');
      print('========== PHONE AUTH VERIFY OTP END: ERROR ==========');
      return PhoneAuthResult.error(_getErrorMessage(e));
    }
  }

  /// Resend OTP
  Future<PhoneAuthResult> resendOtp(String phoneNumber) async {
    // For resend, we just call sendOtp again
    return sendOtp(phoneNumber);
  }

  /// Check if user is authenticated via phone
  bool get isPhoneAuthenticated {
    final user = _auth.currentUser;
    return user != null && user.phoneNumber != null;
  }

  /// Get current user's phone number
  String? get currentPhoneNumber {
    return _auth.currentUser?.phoneNumber;
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> _signOutDriverSessionIfNeeded() async {
    final user = _auth.currentUser;
    if (user != null && user.uid.toLowerCase().startsWith('driver_')) {
      print(
          '[PhoneAuthService] Driver FirebaseAuth session found in passenger OTP flow. Signing out: ${user.uid}');
      await _auth.signOut();
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Delete passenger profile first
      try {
        await _passengerService.deletePassengerProfile(user.uid);
      } catch (e) {
        print('Error deleting passenger profile: $e');
      }

      // Delete Firebase Auth user
      await user.delete();
    }
  }

  /// Get error message for exceptions
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'Invalid phone number format';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'operation-not-allowed':
          return 'Phone authentication is not enabled';
        default:
          return error.message ?? 'Authentication error occurred';
      }
    }
    return error.toString();
  }
}

/// Result model for phone authentication operations
class PhoneAuthResult {
  final bool success;
  final User? user;
  final PassengerModel? passengerProfile;
  final String? verificationId;
  final String? phoneNumber;
  final DateTime? expiresAt;
  final bool isNewUser;
  final String? error;

  const PhoneAuthResult({
    required this.success,
    this.user,
    this.passengerProfile,
    this.verificationId,
    this.phoneNumber,
    this.expiresAt,
    this.isNewUser = false,
    this.error,
  });

  factory PhoneAuthResult.error(String error) {
    return PhoneAuthResult(
      success: false,
      error: error,
    );
  }

  @override
  String toString() {
    return 'PhoneAuthResult{'
        'success: $success, '
        'phoneNumber: $phoneNumber, '
        'isNewUser: $isNewUser, '
        'error: $error'
        '}';
  }
}
