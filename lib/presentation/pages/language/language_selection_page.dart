import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../providers/language_provider.dart';

class LanguageSelectionPage extends ConsumerStatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  ConsumerState<LanguageSelectionPage> createState() =>
      _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends ConsumerState<LanguageSelectionPage> {
  AppLanguage? selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = AppLanguage.english;
  }

  Future<void> _selectLanguage() async {
    if (selectedLanguage != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );

      try {
        debugPrint(
            '🌐 Selected language: ${selectedLanguage!.code} (${selectedLanguage!.englishName})');

        final languageController =
            ref.read(languageControllerProvider.notifier);
        await languageController.changeLanguage(selectedLanguage!);
        debugPrint('🌐 Language changed in controller');

        await StorageService.instance.saveBool('language_selected', true);
        debugPrint('🌐 Language selection flag saved');

        if (mounted) {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error selecting language: $e'),
              backgroundColor: AppColors.dangerColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.4, 0.8, 1.0],
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.primaryDark,
              AppColors.scaffoldBackground.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildLanguageOptions(),
                      const Spacer(),
                      _buildContinueButton(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App Logo Container with enhanced design
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(70),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF8F9FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(45),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.language_rounded,
              size: 55,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Welcome Text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFF0F0F0)],
          ).createShader(bounds),
          child: const Text(
            'Welcome to SafeDriver',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose Your Language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Text(
            'Select your preferred language to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageOptions() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: const Text(
              'Available Languages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 28),
          ...AppLanguage.values
              .map((language) => _buildLanguageOption(language)),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(AppLanguage language) {
    final isSelected = selectedLanguage == language;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              selectedLanguage = language;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.3),
                width: isSelected ? 3 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Language Flag/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [Colors.white, Colors.white.withOpacity(0.9)]
                          : [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.2)
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getLanguageEmoji(language),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Language Names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        language.englishName,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Colors.white, Color(0xFFF8F9FA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: AppColors.primaryColor,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: selectedLanguage != null
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: selectedLanguage != null ? _selectLanguage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedLanguage != null
              ? Colors.white
              : Colors.white.withOpacity(0.4),
          foregroundColor: AppColors.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: selectedLanguage != null
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.6),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_rounded,
              size: 24,
              color: selectedLanguage != null
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageEmoji(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return '🇺🇸';
      case AppLanguage.sinhala:
        return '🇱🇰';
      case AppLanguage.tamil:
        return '🇱🇰';
    }
  }
}
