import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../l10n/arb/app_localizations.dart';
import '../../../providers/onboarding_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  Timer? _textAnimationTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    // Simple fade animation for logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    ));

    // Simple fade animation for text
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    _logoController.forward();

    // Start text animation after logo animation begins
    _textAnimationTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  void _navigateToNextScreen() {
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _checkAuthenticationState();
      }
    });
  }

  void _checkAuthenticationState() async {
    print('🔍 Checking authentication state...');

    // Check if language has been selected first
    final languageSelected = StorageService.instance
        .getBool('language_selected', defaultValue: false);

    if (languageSelected == false) {
      print('🌐 Language not selected, navigating to language selection');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/language-selection');
      }
      return;
    }

    // Check onboarding status
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    await onboardingNotifier.checkOnboardingStatus();
    final onboardingState = ref.read(onboardingProvider);

    if (!onboardingState.isCompleted) {
      print('📚 First time user, navigating to onboarding');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
      return;
    }

    // Check Firebase Auth directly for persistent user when Firebase is ready.
    User? currentUser;
    try {
      currentUser = FirebaseAuth.instance.currentUser;
    } catch (error) {
      debugPrint('Firebase Auth unavailable during splash: $error');
    }
    print('🔐 Firebase Auth Current User: ${currentUser?.uid ?? "null"}');
    print('👤 Firebase Auth Email: ${currentUser?.email ?? "null"}');

    if (currentUser != null) {
      print('✅ User session found in Firebase Auth, navigating to dashboard');
      // Firebase Auth has a persisted user, keep them logged in
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      print('❌ No user session found, navigating to login');
      // No persisted session, show login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _textAnimationTimer?.cancel();
    _navigationTimer?.cancel();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color:
            th.isDark ? AppColors.darkBackground : AppColors.scaffoldBackground,
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Logo section
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withOpacity(0.1),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDesign.space3XL),

            // Text section
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textOpacityAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDesign.spaceLG,
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.appName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: th.isDark
                                  ? Colors.white
                                  : AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: AppDesign.spaceMD),
                          Text(
                            l10n.appTagline,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: th.isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(flex: 2),

            // Loading indicator
            Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 2.5,
                ),
                const SizedBox(height: AppDesign.spaceLG),
                Text(
                  l10n.loading,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: th.isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: AppDesign.spaceLG),
              child: Column(
                children: [
                  Text(
                    '${l10n.version} 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: th.isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    l10n.poweredBy,
                    style: TextStyle(
                      fontSize: 11,
                      color: th.isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
