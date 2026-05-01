import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

import '../../../core/constants/color_constants.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/biometric_settings_provider.dart';
import '../../../providers/language_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool darkMode = false;
  bool locationServices = true;
  bool autoRefresh = true;
  bool hapticFeedback = true;
  List<String> themes = ['System', 'Light', 'Dark'];

  String _themeLabel(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  ThemeMode _themeModeFromLabel(String? label) {
    switch (label) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      case 'System':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final selectedTheme = _themeLabel(ref.watch(themeModeProvider));
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const CustomBackButton(color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color:
                            colorScheme.shadow.withOpacity(isDark ? 0.28 : 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary.withOpacity(0.14),
                                    colorScheme.secondary.withOpacity(0.14),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.settings,
                                size: 30,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).settings,
                                    style: textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Customize your experience', // TODO: Add to localizations
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Settings List
                        Expanded(
                          child: ListView(
                            children: [
                              // Appearance Section
                              Text(
                                AppLocalizations.of(context).general,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildDropdownSetting(
                                '🎨',
                                'Theme', // TODO: Add to localizations
                                'Choose app theme', // TODO: Add to localizations
                                selectedTheme,
                                themes,
                                (value) {
                                  ref
                                      .read(themeModeProvider.notifier)
                                      .changeThemeMode(
                                        _themeModeFromLabel(value),
                                      );
                                },
                              ),

                              _buildLanguageSetting(),

                              const SizedBox(height: 24),

                              // App Behavior Section
                              Text(
                                'App Behavior', // TODO: Add to localizations
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildSwitchSetting(
                                '📍',
                                'Location Services',
                                'Enable GPS for better experience',
                                locationServices,
                                (value) =>
                                    setState(() => locationServices = value),
                              ),

                              _buildSwitchSetting(
                                '🔄',
                                'Auto Refresh',
                                'Automatically refresh bus timings',
                                autoRefresh,
                                (value) => setState(() => autoRefresh = value),
                              ),

                              _buildSwitchSetting(
                                '📳',
                                'Haptic Feedback',
                                'Vibration feedback for interactions',
                                hapticFeedback,
                                (value) =>
                                    setState(() => hapticFeedback = value),
                              ),

                              const SizedBox(height: 24),

                              // Privacy & Security Section
                              Text(
                                'Privacy & Security',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Biometric Settings
                              _buildBiometricSettings(),

                              const SizedBox(height: 24),

                              _buildActionSetting(
                                '🔒',
                                'Privacy Policy',
                                'View our privacy policy',
                                () => _showComingSoon(context),
                              ),

                              _buildActionSetting(
                                '📜',
                                'Terms of Service',
                                'Read terms and conditions',
                                () => _showComingSoon(context),
                              ),

                              _buildActionSetting(
                                '🗑️',
                                'Clear Cache',
                                'Free up storage space',
                                () => _showClearCacheDialog(context),
                              ),

                              const SizedBox(height: 24),

                              // App Info Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withOpacity(isDark ? 0.28 : 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'App Version',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          '1.0.0',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Build Number',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          '100',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String emoji,
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tileColor = colorScheme.surfaceContainerHighest.withOpacity(
      theme.brightness == Brightness.dark ? 0.28 : 1,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSetting() {
    final currentLanguage = ref.watch(languageControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tileColor = colorScheme.surfaceContainerHighest.withOpacity(
      theme.brightness == Brightness.dark ? 0.28 : 1,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🌍', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).language,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).selectLanguage,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: currentLanguage,
                isDense: true,
                dropdownColor: colorScheme.surface,
                items: AppLanguage.values.map((AppLanguage language) {
                  return DropdownMenuItem<AppLanguage>(
                    value: language,
                    child: Text(
                      language.englishName,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (AppLanguage? newLanguage) async {
                  if (newLanguage != null && newLanguage != currentLanguage) {
                    try {
                      final languageController =
                          ref.read(languageControllerProvider.notifier);
                      await languageController.changeLanguage(newLanguage);

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Language changed to ${newLanguage.englishName}'),
                            backgroundColor: AppColors.successColor,
                          ),
                        );

                        // Navigate back and force rebuild by replacing the entire navigation stack
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/dashboard',
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to change language: $e'),
                            backgroundColor: AppColors.errorColor,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String emoji,
    String title,
    String description,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tileColor = colorScheme.surfaceContainerHighest.withOpacity(
      theme.brightness == Brightness.dark ? 0.28 : 1,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outline.withOpacity(0.4)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isDense: true,
                dropdownColor: colorScheme.surface,
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
    String emoji,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tileColor = colorScheme.surfaceContainerHighest.withOpacity(
      theme.brightness == Brightness.dark ? 0.28 : 1,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context).comingSoon),
        content:
            const Text('This feature will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache'),
        content: const Text(
            'Are you sure you want to clear the app cache? This will free up storage space but may slow down the app temporarily.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully!'),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSettings() {
    return Consumer(
      builder: (context, watch, _) {
        final biometricSettings = ref.watch(biometricSettingsProvider);
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final tileColor = colorScheme.surfaceContainerHighest.withOpacity(
          theme.brightness == Brightness.dark ? 0.28 : 1,
        );

        if (!biometricSettings.isBiometricSupported) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('🔐', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Biometric Authentication',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Not supported on this device',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Main Biometric Toggle
            _buildSwitchSetting(
              '🔐',
              'Biometric Lock',
              biometricSettings.primaryBiometricType != null
                  ? 'Use ${biometricSettings.primaryBiometricType} to unlock'
                  : 'Enable biometric authentication',
              biometricSettings.isBiometricEnabled,
              (value) async {
                final notifier = ref.read(biometricSettingsProvider.notifier);
                await notifier.setBiometricEnabled(value);
              },
            ),

            // Fingerprint Option
            if (biometricSettings.isBiometricSupported &&
                biometricSettings.isBiometricEnabled)
              _buildSwitchSetting(
                '👆',
                'Fingerprint',
                'Allow fingerprint authentication',
                biometricSettings.isFingerPrintEnabled,
                (value) async {
                  final notifier = ref.read(biometricSettingsProvider.notifier);
                  await notifier.setFingerPrintEnabled(value);
                },
              ),

            // Face ID Option
            if (biometricSettings.isBiometricSupported &&
                biometricSettings.isBiometricEnabled)
              _buildSwitchSetting(
                '😊',
                'Face Recognition',
                'Allow face ID authentication',
                biometricSettings.isFaceIdEnabled,
                (value) async {
                  final notifier = ref.read(biometricSettingsProvider.notifier);
                  await notifier.setFaceIdEnabled(value);
                },
              ),

            // Require on App Open
            if (biometricSettings.isBiometricEnabled)
              _buildSwitchSetting(
                '📱',
                'Require on App Open',
                'Ask for biometric when opening the app',
                biometricSettings.requireBiometricOnAppOpen,
                (value) async {
                  final notifier = ref.read(biometricSettingsProvider.notifier);
                  await notifier.setRequireBiometricOnAppOpen(value);
                },
              ),

            // Error Message - Inline text only
            if (biometricSettings.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  biometricSettings.error ?? 'An error occurred',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.errorColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
