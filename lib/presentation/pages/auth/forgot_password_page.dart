import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/phone_auth_provider.dart';
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
  String _selectedCountryCode = '+94'; // Default to Sri Lanka
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

    HapticFeedback.lightImpact();

    try {
      // Check if phone number exists in the system
      final authProvider = ref.read(authStateProvider.notifier);
      final phoneExists = await authProvider.checkPhoneNumberExists(phoneNumber);
      
      if (!phoneExists) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          CustomSnackBar.showError(
            context,
            'No account found with this phone number. Please check and try again.',
          );
        }
        return;
      }

      // Send OTP using phone auth provider
      final phoneAuthController = ref.read(phoneAuthControllerProvider.notifier);
      await phoneAuthController.sendOtp(phoneNumber);
      
      final phoneAuthState = ref.read(phoneAuthControllerProvider);
      
      if (phoneAuthState.isOtpSent && phoneAuthState.verificationId != null) {
        if (mounted) {
          HapticFeedback.mediumImpact();
          Navigator.pushNamed(
            context,
            '/forgot-password-otp',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': phoneAuthState.verificationId,
            },
          );
        }
      } else if (phoneAuthState.error != null) {
        if (mounted) {
          CustomSnackBar.showError(context, phoneAuthState.error!);
        }
      }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar('An error occurred. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
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
          'Forgot Password',
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
                Icons.lock_reset,
                size: 80,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(height: 24),

              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const Text(
                'Enter your phone number to receive an OTP for password reset',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Phone Number Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Phone Number Field with Country Code
                    PhoneNumberField(
                      controller: _phoneController,
                      selectedCountryCode: _selectedCountryCode,
                      onCountryCodeChanged: (code) {
                        setState(() {
                          _selectedCountryCode = code;
                        });
                      },
                      labelText: 'Phone Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (_selectedCountryCode == '+94' &&
                            value.length != 9) {
                          return 'Please enter a valid Sri Lankan phone number';
                        }
                        if (value.length < 7 || value.length > 15) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Send OTP Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendOTP,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Remember your password? ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
