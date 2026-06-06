import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/custom_back_button.dart';
import '../../widgets/common/google_icon.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/web_responsive_layout.dart';

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
      _showErrorSnackBar(AppLocalizations.of(context).acceptTerms);
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
        _showErrorSnackBar(
            result.message ?? AppLocalizations.of(context).registrationFailed);
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
        backgroundColor: const Color(0xFFCF6679),
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

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).firstNameRequired;
    }
    if (value.length < 2) {
      return AppLocalizations.of(context).firstNameMinLength;
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).lastNameRequired;
    }
    if (value.length < 2) {
      return AppLocalizations.of(context).lastNameMinLength;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AppLocalizations.of(context).invalidEmail;
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).phoneRequired;
    }
    // For Sri Lankan numbers, expect 9 digits (without country code)
    if (_selectedCountryCode == '+94' && value.length != 9) {
      return AppLocalizations.of(context).invalidPhone;
    }
    // For other countries, basic length check
    if (value.length < 7 || value.length > 15) {
      return AppLocalizations.of(context).invalidPhone;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).passwordRequired;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context).passwordTooShort;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return AppLocalizations.of(context).passwordComplexity;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return AppLocalizations.of(context).passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
            title: l10n.createAccount,
            subtitle: l10n.appTagline,
            icon: Icons.person_add_alt_1_rounded,
            contentWidth: 720,
            child: _buildWebRegisterForm(l10n, isLoading),
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
                final content = Column(
                  children: [
                    // Header with back button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CustomBackButton(
                            onPressed: () => Navigator.pop(context),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    // Header Section
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 24),
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
                                  'assets/images/logo2.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
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
                            Text(
                              l10n.createAccount,
                              style: const TextStyle(
                                fontSize: 32,
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
                    ),

                    // Form Section
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
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
                                              labelText: l10n.firstName,
                                              prefixIcon: const Icon(
                                                  Icons.person_outlined),
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
                                            validator: _validateFirstName,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _lastNameController,
                                            decoration: InputDecoration(
                                              labelText: l10n.lastName,
                                              prefixIcon: const Icon(
                                                  Icons.person_outlined),
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
                                            validator: _validateLastName,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // Email Field
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: l10n.email,
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
                                      labelText: l10n.phoneNumber,
                                      validator: _validatePhoneNumber,
                                    ),

                                    const SizedBox(height: 16),

                                    // Password Field
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: l10n.password,
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
                                        labelText: l10n.confirmPassword,
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
                                          activeColor: const Color(0xFF2563EB),
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
                                                  children: [
                                                    TextSpan(
                                                        text: l10n.iAgreeTo),
                                                    TextSpan(
                                                      text: l10n.termsOfService,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF2563EB),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(text: l10n.and),
                                                    TextSpan(
                                                      text: l10n.privacyPolicy,
                                                      style: const TextStyle(
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
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              l10n.createAccount,
                                              style: const TextStyle(
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
                                            l10n.or,
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
                                      label: Text(
                                        l10n.continueWithGoogle,
                                        style: const TextStyle(
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
                                          l10n.alreadyHaveAccount,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            l10n.signIn,
                                            style: const TextStyle(
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
                    ),
                  ],
                );
                if (WebResponsive.isWideWeb(
                  context,
                  minWidth: WebResponsive.desktopBreakpoint,
                )) {
                  return WebAuthSplitShell(
                    title: l10n.createAccount,
                    subtitle: l10n.appTagline,
                    icon: Icons.person_add_alt_1_rounded,
                    contentWidth: 640,
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

  Widget _buildWebRegisterForm(AppLocalizations l10n, bool isLoading) {
    const panelColor = Color(0xFF1E293B);
    const inputColor = Color(0xFF0F172A);
    const inputBorder = Color(0xFF334155);
    const textPrimary = Colors.white;
    const textSecondary = Color(0xFFCBD5E1);
    const textMuted = Color(0xFF94A3B8);
    const primary = Color(0xFF2563EB);

    InputDecoration fieldDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: textSecondary),
        filled: true,
        fillColor: inputColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 32,
            offset: const Offset(0, 18),
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
              l10n.createAccount,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.appTagline,
              style: const TextStyle(color: textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    style: const TextStyle(color: textPrimary),
                    decoration:
                        fieldDecoration(l10n.firstName, Icons.person_outlined),
                    validator: _validateFirstName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    style: const TextStyle(color: textPrimary),
                    decoration:
                        fieldDecoration(l10n.lastName, Icons.person_outlined),
                    validator: _validateLastName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: textPrimary),
              decoration: fieldDecoration(l10n.email, Icons.email_outlined),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: inputColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: inputBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      dropdownColor: panelColor,
                      iconEnabledColor: textSecondary,
                      style: const TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      onChanged: (code) {
                        if (code == null) return;
                        setState(() {
                          _selectedCountryCode = code;
                        });
                      },
                      items: CountryCodePicker.countries
                          .map<DropdownMenuItem<String>>((country) {
                        return DropdownMenuItem<String>(
                          value: country['code'],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(country['flag']!),
                              const SizedBox(width: 8),
                              Text(country['code']!),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: textPrimary),
                    decoration:
                        fieldDecoration(l10n.phoneNumber, Icons.phone_outlined),
                    validator: _validatePhoneNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: textPrimary),
                    decoration: fieldDecoration(
                      l10n.password,
                      Icons.lock_outlined,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: textPrimary),
                    decoration: fieldDecoration(
                      l10n.confirmPassword,
                      Icons.lock_outlined,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF2563EB),
                  checkColor: Colors.white,
                  side: const BorderSide(color: textMuted),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(text: l10n.iAgreeTo),
                          TextSpan(
                            text: l10n.termsOfService,
                            style: const TextStyle(
                              color: Color(0xFF60A5FA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: l10n.and),
                          TextSpan(
                            text: l10n.privacyPolicy,
                            style: const TextStyle(
                              color: Color(0xFF60A5FA),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primary.withValues(alpha: 0.55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.createAccount,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: isLoading ? null : _googleSignUp,
              icon: const GoogleIcon(size: 20),
              label: Text(
                l10n.continueWithGoogle,
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.alreadyHaveAccount,
                  style: const TextStyle(color: textSecondary),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                  ),
                  child: Text(
                    l10n.signIn,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
