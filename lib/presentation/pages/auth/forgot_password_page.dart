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
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context,
          'Failed to send OTP: ${e.toString()}',
        );
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
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1E25)),
          onPressed: () => Navigator.pop(context),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1E25),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Subtitle
              const Text(
                'Don\\'t worry! Enter your phone number and we\\'ll send you a code to reset your password.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Phone Number Field
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
                        
                        if (_selectedCountryCode == '+94' &&
                            !RegExp(r'^[0-9]{9}$').hasMatch(value.trim())) {
                          return 'Please enter a valid 9-digit phone number';
                        }
                        
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Send OTP Button
                    SizedBox(
                      width: double.infinity,
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
                          disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.6),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Back to Login
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Remember your password? ',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
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
