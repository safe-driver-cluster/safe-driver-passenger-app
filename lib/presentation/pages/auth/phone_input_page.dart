import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/services/sms_gateway_service.dart';
import '../../../providers/phone_auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/loading_widget.dart';
import 'otp_verification_page.dart';

class PhoneInputPage extends ConsumerStatefulWidget {
  const PhoneInputPage({super.key});

  @override
  ConsumerState<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends ConsumerState<PhoneInputPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _smsGateway = SmsGatewayService();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final formatted = _smsGateway.formatSriLankanPhoneNumber(value);
    if (!_smsGateway.isValidSriLankanPhoneNumber(formatted)) {
      return 'Please enter a valid Sri Lankan phone number';
    }

    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber =
        _smsGateway.formatSriLankanPhoneNumber(_phoneController.text.trim());

    try {
      final phoneAuthController =
          ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.sendOtp(phoneNumber);
    } catch (e) {
      print('Send OTP error: $e');
      CustomSnackBar.showError(
        context,
        'Failed to send OTP: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneAuthState = ref.watch(phoneAuthControllerProvider);
    final isLoading = phoneAuthState.isLoading;

    // Listen for state changes
    ref.listen<PhoneAuthState>(phoneAuthControllerProvider, (previous, next) {
      if (next.error != null) {
        CustomSnackBar.showError(context, next.error!);
      }

      if (next.currentStep == PhoneAuthStep.verifyOtp &&
          next.verificationId != null) {
        // Navigate to OTP verification page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              phoneNumber: next.phoneNumber!,
              verificationId: next.verificationId!,
            ),
          ),
        );
      }
    });

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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
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
                          Icons.phone_android,
                          size: 50,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Enter Your Phone Number',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'We\'ll send you a verification code via SMS',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Phone Input Form
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
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Enter your Sri Lankan mobile number',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Phone Number Input
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                          decoration: InputDecoration(
                            prefixText: '+94 ',
                            prefixStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            hintText: '77 123 4567',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.normal,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.errorColor,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                            _PhoneNumberFormatter(),
                          ],
                          validator: _validatePhoneNumber,
                        ),

                        const SizedBox(height: 32),

                        // Send OTP Button
                        CustomButton(
                          text: 'Send Verification Code',
                          onPressed: _sendOtp,
                          isLoading: isLoading,
                        ),

                        const SizedBox(height: 16),

                        // Info Text
                        Text(
                          'By continuing, you agree to receive SMS messages from SafeDriver for verification purposes. Message and data rates may apply.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Alternative Login Options
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login');
                          },
                          child: const Text(
                            'Email & Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Phone number formatter for better UX
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length <= 2) {
      return newValue;
    }

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 5) {
        formatted += ' ';
      }
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
