import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/loading_widget.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final String _selectedCountryCode = '+94'; // Default to Sri Lanka
  final bool _isLoading = false;

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
      // Check if account exists with this phone number
      final authNotifier = ref.read(authStateProvider.notifier);
      final accountExists = await authNotifier.checkPhoneNumberExists(phoneNumber);
      
      if (!accountExists) {
        _showErrorSnackBar('No account found with this phone number');
        return;
      }

      // Send OTP for password reset
      final result = await authNotifier.sendPasswordResetOTP(phoneNumber);
      
      if (mounted) {
        if (result.success) {
          HapticFeedback.mediumImpact();
          // Navigate to OTP verification screen
          Navigator.pushNamed(
            context,
            '/forgot-password-otp',
            arguments: {
              'phoneNumber': phoneNumber,
              'verificationId': result.verificationId,
            },
          );
        } else {
          HapticFeedback.heavyImpact();
          _showErrorSnackBar(result.message ?? 'Failed to send OTP');
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

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
                      child: Icon(
                        _isEmailSent ? Icons.email : Icons.lock_reset,
                        size: 50,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isEmailSent ? 'Check Your Email' : 'Forgot Password?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEmailSent
                          ? 'We sent a password reset link to ${_emailController.text}'
                          : 'Don\'t worry, we\'ll send you reset instructions',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Form or Success Message
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
                  child: _isEmailSent
                      ? _buildSuccessContent()
                      : _buildFormContent(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Reset Your Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          const Text(
            'Enter your email address and we\'ll send you a link to reset your password',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Email Field
          CustomTextField(
            controller: _emailController,
            label: AppStrings.email,
            hint: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),

          const SizedBox(height: 24),

          // Send Email Button
          CustomButton(
            text: 'Send Reset Email',
            onPressed: _sendResetEmail,
          ),

          const SizedBox(height: 16),

          // Back to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Remember your password? ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle,
          size: 60,
          color: AppColors.successColor,
        ),

        const SizedBox(height: 24),

        const Text(
          'Email Sent Successfully!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        const Text(
          'Please check your email and follow the instructions to reset your password.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Resend Email Button
        CustomButton(
          text: 'Resend Email',
          onPressed: () {
            setState(() {
              _isEmailSent = false;
            });
          },
          isOutlined: true,
        ),

        const SizedBox(height: 16),

        // Back to Login
        CustomButton(
          text: 'Back to Sign In',
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        const SizedBox(height: 16),

        // Email App Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
            ),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryColor,
                size: 20,
              ),
              SizedBox(height: 8),
              Text(
                'Didn\'t receive the email?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Check your spam folder or try resending the email',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
