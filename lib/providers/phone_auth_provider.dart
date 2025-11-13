import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/passenger_model.dart';
import '../data/services/phone_auth_service.dart';
import 'auth_provider.dart';

// Phone auth controller provider
final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, PhoneAuthState>((ref) {
  return PhoneAuthController(ref);
});

// Phone auth state model
class PhoneAuthState {
  final bool isLoading;
  final String? error;
  final String? verificationId;
  final String? phoneNumber;
  final DateTime? expiresAt;
  final bool isOtpSent;
  final User? user;
  final PassengerModel? passengerProfile;
  final bool isNewUser;
  final PhoneAuthStep currentStep;

  const PhoneAuthState({
    this.isLoading = false,
    this.error,
    this.verificationId,
    this.phoneNumber,
    this.expiresAt,
    this.isOtpSent = false,
    this.user,
    this.passengerProfile,
    this.isNewUser = false,
    this.currentStep = PhoneAuthStep.enterPhone,
  });

  PhoneAuthState copyWith({
    bool? isLoading,
    String? error,
    String? verificationId,
    String? phoneNumber,
    DateTime? expiresAt,
    bool? isOtpSent,
    User? user,
    PassengerModel? passengerProfile,
    bool? isNewUser,
    PhoneAuthStep? currentStep,
  }) {
    return PhoneAuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      expiresAt: expiresAt ?? this.expiresAt,
      isOtpSent: isOtpSent ?? this.isOtpSent,
      user: user ?? this.user,
      passengerProfile: passengerProfile ?? this.passengerProfile,
      isNewUser: isNewUser ?? this.isNewUser,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool get isAuthenticated => user != null;
}

// Phone auth steps
enum PhoneAuthStep {
  enterPhone,
  verifyOtp,
  onboarding,
  complete,
}

// Phone auth controller
class PhoneAuthController extends StateNotifier<PhoneAuthState> {
  PhoneAuthController(this._ref) : super(const PhoneAuthState());

  final Ref _ref;
  late final PhoneAuthService _phoneAuthService;

  // Initialize services
  void _initializeServices() {
    _phoneAuthService = _ref.read(phoneAuthServiceProvider);
  }

  /// Send OTP to phone number
  Future<void> sendOtp(String phoneNumber) async {
    if (!mounted) return;

    _initializeServices();

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentStep: PhoneAuthStep.enterPhone,
    );

    try {
      final result = await _phoneAuthService.sendOtp(phoneNumber);

      if (!mounted) return;

      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          verificationId: result.verificationId,
          phoneNumber: result.phoneNumber,
          expiresAt: result.expiresAt,
          isOtpSent: true,
          currentStep: PhoneAuthStep.verifyOtp,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      if (!mounted) return;

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Verify OTP code
  Future<void> verifyOtp(String otpCode) async {
    if (!mounted) return;

    if (state.verificationId == null || state.phoneNumber == null) {
      state = state.copyWith(
        error: 'Invalid verification session. Please start over.',
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final result = await _phoneAuthService.verifyOtp(
        verificationId: state.verificationId!,
        otpCode: otpCode,
        phoneNumber: state.phoneNumber!,
      );

      if (!mounted) return;

      if (result.success) {
        final nextStep = result.isNewUser ||
                result.passengerProfile?.firstName.isEmpty == true
            ? PhoneAuthStep.onboarding
            : PhoneAuthStep.complete;

        state = state.copyWith(
          isLoading: false,
          user: result.user,
          passengerProfile: result.passengerProfile,
          isNewUser: result.isNewUser,
          currentStep: nextStep,
        );

        // Update the main auth provider
        _ref.read(authStateProvider.notifier).setPhoneAuthUser(
              result.user!,
              result.passengerProfile,
              result.isNewUser,
            );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Failed to verify OTP',
        );
      }
    } catch (e) {
      if (!mounted) return;

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (state.phoneNumber == null) {
      state = state.copyWith(
        error: 'No phone number available for resend',
      );
      return;
    }

    await sendOtp(state.phoneNumber!);
  }

  /// Reset state
  void reset() {
    if (!mounted) return;

    state = const PhoneAuthState();
  }

  /// Go to next step
  void goToNextStep() {
    if (!mounted) return;

    switch (state.currentStep) {
      case PhoneAuthStep.enterPhone:
        // This should be handled by sendOtp
        break;
      case PhoneAuthStep.verifyOtp:
        // This should be handled by verifyOtp
        break;
      case PhoneAuthStep.onboarding:
        state = state.copyWith(currentStep: PhoneAuthStep.complete);
        break;
      case PhoneAuthStep.complete:
        // Already complete
        break;
    }
  }

  /// Go to previous step
  void goToPreviousStep() {
    if (!mounted) return;

    switch (state.currentStep) {
      case PhoneAuthStep.enterPhone:
        // Already at first step
        break;
      case PhoneAuthStep.verifyOtp:
        state = state.copyWith(
          currentStep: PhoneAuthStep.enterPhone,
          isOtpSent: false,
          verificationId: null,
          error: null,
        );
        break;
      case PhoneAuthStep.onboarding:
        state = state.copyWith(currentStep: PhoneAuthStep.verifyOtp);
        break;
      case PhoneAuthStep.complete:
        state = state.copyWith(currentStep: PhoneAuthStep.onboarding);
        break;
    }
  }

  /// Clear error
  void clearError() {
    if (!mounted) return;

    state = state.copyWith(error: null);
  }

  /// Sign out phone auth user
  Future<void> signOut() async {
    if (!mounted) return;

    try {
      // Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Reset state
      state = const PhoneAuthState();
    } catch (e) {
      print('Error signing out phone auth user: $e');
    }
  }
}
