import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../../core/constants/color_constants.dart';
import '../../../providers/phone_auth_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
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

  @override
  void initState() {
    super.initState();
    // Delay the OTP sending to avoid provider modification during widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialOtp();
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
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_otpCode.length == 6) {
          _verifyOtp();
        }
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _onOtpBackspace(int index) {
    if (index > 0 && _otpControllers[index].text.isEmpty) {
      _otpControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _sendInitialOtp() async {
    try {
      final phoneAuthController = ref.read(phoneAuthControllerProvider.notifier);
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
        CustomSnackBar.showError(context, 'Failed to send OTP: ${e.toString()}');
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      CustomSnackBar.showError(context, 'Please enter the complete OTP');
      return;
    }

    if (_verificationId == null) {
      CustomSnackBar.showError(context, 'Verification ID not found. Please try again.');
      return;
    }

    try {
      final phoneAuthController = ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.verifyOtp(_otpCode);

      final phoneAuthState = ref.read(phoneAuthControllerProvider);
      
      if (phoneAuthState.isAuthenticated && phoneAuthState.user != null) {
        // Create user account with email/password for future login
        await _createUserAccount(phoneAuthState.user!.uid);
        
        // Show success message and navigate to login
        if (mounted) {
          CustomSnackBar.showSuccess(context, 'Account verified successfully!');
          
          // Navigate to login page
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
            arguments: {
              'message': 'Account created and verified successfully! Please login with your credentials.',
              'email': widget.email,
            },
          );
        }
      } else if (phoneAuthState.error != null) {
        if (mounted) {
          CustomSnackBar.showError(context, phoneAuthState.error!);
        }
      }
    } catch (e) {
      print('OTP verification error: $e');
      if (mounted) {
        CustomSnackBar.showError(context, 'Verification failed: ${e.toString()}');
      }
    }
  }

  Future<void> _createUserAccount(String phoneUserId) async {
    try {
      // Import auth service
      final authService = ref.read(authStateProvider.notifier);
      
      // Create Firebase Auth account with email/password
      await authService.signUp(
        email: widget.email,
        password: widget.password,
        firstName: widget.firstName,
        lastName: widget.lastName,
        phoneNumber: widget.phoneNumber,
      );
      
      // Sign out the phone auth user
      await ref.read(phoneAuthControllerProvider.notifier).signOut();
      
    } catch (e) {
      print('Error creating user account: $e');
      // Don't throw error here, phone verification was successful
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    try {
      final phoneAuthController = ref.read(phoneAuthControllerProvider.notifier);
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
          CustomSnackBar.showSuccess(context, 'OTP sent successfully');
        }
      } else if (state.error != null) {
        if (mounted) {
          CustomSnackBar.showError(context, state.error!);
        }
      }
    } catch (e) {
      print('Resend OTP error: $e');
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to resend OTP: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneAuthState = ref.watch(phoneAuthControllerProvider);
    final isLoading = phoneAuthState.isLoading;

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Account Verification',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Header
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Verify Your Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We sent a verification code to\n${widget.phoneNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // OTP Form
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Verification Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Type the 6-digit code we sent you',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: 45,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _otpControllers[index].text.isNotEmpty
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) => _onOtpChanged(value, index),
                              onTap: () {
                                if (_otpControllers[index].text.isNotEmpty) {
                                  _otpControllers[index].selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            _otpControllers[index].text.length),
                                  );
                                }
                              },
                              onEditingComplete: () {
                                if (_otpControllers[index].text.isEmpty &&
                                    index > 0) {
                                  _onOtpBackspace(index);
                                }
                              },
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 40),

                      // Verify Button
                      CustomButton(
                        text: 'Verify & Create Account',
                        onPressed: _isOtpSent ? _verifyOtp : null,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 24),

                      // Resend Code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (_canResend)
                            TextButton(
                              onPressed: _resendOtp,
                              child: const Text(
                                'Resend',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          else
                            Text(
                              'Resend in $_seconds s',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Change Phone Number
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Change phone number',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}