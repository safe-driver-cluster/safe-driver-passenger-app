import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/web_responsive_layout.dart';

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

    if (WebResponsive.isWideWeb(
      context,
      minWidth: WebResponsive.desktopBreakpoint,
    )) {
      return LoadingWidget(
        isLoading: isLoading,
        child: Scaffold(
          body: WebAuthSplitShell(
            title: l10n.welcomeTitle,
            subtitle: l10n.appTagline,
            icon: Icons.login_rounded,
            child: _buildWebLoginForm(th, l10n, isLoading),
          ),
        ),
      );
    }

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
                final content = SingleChildScrollView(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo with glow effect - Perfect Circle
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo2.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
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
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.appTagline,
                                textAlign: TextAlign.center,
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
                                              Navigator.pushNamed(
                                                context,
                                                '/register',
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
                if (WebResponsive.isWideWeb(
                  context,
                  minWidth: WebResponsive.desktopBreakpoint,
                )) {
                  return WebAuthSplitShell(
                    title: l10n.welcomeTitle,
                    subtitle: l10n.appTagline,
                    icon: Icons.login_rounded,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: content,
                    ),
                  );
                }
                return content;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLoginForm(
    ThemeHelper th,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: th.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.login,
              style: TextStyle(
                color: th.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.appTagline,
              style: TextStyle(color: th.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 28),
            PhoneNumberField(
              controller: _phoneController,
              selectedCountryCode: _selectedCountryCode,
              onCountryCodeChanged: (code) {
                setState(() {
                  _selectedCountryCode = code;
                });
              },
              labelText: l10n.phoneNumber,
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.phoneRequired;
                if (value.length < 9) return l10n.invalidPhone;
                return null;
              },
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: th.inputFill,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: th.borderLight),
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: th.textPrimary),
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon:
                      Icon(Icons.lock_outlined, color: th.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: th.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.passwordRequired;
                  }
                  if (value.length < 6) return l10n.passwordTooShort;
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF2563EB),
                ),
                Text(l10n.rememberMe),
                const Spacer(),
                TextButton(
                  onPressed: _forgotPassword,
                  child: Text(l10n.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.login,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.dontHaveAccount),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(l10n.register),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
