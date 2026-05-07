import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/google_icon.dart';
import '../../widgets/common/loading_widget.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCountryCode = '+94'; // Default to Sri Lanka
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load saved credentials after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
      _checkForSuccessMessage();
    });
  }

  void _checkForSuccessMessage() {
    // Check if we're coming from account verification
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['message'] != null) {
      // Pre-fill phone if provided
      if (args['phoneNumber'] != null) {
        _phoneController.text = args['phoneNumber'];
      }

      // Show success message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSuccessSnackBar(args['message']);
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      final savedEmail = await authNotifier.getSavedEmail();

      if (savedEmail != null && mounted) {
        _phoneController.text = savedEmail; // Will be changed to savedPhone
        setState(() {
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved credentials: $e');
    }
  }

  Future<void> _login() async {
    debugPrint('🚀 Login button pressed');

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ Form validation failed');
      return;
    }

    debugPrint(
        '✅ Form validated, attempting login with phone: $_selectedCountryCode${_phoneController.text.trim()}');

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final authNotifier = ref.read(authStateProvider.notifier);
    final result = await authNotifier.signInWithPhone(
      phoneNumber: '$_selectedCountryCode${_phoneController.text.trim()}',
      password: _passwordController.text.trim(),
      rememberMe: _rememberMe,
    );

    if (mounted) {
      if (result.success) {
        // Success feedback
        HapticFeedback.mediumImpact();

        // Navigate based on auth state
        final authState = ref.read(authStateProvider);
        if (authState.currentStep == AuthStep.emailVerification) {
          _showEmailVerificationDialog();
        } else {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // Error feedback
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(
            result.message ?? AppLocalizations.of(context).loginFailed);
      }
    }
  }

  Future<void> _googleSignIn() async {
    HapticFeedback.lightImpact();

    final authNotifier = ref.read(authStateProvider.notifier);
    final result = await authNotifier.signInWithGoogle();

    if (mounted) {
      if (result.success) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(
            result.message ?? AppLocalizations.of(context).loginFailed);
      }
    }
  }

  Future<void> _forgotPassword() async {
    HapticFeedback.lightImpact();

    // Navigate to forgot password screen
    Navigator.pushNamed(context, '/forgot-password');
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.mark_email_read, color: Color(0xFF2563EB)),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context).otpVerification),
          ],
        ),
        content: Text(
          AppLocalizations.of(context).comingSoonFeature,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).ok),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await ref
                  .read(authStateProvider.notifier)
                  .sendEmailVerification();
              if (mounted) {
                _showSuccessSnackBar(result.message ??
                    AppLocalizations.of(context).operationSuccessful);
              }
            },
            child: Text(AppLocalizations.of(context).resendOTP),
          ),
        ],
      ),
    );
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
          label: AppLocalizations.of(context).dismiss,
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

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 60, horizontal: 24),
                          child: Column(
                            children: [
                              // Logo with glow effect
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: const Icon(
                                          Icons.local_taxi,
                                          size: 60,
                                          color: Color(0xFF2563EB),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                l10n.welcomeTitle,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.appTagline,
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
                          decoration: BoxDecoration(
                            color: th.cardBackground,
                            borderRadius: const BorderRadius.only(
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

                                // Login Form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Phone Number Field with Country Code
                                      PhoneNumberField(
                                        controller: _phoneController,
                                        selectedCountryCode:
                                            _selectedCountryCode,
                                        onCountryCodeChanged: (code) {
                                          setState(() {
                                            _selectedCountryCode = code;
                                          });
                                        },
                                        labelText: l10n.phoneNumber,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return l10n.phoneRequired;
                                          }
                                          if (value.length < 9) {
                                            return l10n.invalidPhone;
                                          }
                                          return null;
                                        },
                                      ),

                                      const SizedBox(height: 20),

                                      // Password Field with modern design
                                      Container(
                                        decoration: BoxDecoration(
                                          color: th.inputFill,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: th.borderLight,
                                            width: 1,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          style: TextStyle(
                                            color: th.textPrimary,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: l10n.password,
                                            prefixIcon: Icon(
                                              Icons.lock_outlined,
                                              color: th.textSecondary,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscurePassword
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: th.textSecondary,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 20,
                                            ),
                                            labelStyle: TextStyle(
                                              color: th.textSecondary,
                                              fontSize: 16,
                                            ),
                                            hintStyle: TextStyle(
                                              color: th.textHint,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return l10n.passwordRequired;
                                            }
                                            if (value.length < 6) {
                                              return l10n.passwordTooShort;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // Remember Me & Forgot Password
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                            activeColor:
                                                const Color(0xFF2563EB),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          Text(
                                            l10n.rememberMe,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: _forgotPassword,
                                            child: Text(
                                              l10n.forgotPassword,
                                              style: const TextStyle(
                                                color: Color(0xFF2563EB),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 32),

                                      // Login Button with gradient
                                      Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF2563EB),
                                              Color(0xFF1E40AF),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF2563EB)
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: isLoading ? null : _login,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                )
                                              : Text(
                                                  l10n.login,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),

                                      const SizedBox(height: 32),

                                      // Divider with modern style
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: th.divider,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              l10n.or,
                                              style: TextStyle(
                                                color: th.textSecondary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: th.divider,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 32),

                                      // Google Sign-In Button with modern design
                                      Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: th.cardBackground,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: th.border,
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: th.shadowMedium,
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: OutlinedButton.icon(
                                          onPressed:
                                              isLoading ? null : _googleSignIn,
                                          icon: const GoogleIcon(size: 24),
                                          label: Text(
                                            l10n.continueWithGoogle,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: th.textPrimary,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            side: BorderSide.none,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 40),

                                      // Sign Up Link with modern style
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            l10n.dontHaveAccount,
                                            style: TextStyle(
                                              color: th.textSecondary,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterPage()),
                                              );
                                            },
                                            child: Text(
                                              l10n.register,
                                              style: TextStyle(
                                                color: th.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
