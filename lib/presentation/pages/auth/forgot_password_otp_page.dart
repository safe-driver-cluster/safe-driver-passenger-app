import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/sms_gateway_service.dart';
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
      final smsGateway = SmsGatewayService();
      final result = await smsGateway.verifyOtp(
        verificationId: _verificationId,
        otpCode: otpCode,
        phoneNumber: _phoneNumber,
        skipAuthentication: true, // Skip Firebase Auth for forgot password flow
      );

      if (result.success) {
        if (mounted) {
          HapticFeedback.mediumImpact();
          // Navigate to reset password screen
          Navigator.pushReplacementNamed(
            context,
            '/reset-password',
            arguments: {
              'phoneNumber': _phoneNumber,
              'otpCode': otpCode,
              'userId': result.userId,
            },
          );
        }
      } else {
        if (mounted) {
          HapticFeedback.heavyImpact();
          CustomSnackBar.showError(context, 'Invalid OTP. Please try again.');
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
      final smsGateway = SmsGatewayService();
      final result = await smsGateway.sendOtp(_phoneNumber);

      if (result.success && result.verificationId != null) {
        _verificationId = result.verificationId!;
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
          CustomSnackBar.showError(
              context, result.error ?? 'Failed to resend OTP');
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2563EB),
              Color(0xFF1E40AF),
              Color(0xFF1E3A8A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 24,
                    right: 24,
                    bottom: 40,
                  ),
                  child: Column(
                    children: [
                      // Back Button
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

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
                            Icons.sms,
                            size: 60,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We sent a 6-digit code to\\n$_phoneNumber',
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

                // Form Section
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.55,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),

                        // OTP Input Fields with modern design
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 50,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _controllers[index].text.isNotEmpty
                                      ? const Color(0xFF2563EB)
                                      : Colors.grey[200]!,
                                  width: _controllers[index].text.isNotEmpty
                                      ? 2
                                      : 1,
                                ),
                                boxShadow: _controllers[index].text.isNotEmpty
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB)
                                              .withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (value) =>
                                    _onOtpChanged(index, value),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 32),

                        // Verify Button with gradient
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: (_isLoading || _otpCode.length != 6)
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF1E40AF),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: (_isLoading || _otpCode.length != 6)
                                ? null
                                : [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: ElevatedButton(
                            onPressed: (_isLoading || _otpCode.length != 6)
                                ? null
                                : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (_isLoading || _otpCode.length != 6)
                                      ? Colors.grey[300]
                                      : Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
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
                                    'Verify OTP',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          (_isLoading || _otpCode.length != 6)
                                              ? Colors.grey[600]
                                              : Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Resend OTP with better styling
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t receive the code? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (_countdown > 0)
                              Text(
                                'Resend in ${_countdown}s',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: _isResending ? null : _resendOtp,
                                child: Text(
                                  _isResending ? 'Sending...' : 'Resend OTP',
                                  style: TextStyle(
                                    color: _isResending
                                        ? Colors.grey[600]
                                        : const Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Change Phone Number with better styling
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Change Phone Number',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
