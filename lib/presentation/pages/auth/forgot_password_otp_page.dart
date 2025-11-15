import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/common/custom_snackbar.dart';

class ForgotPasswordOtpPage extends ConsumerStatefulWidget {
  const ForgotPasswordOtpPage({super.key});

  @override
  ConsumerState<ForgotPasswordOtpPage> createState() =>
      _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends ConsumerState<ForgotPasswordOtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String _phoneNumber = '';
  String _verificationId = '';
  bool _isLoading = false;
  bool _isResending = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _phoneNumber = args['phoneNumber'] ?? '';
        _verificationId = args['verificationId'] ?? '';
      }
      _startCountdown();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  String get _otpCode {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    final otpCode = _otpCode;
    if (otpCode.length != 6) {
      CustomSnackBar.showError(
          context, 'Please enter the complete 6-digit OTP');
      return;
    }

    if (_verificationId.isEmpty) {
      CustomSnackBar.showError(
          context, 'Verification ID not found. Please try again.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    try {
      // Use Firebase Cloud Functions directly to verify OTP without authentication
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('verifyOTP');
      
      final result = await callable.call({
        'verificationId': _verificationId,
        'otp': otpCode,
        'phoneNumber': _phoneNumber,
      });

      final data = result.data as Map<String, dynamic>;
      
      if (data['success'] == true) {
        if (mounted) {
          HapticFeedback.mediumImpact();
          // Navigate to reset password screen
          Navigator.pushReplacementNamed(
            context,
            '/reset-password',
            arguments: {
              'phoneNumber': _phoneNumber,
              'otpCode': otpCode,
              'isVerified': true,
            },
          );
        }
      } else {
        if (mounted) {
          HapticFeedback.heavyImpact();
          CustomSnackBar.showError(context, data['message'] ?? 'Invalid OTP. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        CustomSnackBar.showError(
            context, 'Verification failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _countdown > 0) return;

    if (_phoneNumber.isEmpty) {
      CustomSnackBar.showError(
          context, 'Phone number not found. Please try again.');
      return;
    }

    setState(() {
      _isResending = true;
    });

    HapticFeedback.lightImpact();

    try {
      // Use Firebase Cloud Functions directly to resend OTP
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('sendOTP');
      
      final result = await callable.call({
        'phoneNumber': _phoneNumber,
      });

      final data = result.data as Map<String, dynamic>;
      
      if (data['success'] == true) {
        _verificationId = data['verificationId'] as String;
        if (mounted) {
          HapticFeedback.mediumImpact();
          CustomSnackBar.showSuccess(context, 'OTP sent successfully');
          _startCountdown();

          // Clear existing OTP
          for (var controller in _controllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        }
      } else {
        if (mounted) {
          CustomSnackBar.showError(context, data['message'] ?? 'Failed to resend OTP');
        }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        CustomSnackBar.showError(
            context, 'Failed to resend OTP: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all digits are entered
    if (_otpCode.length == 6) {
      _verifyOtp();
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify OTP',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Icon and Title
              const Icon(
                Icons.sms,
                size: 80,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(height: 24),

              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                'We sent a 6-digit code to\\n$_phoneNumber',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF2563EB), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      (_isLoading || _otpCode.length != 6) ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Didn\'t receive the code? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (_countdown > 0)
                    Text(
                      'Resend in ${_countdown}s',
                      style: const TextStyle(color: Colors.grey),
                    )
                  else
                    GestureDetector(
                      onTap: _isResending ? null : _resendOtp,
                      child: Text(
                        _isResending ? 'Sending...' : 'Resend OTP',
                        style: TextStyle(
                          color: _isResending
                              ? Colors.grey
                              : const Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              const Spacer(),

              // Change Phone Number
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Change Phone Number',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
