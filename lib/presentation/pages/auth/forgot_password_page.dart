import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/theme_helper.dart';
import '../../../data/services/sms_gateway_service.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/country_code_picker.dart';
import '../../widgets/common/custom_back_button.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/common/web_responsive_layout.dart';

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
    final l10n = AppLocalizations.of(context);
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
            l10n.noAccountFoundPhone,
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
          CustomSnackBar.showError(context, result.error ?? l10n.otpFailed);
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, l10n.otpFailed);
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
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);

    if (WebResponsive.isWideWeb(
      context,
      minWidth: WebResponsive.desktopBreakpoint,
    )) {
      return Scaffold(
        body: WebAuthSplitShell(
          title: l10n.forgotPassword,
          subtitle: l10n.enterPhoneResetPassword,
          icon: Icons.lock_reset_rounded,
          child: _buildWebForgotPasswordForm(th, l10n),
        ),
      );
    }

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final content = SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                              l10n.forgotPassword,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.enterPhoneResetPassword,
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
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
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
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Phone Number Field with Country Code (Same Row)
                                    Row(
                                      children: [
                                        // Country Code Picker
                                        Container(
                                          decoration: BoxDecoration(
                                            color: th.inputFill,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: th.border,
                                              width: 1,
                                            ),
                                          ),
                                          child: CountryCodePicker(
                                            selectedCountryCode:
                                                _selectedCountryCode,
                                            onCountryCodeChanged: (code) {
                                              setState(() {
                                                _selectedCountryCode = code;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Phone Number Input Field
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: th.inputFill,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: th.border,
                                                width: 1,
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _phoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                labelText: l10n.phoneNumber,
                                                prefixIcon: const Icon(
                                                    Icons.phone_outlined),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 18,
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return l10n.phoneRequired;
                                                }
                                                if (value.length < 9) {
                                                  return l10n.invalidPhone;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 32),

                                    // Send OTP Button with gradient
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
                                        onPressed: _isLoading ? null : _sendOTP,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                l10n.sendOTP,
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
                                        onTap: () => Navigator.pop(context),
                                        child: Text(
                                          l10n.backToLogin,
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
              );
              if (WebResponsive.isWideWeb(
                context,
                minWidth: WebResponsive.desktopBreakpoint,
              )) {
                return WebAuthSplitShell(
                  title: l10n.forgotPassword,
                  subtitle: l10n.enterPhoneResetPassword,
                  icon: Icons.lock_reset_rounded,
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
    );
  }

  Widget _buildWebForgotPasswordForm(
    ThemeHelper th,
    AppLocalizations l10n,
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
              l10n.forgotPassword,
              style: TextStyle(
                color: th.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.enterPhoneResetPassword,
              style: TextStyle(
                color: th.textSecondary,
                fontSize: 15,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: th.inputFill,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: th.border),
                  ),
                  child: CountryCodePicker(
                    selectedCountryCode: _selectedCountryCode,
                    onCountryCodeChanged: (code) {
                      setState(() {
                        _selectedCountryCode = code;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: th.inputFill,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: th.border),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: l10n.phoneNumber,
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.phoneRequired;
                        }
                        if (value.length < 9) return l10n.invalidPhone;
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.sendOTP,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.backToLogin),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
