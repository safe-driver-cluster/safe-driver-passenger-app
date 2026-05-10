import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_back_button.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String _phoneNumber = '';
  String _otpCode = '';
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _phoneNumber = args['phoneNumber'] ?? '';
        _otpCode = args['otpCode'] ?? '';
        _verificationId = args['verificationId'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    try {
      final authNotifier = ref.read(authStateProvider.notifier);
      final result = await authNotifier.resetPasswordWithPhone(
        phoneNumber: _phoneNumber,
        newPassword: _passwordController.text.trim(),
        otpCode: _otpCode,
        verificationId: _verificationId,
      );

      if (mounted) {
        if (result.success) {
          HapticFeedback.mediumImpact();
          _showSuccessDialog();
        } else {
          HapticFeedback.heavyImpact();
          _showErrorSnackBar(result.message ?? l10n.errorOccurred);
        }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        _showErrorSnackBar(l10n.errorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.passwordResetSuccessful,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.passwordResetSuccessMessage,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                    arguments: {
                      'phoneNumber': _phoneNumber,
                      'message': l10n.passwordResetSuccessLoginMessage,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.goToSignIn,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
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
      ),
    );
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 8) {
      return l10n.passwordTooShort;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return l10n.passwordComplexity;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 24,
                    right: 24,
                    bottom: 40,
                  ),
                  child: Column(
                    children: [
                      // Back Button
                      const Row(
                        children: [
                          CustomBackButton(color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Icon with glow effect
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
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.lock_reset,
                            size: 60,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.resetPassword,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.createStrongNewPassword,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
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

                        // Password Form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // New Password Field with modern design
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: l10n.newPassword,
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      color: Colors.grey[600],
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey[600],
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
                                      vertical: 20,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: _validatePassword,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Confirm Password Field with modern design
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: l10n.confirmPassword,
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      color: Colors.grey[600],
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.grey[600],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 20,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  validator: _validateConfirmPassword,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Password Requirements with modern design
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2563EB).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF2563EB)
                                        .withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.passwordRequirements,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2563EB),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(l10n.passwordReq1,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        )),
                                    Text(l10n.passwordReq2,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        )),
                                    Text(l10n.passwordReq3,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        )),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Reset Password Button with gradient
                              Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2563EB),
                                      Color(0xFF1E40AF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
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
                                  onPressed: _isLoading ? null : _resetPassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          l10n.resetPassword,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Back to Login Link
                              Center(
                                child: GestureDetector(
                                  onTap: () =>
                                      Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  ),
                                  child: Text(
                                    l10n.backToSignIn,
                                    style: const TextStyle(
                                      color: Color(0xFF2563EB),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),
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
        ),
      ),
    );
  }
}
