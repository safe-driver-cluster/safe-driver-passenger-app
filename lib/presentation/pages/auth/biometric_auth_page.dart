import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/services/biometric_service.dart';
import '../../../l10n/arb/app_localizations.dart';

class BiometricAuthPage extends ConsumerStatefulWidget {
  final String? returnTo;

  const BiometricAuthPage({
    super.key,
    this.returnTo = '/dashboard',
  });

  @override
  ConsumerState<BiometricAuthPage> createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends ConsumerState<BiometricAuthPage> {
  late BiometricService _biometricService;
  bool _isAuthenticating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _biometricService = BiometricService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateWithBiometric();
    });
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() {
      _isAuthenticating = true;
      _errorMessage = null;
    });

    final l10n = AppLocalizations.of(context);

    try {
      final isAuthenticated = await _biometricService.authenticate(
        reason: l10n.biometricAuthReason,
      );

      if (isAuthenticated) {
        print('✅ Biometric authentication successful');
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            widget.returnTo ?? '/dashboard',
          );
        }
      } else {
        setState(() {
          _errorMessage = l10n.biometricAuthFailed;
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      print('❌ Biometric authentication error: $e');
      setState(() {
        _errorMessage = '${l10n.biometricAuthError}:\n$e';
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: th.isDark
              ? AppColors.darkBackground
              : AppColors.scaffoldBackground,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lock icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  Text(
                    l10n.biometricAuthTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    l10n.biometricAuthDescription,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 30),

                  // Loading indicator or error
                  if (_isAuthenticating)
                    Column(
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          l10n.biometricAuthWaiting,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  else if (_errorMessage != null)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            border: Border.all(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _authenticateWithBiometric,
                          icon: const Icon(Icons.refresh),
                          label: Text(
                            l10n.biometricAuthRetry,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  // Info text
                  if (!_isAuthenticating && _errorMessage == null)
                    Text(
                      l10n.biometricAuthInfo,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
