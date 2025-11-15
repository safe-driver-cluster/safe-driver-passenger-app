import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../../data/services/sms_gateway_service.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/custom_snackbar.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+94';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = ref.read(authStateProvider.notifier);
      final phoneExists =
          await authProvider.checkPhoneNumberExists(phoneNumber);

      if (!phoneExists) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          CustomSnackBar.showError(
            context,
            'No account found with this phone number.',
          );
        }
        return;
      }

      // Send OTP using SMS gateway service directly
      final smsGateway = SmsGatewayService();
      final result = await smsGateway.sendOtp(phoneNumber);

      if (result.success && result.verificationId != null) {
        if (mounted) {
          Navigator.pushNamed(
            context,
            '/forgot-password-otp',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': result.verificationId,
            },
          );
        }
      } else {
        if (mounted) {
          CustomSnackBar.showError(context, result.error ?? 'Failed to send OTP');
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to send OTP');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter your phone number and we will send you a code to reset your password.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    PhoneNumberField(
                      controller: _phoneController,
                      selectedCountryCode: _selectedCountryCode,
                      onCountryCodeChanged: (code) {
                        setState(() {
                          _selectedCountryCode = code;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendOTP,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Send OTP'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
