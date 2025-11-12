import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../providers/auth_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateToNextScreen();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _logoController.forward();

    // Start text animation after logo animation begins
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  void _navigateToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _checkAuthenticationState();
      }
    });
  }

  void _checkAuthenticationState() {
    print('🔍 Checking authentication state...');
    final authState = ref.read(authStateProvider);
    print('🔍 Auth state: ${authState.toString()}');
    print('🔍 User: ${authState.user?.uid ?? 'null'}');

    if (authState.user != null) {
      print('✅ User is authenticated, navigating to dashboard');
      // User is authenticated, go to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      print('❌ User is not authenticated, navigating to login');
      // User is not authenticated, go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryDark,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacityAnimation.value,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: AppColors.glassGradient,
                                borderRadius:
                                    BorderRadius.circular(AppDesign.radius2XL),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    offset: const Offset(0, 20),
                                  ),
                                  BoxShadow(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.2),
                                    blurRadius: 60,
                                    offset: const Offset(0, 30),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppDesign.radiusLG),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_bus_rounded,
                                  size: AppDesign.icon3XL,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Animated Text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlideAnimation,
                          child: FadeTransition(
                            opacity: _textOpacityAnimation,
                            child: Column(
                              children: [
                                const Text(
                                  'SafeDriver',
                                  style: TextStyle(
                                    fontSize: AppDesign.text4XL,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(height: AppDesign.spaceMD),
                                const Text(
                                  'Your Safety, Our Priority',
                                  style: TextStyle(
                                    fontSize: AppDesign.textLG,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppDesign.spaceLG),
                                Container(
                                  width: 100,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.9),
                                        Colors.white.withOpacity(0.3),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppDesign.radiusSM),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Loading indicator and version
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Modern Loading indicator
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(AppDesign.spaceSM),
                      decoration: BoxDecoration(
                        gradient: AppColors.glassGradient,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusFull),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),

                    const SizedBox(height: AppDesign.spaceLG),

                    // Loading text
                    const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: AppDesign.textMD,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: AppDesign.space2XL),

                    // Version and powered by
                    Column(
                      children: [
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: AppDesign.textXS,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppDesign.spaceXS),
                        Text(
                          'Powered by SafeDriver Technologies',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDesign.spaceLG),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
