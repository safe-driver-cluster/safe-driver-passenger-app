import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../providers/phone_auth_provider.dart';
import '../../widgets/common/country_code_selector.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/google_icon.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/phone_input_widget.dart';
import 'otp_verification_page.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  CountryCode _selectedCountry = CountryCodeSelector.sriLanka;
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
      _checkForSuccessMessage();
    });
  }

  void _checkForSuccessMessage() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['message'] != null) {
      if (args['phoneNumber'] != null) {
        _phoneController.text = args['phoneNumber'];
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessSnackBar(args['message']);
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      // For phone authentication, we might want to save the last used phone number
      print('Loading saved phone credentials...');
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  Future<void> _sendOtp() async {
    print('📱 Send OTP button pressed');
    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    final phoneNumber =
        _selectedCountry.dialCode + _phoneController.text.trim();
    print('✅ Form validated, sending OTP to: $phoneNumber');

    HapticFeedback.lightImpact();

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

  void _onCountryChanged(CountryCode country) {
    setState(() {
      _selectedCountry = country;
    });
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
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
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(flex: 2),

                      // App Logo and Title
                      Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_car,
                              size: 60,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue your safe journey',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      // Login Form
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 32),

                              // Phone Number Input
                              PhoneInputWidget(
                                phoneController: _phoneController,
                                selectedCountry: _selectedCountry,
                                onCountryChanged: _onCountryChanged,
                                labelText: 'Phone Number',
                                enabled: !isLoading,
                                autofocus: true,
                              ),

                              const SizedBox(height: 24),

                              // Remember Me Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: isLoading
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                    activeColor: AppColors.primaryColor,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Remember my phone number',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Send OTP Button
                              ElevatedButton(
                                onPressed: isLoading ? null : _sendOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
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

                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey[300],
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Google Sign In Button
                              OutlinedButton.icon(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        // TODO: Implement Google Sign In
                                        _showErrorSnackBar(
                                            'Google Sign In coming soon!');
                                      },
                                icon: const GoogleIcon(),
                                label: const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
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
            ],
          ),
        ),
      ),
    );
  }
}
