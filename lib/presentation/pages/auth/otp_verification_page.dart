import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/phone_auth_provider.dart';
import '../../widgets/common/custom_back_button.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/loading_widget.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Timer? _timer;
  int _seconds = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
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
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
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
    }
  }

  void _onOtpBackspace(int index) {
    if (index > 0) {
      _otpControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;

    final l10n = AppLocalizations.of(context);
    if (_otpCode.length != 6) {
      CustomSnackBar.showError(
        context,
        l10n.pleaseEnterComplete6DigitOtp,
      );
      return;
    }

    try {
      setState(() => _isVerifying = true);

      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.verifyOtp(_otpCode);
    } catch (e) {
      print('OTP verification error: $e');
      CustomSnackBar.showError(
        context,
        '${l10n.verificationFailed}: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    final l10n = AppLocalizations.of(context);
    if (!_canResend) return;

    try {
      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.resendOtp();

      // Clear current OTP
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      _startTimer();

      CustomSnackBar.showSuccess(
        context,
        l10n.otpSentTo(widget.phoneNumber),
      );
    } catch (e) {
      print('Resend OTP error: $e');
      CustomSnackBar.showError(
        context,
        '${l10n.otpFailed}: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phoneAuthState = ref.watch(phoneAuthControllerProvider);
    final isLoading = phoneAuthState.isLoading;

    // Listen for authentication state changes
    ref.listen<PhoneAuthState>(phoneAuthControllerProvider, (previous, next) {
      if (next.error != null) {
        CustomSnackBar.showError(context, next.error!);
      }

      if (next.currentStep == PhoneAuthStep.complete) {
        // Navigate to dashboard or onboarding based on user status
        if (next.isNewUser ||
            next.passengerProfile?.firstName.isEmpty == true) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
        } else {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      }
    });

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CustomBackButton(color: Colors.white),
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
                        Icons.sms,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.verifyYourPhone,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.verificationCodeSent(widget.phoneNumber),
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
                      Text(
                        l10n.enterVerificationCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        l10n.type6DigitCode,
                        style: const TextStyle(
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
                        text: l10n.verifyCode,
                        onPressed: _isVerifying ? null : _verifyOtp,
                        isLoading: isLoading || _isVerifying,
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

                      const SizedBox(height: 16),

                      // Change Phone Number
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.changePhoneNumber,
                          style: const TextStyle(
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
