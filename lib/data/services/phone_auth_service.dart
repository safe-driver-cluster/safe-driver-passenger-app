import 'package:firebase_auth/firebase_auth.dart';
import 'sms_gateway_service.dart';
import '../models/passenger_model.dart';
import 'passenger_service.dart';

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
      // Format and validate phone number
      final formattedPhone = _smsGateway.formatSriLankanPhoneNumber(phoneNumber);
      
      if (!_smsGateway.isValidSriLankanPhoneNumber(formattedPhone)) {
        return PhoneAuthResult.error('Please enter a valid Sri Lankan phone number');
      }

      print('📱 Sending OTP to: $formattedPhone');
      
      // Send OTP via SMS gateway
      final result = await _smsGateway.sendOtp(formattedPhone);
      
      if (result.success) {
        return PhoneAuthResult(
          success: true,
          verificationId: result.verificationId!,
          phoneNumber: result.phoneNumber!,
          expiresAt: result.expiresAt!,
        );
      } else {
        return PhoneAuthResult.error(result.error ?? 'Failed to send OTP');
      }
    } catch (e) {
      print('❌ Send OTP error: $e');
      return PhoneAuthResult.error(_getErrorMessage(e));
    }
  }

  /// Verify OTP and sign in user
  Future<PhoneAuthResult> verifyOtp({
    required String verificationId,
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      print('🔐 Verifying OTP: $otpCode');
      
      // Verify OTP via SMS gateway
      final result = await _smsGateway.verifyOtp(
        verificationId: verificationId,
        otpCode: otpCode,
        phoneNumber: phoneNumber,
      );
      
      if (result.success && result.user != null) {
        // Check if user has a passenger profile
        PassengerModel? passengerProfile;
        try {
          passengerProfile = await _passengerService.getPassengerProfile(result.userId!);
        } catch (e) {
          print('No existing passenger profile found, will create one');
        }
        
        // If new user or no profile, create passenger profile
        if (result.isNewUser || passengerProfile == null) {
          print('Creating new passenger profile for: ${result.userId}');
          
          await _passengerService.createPassengerProfile(
            userId: result.userId!,
            firstName: '', // Will be updated during onboarding
            lastName: '',
            email: '', // Optional
            phoneNumber: result.phoneNumber!,
          );
          
          // Get the newly created profile
          passengerProfile = await _passengerService.getPassengerProfile(result.userId!);
        }
        
        return PhoneAuthResult(
          success: true,
          user: result.user!,
          passengerProfile: passengerProfile,
          verificationId: verificationId,
          phoneNumber: result.phoneNumber!,
          isNewUser: result.isNewUser,
        );
      } else {
        return PhoneAuthResult.error(result.error ?? 'Failed to verify OTP');
      }
    } catch (e) {
      print('❌ Verify OTP error: $e');
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