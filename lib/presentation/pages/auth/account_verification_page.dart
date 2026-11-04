import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/phone_auth_provider.dart';
import '../../widgets/common/custom_back_button.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/loading_widget.dart';

class AccountVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const AccountVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  ConsumerState<AccountVerificationPage> createState() =>
      _AccountVerificationPageState();
}

class _AccountVerificationPageState
    extends ConsumerState<AccountVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _timer;
  int _seconds = 60;
  bool _canResend = false;
  String? _verificationId;
  bool _isOtpSent = false;
  bool _isVerifying = false;
  int _focusedIndex = -1; // Track which OTP field has focus

  @override
  void initState() {
    super.initState();
    // Delay the OTP sending to avoid provider modification during widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialOtp();
      // Add focus listeners
      for (int i = 0; i < _focusNodes.length; i++) {
        _focusNodes[i].addListener(() {
          setState(() {
            _focusedIndex = _focusNodes[i].hasFocus ? i : -1;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _seconds = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_seconds > 0) {
            _seconds--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isEmpty) {
      // Backspace was pressed - move to previous field
      if (index > 0) {
        _otpControllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.isNotEmpty) {
      // Move to next field if value entered
      if (index < 5 && value.length == 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }

      // Auto-verify when all 6 digits are entered
      if (_otpCode.length == 6) {
        _verifyOtp();
      }
    }
  }

  void _clearOtp() {
    // Clear all OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }
    // Focus on first field
    _focusNodes[0].requestFocus();
  }

  Future<void> _sendInitialOtp() async {
    try {
      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.sendOtp(widget.phoneNumber);

      final state = ref.read(phoneAuthControllerProvider);
      if (state.isOtpSent && state.verificationId != null) {
        setState(() {
          _verificationId = state.verificationId;
          _isOtpSent = true;
        });
        _startTimer();
      } else if (state.error != null) {
        if (mounted) {
          CustomSnackBar.showError(context, state.error!);
        }
      }
    } catch (e) {
      print('Error sending initial OTP: $e');
      if (mounted) {
        CustomSnackBar.showError(context,
            '${AppLocalizations.of(context).otpFailed}: ${e.toString()}');
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;

    final l10n = AppLocalizations.of(context);
    if (_otpCode.length != 6) {
      CustomSnackBar.showError(context, l10n.pleaseEnterCompleteOtp);
      return;
    }

    if (_verificationId == null) {
      CustomSnackBar.showError(context, l10n.verificationIdNotFound);
      return;
    }

    try {
      setState(() => _isVerifying = true);

      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.verifyOtp(_otpCode);

      final phoneAuthState = ref.read(phoneAuthControllerProvider);

      // Check if OTP verification was successful
      if (phoneAuthState.error == null) {
        print('✅ OTP verified - creating user account');

        // Create user account with Firebase Auth + Firestore
        // This happens after OTP verification with all required data
        await _createUserAccount(widget.phoneNumber);

        // Show success message and navigate to login
        if (mounted) {
          CustomSnackBar.showSuccess(
              context, AppLocalizations.of(context).accountCreatedSuccessfully);

          // Navigate to login page
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
            arguments: {
              'message': AppLocalizations.of(context).accountCreatedAndVerified,
              'email': widget.email,
              'phone': widget.phoneNumber,
            },
          );
        }
      } else {
        if (mounted) {
          // Clear OTP fields on error
          _clearOtp();
          CustomSnackBar.showError(context, phoneAuthState.error!);
        }
      }
    } catch (e) {
      print('❌ OTP verification error: $e');
      if (mounted) {
        // Clear OTP fields on error
        _clearOtp();

        // Show specific error message
        String errorMessage = l10n.verificationFailed;
        if (e.toString().contains('email')) {
          errorMessage = l10n.emailValidationFailed;
        } else if (e.toString().contains('password')) {
          errorMessage = l10n.passwordValidationFailed;
        } else if (e.toString().contains('already exists')) {
          errorMessage = l10n.accountAlreadyExists;
        } else {
          errorMessage = '${l10n.verificationFailed}: ${e.toString()}';
        }

        CustomSnackBar.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _createUserAccount(String phoneNumber) async {
    try {
      print('🚀 Creating user account with:');
      print('  Email: ${widget.email}');
      print('  Phone: $phoneNumber');
      print('  Name: ${widget.firstName} ${widget.lastName}');

      // Import auth service
      final authService = ref.read(authStateProvider.notifier);

      // Create user account with email/password for login
      await authService.signUp(
        email: widget.email,
        password: widget.password,
        firstName: widget.firstName,
        lastName: widget.lastName,
        phoneNumber: phoneNumber,
      );

      print('✅ Account created successfully in Firebase Auth + Firestore');

      // Sign out the phone auth user (cleanup)
      try {
        await ref.read(phoneAuthControllerProvider.notifier).signOut();
      } catch (e) {
        print('⚠️ Error signing out phone auth user: $e');
        // Don't fail - phone auth cleanup is not critical
      }
    } catch (e) {
      print('❌ Error creating user account: $e');
      rethrow; // Re-throw so caller can handle error
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    try {
      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.sendOtp(widget.phoneNumber);

      final state = ref.read(phoneAuthControllerProvider);
      if (state.isOtpSent && state.verificationId != null) {
        setState(() {
          _verificationId = state.verificationId;
        });

        // Clear current OTP
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();

        _startTimer();

        if (mounted) {
          CustomSnackBar.showSuccess(
              context, AppLocalizations.of(context).otpSentSuccessfully);
        }
      } else if (state.error != null) {
        if (mounted) {
          CustomSnackBar.showError(context, state.error!);
        }
      }
    } catch (e) {
      print('Resend OTP error: $e');
      if (mounted) {
        CustomSnackBar.showError(context,
            '${AppLocalizations.of(context).otpFailed}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneAuthState = ref.watch(phoneAuthControllerProvider);
    final isLoading = phoneAuthState.isLoading;

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section with Back Button
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    // Back Button
                    const Row(
                      children: [
                        CustomBackButton(color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Icon with glow effect
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          size: 60,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.verifyYourAccount,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.verificationCodeSent(widget.phoneNumber),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Spacer to push white sheet down
              const Spacer(),

              // Form Section - Fixed at bottom
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      const SizedBox(height: 20),

                      // OTP Input Fields with focus styling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          final isFocused = _focusedIndex == index;
                          return Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isFocused
                                    ? AppColors.primaryColor
                                    : (_otpControllers[index].text.isNotEmpty
                                        ? AppColors.primaryColor
                                        : Colors.grey.shade300),
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              color: isFocused
                                  ? AppColors.primaryColor.withOpacity(0.08)
                                  : Colors.white,
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                filled: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) => _onOtpChanged(value, index),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Verify Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2563EB),
                              Color(0xFF1E40AF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed:
                              _isOtpSent && !_isVerifying ? _verifyOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  l10n.verifyAndCreateAccount,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Resend Code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.didntReceiveCode,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (_canResend)
                            TextButton(
                              onPressed: _resendOtp,
                              child: Text(
                                l10n.resend,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Text(
                              l10n.resendIn(_seconds),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Change Phone Number
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.changePhoneNumber,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
