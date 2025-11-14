import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';
import '../../widgets/common/google_icon.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/country_code_picker.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedCountryCode = '+94'; // Default to Sri Lanka
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showErrorSnackBar('Please accept the terms and conditions');
      return;
    }

    HapticFeedback.lightImpact();

    // Navigate to account verification page with user details
    Navigator.pushNamed(
      context,
      '/account-verification',
      arguments: {
        'phoneNumber': '$_selectedCountryCode${_phoneController.text.trim()}',
        'email': _emailController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'password': _passwordController.text.trim(),
      },
    );
  }

  Future<void> _googleSignUp() async {
    HapticFeedback.lightImpact();

    final authNotifier = ref.read(authStateProvider.notifier);
    final result = await authNotifier.signInWithGoogle();

    if (mounted) {
      if (result.success) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(result.message ?? 'Google Sign-Up failed');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
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

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
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

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen for auth state changes and navigate accordingly
    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated && mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (next.error != null &&
          mounted &&
          next.currentStep != AuthStep.emailVerification) {
        _showErrorSnackBar(next.error!);
        ref.read(authStateProvider.notifier).clearError();
      }
    });

    final isLoading = authState.isLoading;

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
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
            child: Column(
              children: [
                // Header with back button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 24),
                          child: Column(
                            children: [
                              // Logo with glow effect
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: const Icon(
                                          Icons.person_add,
                                          size: 50,
                                          color: Color(0xFF2563EB),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join SafeDriver for secure travels',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
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
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 8),

                                // Registration Form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Name Fields
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _firstNameController,
                                              decoration: InputDecoration(
                                                labelText: 'First Name',
                                                prefixIcon: const Icon(
                                                    Icons.person_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF2563EB)),
                                                ),
                                              ),
                                              validator: _validateFirstName,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _lastNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Last Name',
                                                prefixIcon: const Icon(
                                                    Icons.person_outlined),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[300]!),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF2563EB)),
                                                ),
                                              ),
                                              validator: _validateLastName,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // Email Field
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          prefixIcon:
                                              const Icon(Icons.email_outlined),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2563EB)),
                                          ),
                                        ),
                                        validator: _validateEmail,
                                      ),

                                      const SizedBox(height: 16),

                                      // Phone Field with Country Code
                                      PhoneNumberField(
                                        controller: _phoneController,
                                        selectedCountryCode: _selectedCountryCode,
                                        onCountryCodeChanged: (code) {
                                          setState(() {
                                            _selectedCountryCode = code;
                                          });
                                        },
                                        labelText: 'Phone Number',
                                        validator: _validatePhoneNumber,
                                      ),

                                      const SizedBox(height: 16),

                                      // Password Field
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon:
                                              const Icon(Icons.lock_outlined),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2563EB)),
                                          ),
                                        ),
                                        validator: _validatePassword,
                                      ),

                                      const SizedBox(height: 16),

                                      // Confirm Password Field
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        obscureText: _obscureConfirmPassword,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          prefixIcon:
                                              const Icon(Icons.lock_outlined),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureConfirmPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword =
                                                    !_obscureConfirmPassword;
                                              });
                                            },
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey[300]!),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2563EB)),
                                          ),
                                        ),
                                        validator: _validateConfirmPassword,
                                      ),

                                      const SizedBox(height: 20),

                                      // Terms and Conditions
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: _acceptTerms,
                                            onChanged: (value) {
                                              setState(() {
                                                _acceptTerms = value ?? false;
                                              });
                                            },
                                            activeColor:
                                                const Color(0xFF2563EB),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 12),
                                                RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                    children: const [
                                                      TextSpan(
                                                          text:
                                                              'I agree to the '),
                                                      TextSpan(
                                                        text:
                                                            'Terms of Service',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF2563EB),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(text: ' and '),
                                                      TextSpan(
                                                        text: 'Privacy Policy',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF2563EB),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 20),

                                      // Sign Up Button
                                      ElevatedButton(
                                        onPressed: isLoading ? null : _signUp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF2563EB),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : const Text(
                                                'Create Account',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Divider
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Divider(
                                                  color: Colors.grey[300])),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              'OR',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Divider(
                                                  color: Colors.grey[300])),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Google Sign-Up Button
                                      OutlinedButton.icon(
                                        onPressed:
                                            isLoading ? null : _googleSignUp,
                                        icon: const GoogleIcon(size: 20),
                                        label: const Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2563EB),
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          side: const BorderSide(
                                              color: Color(0xFF2563EB)),
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Sign In Link
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already have an account?',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
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
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
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
