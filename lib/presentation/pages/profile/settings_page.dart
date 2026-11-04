import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/passenger_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/biometric_settings_provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/passenger_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/common/profile_page_components.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with WidgetsBindingObserver {
  late final Future<PackageInfo> _packageInfoFuture;

  static const List<String> _themes = ['System', 'Light', 'Dark'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appSettingsProvider.notifier).refreshDeviceSettings();
    }
  }

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
    final localizations = AppLocalizations.of(context);
    final currentThemeMode = ref.watch(themeModeProvider);
    final biometricSettings = ref.watch(biometricSettingsProvider);
    final appSettings = ref.watch(appSettingsProvider);
    final passengerAsync = ref.watch(currentPassengerProvider);

    return ProfilePageScaffold(
      title: localizations.settings,
      accentColor: AppColors.accentColor,
      children: [
        _buildPreferencesCard(context, localizations, currentThemeMode),
        const SizedBox(height: AppDesign.spaceLG),
        _buildExperienceCard(context, appSettings),
        const SizedBox(height: AppDesign.spaceLG),
        _buildCommunicationCard(context, passengerAsync),
        const SizedBox(height: AppDesign.spaceLG),
        _buildSecurityCard(context, biometricSettings),
        const SizedBox(height: AppDesign.spaceLG),
        _buildAppInfoCard(context),
      ],
    );
  }

  Widget _buildPreferencesCard(
    BuildContext context,
    AppLocalizations localizations,
    ThemeMode currentThemeMode,
  ) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.palette_outlined,
            title: 'Appearance & Language',
            subtitle: 'Choose how SafeDriver looks and reads.',
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildThemeSetting(context, currentThemeMode),
          const SizedBox(height: AppDesign.spaceMD),
          _buildLanguageSetting(context, localizations),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
    BuildContext context,
    AppSettingsState appSettings,
  ) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.auto_awesome_motion_rounded,
            title: 'App Experience',
            subtitle: 'Control the helpful extras that shape daily use.',
            color: AppColors.secondaryColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildSwitchSetting(
            context: context,
            icon: Icons.location_on_outlined,
            title: 'Location access',
            description: appSettings.locationDescription,
            value: appSettings.locationUsageEnabled,
            badge: appSettings.locationBadge,
            isBusy: appSettings.isLocationBusy,
            onChanged: (value) async {
              final message = await ref
                  .read(appSettingsProvider.notifier)
                  .setLocationEnabled(value);
              if (!mounted) {
                return;
              }

              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor:
                      ref.read(appSettingsProvider).isLocationEnabled
                          ? AppColors.successColor
                          : AppColors.warningColor,
                ),
              );
            },
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildSwitchSetting(
            context: context,
            icon: Icons.sync_rounded,
            title: 'Auto refresh',
            description:
                'Refresh bus timing and route information automatically.',
            value: appSettings.autoRefreshEnabled,
            onChanged: (value) async {
              await ref
                  .read(appSettingsProvider.notifier)
                  .setAutoRefreshEnabled(value);
            },
          ),
          const SizedBox(height: AppDesign.spaceMD),
          _buildSwitchSetting(
            context: context,
            icon: Icons.vibration_rounded,
            title: 'Haptic feedback',
            description: 'Use gentle vibration for taps and confirmations.',
            value: appSettings.hapticFeedbackEnabled,
            onChanged: (value) async {
              await ref
                  .read(appSettingsProvider.notifier)
                  .setHapticFeedbackEnabled(value);
              if (value) {
                HapticFeedback.selectionClick();
              }
            },
          ),
          if (appSettings.error != null) ...[
            const SizedBox(height: AppDesign.spaceMD),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDesign.spaceMD),
              decoration: BoxDecoration(
                color: AppColors.errorColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                border: Border.all(
                  color: AppColors.errorColor.withValues(alpha: 0.16),
                ),
              ),
              child: Text(
                appSettings.error!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityCard(
    BuildContext context,
    BiometricSettings biometricSettings,
  ) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(
            icon: Icons.shield_outlined,
            title: 'Privacy & Security',
            subtitle: 'Protect access and review important app policies.',
            color: AppColors.warningColor,
          ),
          const SizedBox(height: AppDesign.spaceLG),
          _buildChangePasswordSection(context),
          const SizedBox(height: AppDesign.spaceMD),
          ..._buildBiometricSettings(context, biometricSettings),
          const SizedBox(height: AppDesign.spaceMD),
          ProfileActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy policy',
            subtitle: 'See how account, location, and safety data are handled.',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.description_outlined,
            title: 'Terms of service',
            subtitle: 'Review passenger app guidelines and responsibilities.',
            onTap: () => _showComingSoon(context),
          ),
          const Divider(height: 24),
          ProfileActionTile(
            icon: Icons.delete_sweep_outlined,
            title: 'Clear cache',
            subtitle:
                'Remove temporary app files and free some device storage.',
            color: AppColors.dangerColor,
            onTap: () => _showClearCacheDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationCard(
    BuildContext context,
    AsyncValue<PassengerModel?> passengerAsync,
  ) {
    return ProfileSectionCard(
      child: passengerAsync.when(
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileSectionHeader(
              icon: Icons.mail_outline_rounded,
              title: 'Email Updates',
              subtitle: 'Preparing your communication preferences.',
              color: AppColors.infoColor,
            ),
            SizedBox(height: AppDesign.spaceLG),
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        error: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileSectionHeader(
              icon: Icons.mail_outline_rounded,
              title: 'Email Updates',
              subtitle: 'We could not load your email settings right now.',
              color: AppColors.infoColor,
            ),
          ],
        ),
        data: (passenger) {
          if (passenger == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ProfileSectionHeader(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Updates',
                  subtitle: 'Sign in to manage delivery preferences.',
                  color: AppColors.infoColor,
                ),
              ],
            );
          }

          final notifications = passenger.preferences.notifications;
          final emailDescription = notifications.emailEnabled
              ? 'SafeDriver can send confirmations and receipts to ${passenger.email}.'
              : 'All app-generated emails are currently turned off for ${passenger.email}.';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileSectionHeader(
                icon: Icons.mail_outline_rounded,
                title: 'Email Updates',
                subtitle: 'Decide which important app events arrive in your inbox.',
                color: AppColors.infoColor,
              ),
              const SizedBox(height: AppDesign.spaceLG),
              _buildSwitchSetting(
                context: context,
                icon: Icons.alternate_email_rounded,
                color: AppColors.infoColor,
                title: 'Email notifications',
                description: emailDescription,
                value: notifications.emailEnabled,
                onChanged: (value) async {
                  await _savePassengerNotifications(
                    passenger,
                    notifications.copyWith(emailEnabled: value),
                  );
                },
              ),
              const SizedBox(height: AppDesign.spaceMD),
              _buildSwitchSetting(
                context: context,
                icon: Icons.feedback_outlined,
                color: AppColors.successColor,
                title: 'Feedback confirmations',
                description:
                    'Receive a copy when you submit bus or service feedback.',
                value: notifications.feedbackEmails,
                onChanged: (value) async {
                  await _savePassengerNotifications(
                    passenger,
                    notifications.copyWith(feedbackEmails: value),
                  );
                },
              ),
              const SizedBox(height: AppDesign.spaceMD),
              _buildSwitchSetting(
                context: context,
                icon: Icons.receipt_long_outlined,
                color: AppColors.primaryColor,
                title: 'Journey summaries',
                description:
                    'Get an email receipt with trip timing when a journey ends.',
                value: notifications.journeyEmails,
                onChanged: (value) async {
                  await _savePassengerNotifications(
                    passenger,
                    notifications.copyWith(journeyEmails: value),
                  );
                },
              ),
              const SizedBox(height: AppDesign.spaceMD),
              _buildSwitchSetting(
                context: context,
                icon: Icons.lock_clock_outlined,
                color: AppColors.warningColor,
                title: 'Security alerts',
                description:
                    'Receive account safety emails, including password change confirmations.',
                value: notifications.securityEmails,
                onChanged: (value) async {
                  await _savePassengerNotifications(
                    passenger,
                    notifications.copyWith(securityEmails: value),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChangePasswordSection(BuildContext context) {
    final th = ThemeHelper.of(context);

    if (!_supportsPasswordChange()) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDesign.spaceMD),
        decoration: BoxDecoration(
          color: th.subtleBackground,
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          border: Border.all(color: th.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.infoColor,
              size: 18,
            ),
            const SizedBox(width: AppDesign.spaceSM),
            Expanded(
              child: Text(
                'Password change is available only for email sign-in accounts.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: th.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ProfileActionTile(
      icon: Icons.lock_reset_rounded,
      title: 'Change password',
      subtitle: 'Open a secure form to update your current password.',
      color: AppColors.primaryColor,
      onTap: () => _openChangePasswordSheet(context),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    final th = ThemeHelper.of(context);

    return FutureBuilder<PackageInfo>(
      future: _packageInfoFuture,
      builder: (context, snapshot) {
        final packageInfo = snapshot.data;
        final version = packageInfo?.version ?? 'Loading...';
        final buildNumber = packageInfo?.buildNumber ?? '--';

        return ProfileSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileSectionHeader(
                icon: Icons.info_outline_rounded,
                title: 'App Info',
                subtitle: 'Current release details for this device.',
                color: AppColors.infoColor,
              ),
              const SizedBox(height: AppDesign.spaceLG),
              _buildInfoRow(
                context,
                label: 'Version',
                value: version,
                highlightColor: AppColors.primaryColor,
              ),
              const SizedBox(height: AppDesign.spaceMD),
              _buildInfoRow(
                context,
                label: 'Build number',
                value: buildNumber,
              ),
              const SizedBox(height: AppDesign.spaceMD),
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceMD),
                decoration: BoxDecoration(
                  color: th.subtleBackground,
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: AppColors.successColor,
                    ),
                    const SizedBox(width: AppDesign.spaceSM),
                    Expanded(
                      child: Text(
                        'SafeDriver keeps your ride, safety, and support tools connected through the latest app experience.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: th.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSetting(BuildContext context, ThemeMode currentThemeMode) {
    final th = ThemeHelper.of(context);
    return _SettingTile(
      icon: Icons.dark_mode_outlined,
      color: AppColors.primaryColor,
      title: 'Theme',
      subtitle: 'Pick light, dark, or system default.',
      trailing: _DropdownContainer(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _themeLabel(currentThemeMode),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            dropdownColor: th.surface,
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            items: _themes
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: (value) {
              ref
                  .read(themeModeProvider.notifier)
                  .changeThemeMode(_themeModeFromLabel(value));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSetting(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final currentLanguage = ref.watch(languageControllerProvider);
    final th = ThemeHelper.of(context);

    return _SettingTile(
      icon: Icons.language_rounded,
      color: AppColors.infoColor,
      title: localizations.language,
      subtitle: localizations.selectLanguage,
      trailing: _DropdownContainer(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AppLanguage>(
            value: currentLanguage,
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            dropdownColor: th.surface,
            style: AppTextStyles.bodySmall.copyWith(
              color: th.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            items: AppLanguage.values
                .map(
                  (language) => DropdownMenuItem<AppLanguage>(
                    value: language,
                    child: Text(language.englishName),
                  ),
                )
                .toList(),
            onChanged: (newLanguage) async {
              if (newLanguage == null || newLanguage == currentLanguage) {
                return;
              }

              try {
                await ref
                    .read(languageControllerProvider.notifier)
                    .changeLanguage(newLanguage);

                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Language changed to ${newLanguage.englishName}',
                    ),
                    backgroundColor: AppColors.successColor,
                  ),
                );

                Navigator.of(this.context).pushNamedAndRemoveUntil(
                  '/dashboard',
                  (route) => false,
                );
              } catch (error) {
                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to change language: $error'),
                    backgroundColor: AppColors.errorColor,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchSetting({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color color = AppColors.primaryColor,
    String? badge,
    bool isBusy = false,
  }) {
    return _SettingTile(
      icon: icon,
      color: color,
      title: title,
      subtitle: description,
      badge: badge,
      trailing: isBusy
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryColor,
              ),
            )
          : Switch.adaptive(
              value: value,
              activeThumbColor: AppColors.primaryColor,
              onChanged: onChanged,
            ),
    );
  }

  List<Widget> _buildBiometricSettings(
    BuildContext context,
    BiometricSettings biometricSettings,
  ) {
    if (!biometricSettings.isBiometricSupported) {
      return [
        const _SettingTile(
          icon: Icons.lock_outline_rounded,
          color: AppColors.warningColor,
          title: 'Biometric authentication',
          subtitle: 'This device does not currently support biometric unlock.',
        ),
      ];
    }

    final notifier = ref.read(biometricSettingsProvider.notifier);
    final widgets = <Widget>[
      _buildSwitchSetting(
        context: context,
        icon: Icons.fingerprint_rounded,
        color: AppColors.successColor,
        title: 'Biometric lock',
        description: biometricSettings.primaryBiometricType != null
            ? 'Use ${biometricSettings.primaryBiometricType} to unlock the app.'
            : 'Enable biometric authentication for faster secure access.',
        value: biometricSettings.isBiometricEnabled,
        onChanged: (value) async {
          await notifier.setBiometricEnabled(value);
        },
      ),
    ];

    if (biometricSettings.isBiometricEnabled) {
      widgets.add(const SizedBox(height: AppDesign.spaceMD));
      widgets.add(
        _buildSwitchSetting(
          context: context,
          icon: Icons.touch_app_rounded,
          color: AppColors.infoColor,
          title: 'Fingerprint',
          description: 'Allow fingerprint checks when you sign back in.',
          value: biometricSettings.isFingerPrintEnabled,
          onChanged: (value) async {
            await notifier.setFingerPrintEnabled(value);
          },
        ),
      );

      widgets.add(const SizedBox(height: AppDesign.spaceMD));
      widgets.add(
        _buildSwitchSetting(
          context: context,
          icon: Icons.face_retouching_natural_rounded,
          color: AppColors.accentColor,
          title: 'Face recognition',
          description: 'Allow face verification when your device supports it.',
          value: biometricSettings.isFaceIdEnabled,
          onChanged: (value) async {
            await notifier.setFaceIdEnabled(value);
          },
        ),
      );

      widgets.add(const SizedBox(height: AppDesign.spaceMD));
      widgets.add(
        _buildSwitchSetting(
          context: context,
          icon: Icons.smartphone_rounded,
          color: AppColors.warningColor,
          title: 'Require on app open',
          description: 'Ask for biometric confirmation whenever the app opens.',
          value: biometricSettings.requireBiometricOnAppOpen,
          onChanged: (value) async {
            await notifier.setRequireBiometricOnAppOpen(value);
          },
        ),
      );
    }

    if (biometricSettings.error != null) {
      widgets.add(const SizedBox(height: AppDesign.spaceMD));
      widgets.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDesign.spaceMD),
          decoration: BoxDecoration(
            color: AppColors.errorColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            border: Border.all(
              color: AppColors.errorColor.withValues(alpha: 0.16),
            ),
          ),
          child: Text(
            biometricSettings.error!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? highlightColor,
  }) {
    final th = ThemeHelper.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: th.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: highlightColor ?? th.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  bool _supportsPasswordChange() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    return user.providerData.any(
      (provider) => provider.providerId == 'password',
    );
  }

  Future<void> _savePassengerNotifications(
    PassengerModel passenger,
    PassengerNotificationSettings notifications,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final updatedPreferences = passenger.preferences.copyWith(
        notifications: notifications,
      );

      await ref.read(passengerControllerProvider.notifier).updatePreferences(
            userId: passenger.id,
            preferences: updatedPreferences,
          );

      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Email preferences updated.'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('Unable to update email preferences: $error'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> _openChangePasswordSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => const _ChangePasswordSheet(),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        title: Text(AppLocalizations.of(context).comingSoon),
        content: const Text(
          'This feature will be available in a future update.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear the app cache? This frees storage space but may briefly slow the app while data is rebuilt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
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
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final String? badge;

  const _SettingTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: th.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDesign.radiusMD),
            ),
            child: Icon(icon, size: AppDesign.iconSM, color: color),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: th.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: AppDesign.spaceSM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDesign.spaceSM,
                          vertical: AppDesign.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.safeColor.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusFull),
                        ),
                        child: Text(
                          badge!,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.safeColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDesign.spaceMD),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final localizations = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: th.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDesign.radius2XL),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDesign.spaceLG,
              AppDesign.spaceMD,
              AppDesign.spaceLG,
              AppDesign.spaceXL,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: th.border,
                        borderRadius:
                            BorderRadius.circular(AppDesign.radiusFull),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDesign.spaceSM),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusMD),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primaryColor,
                          size: AppDesign.iconSM,
                        ),
                      ),
                      const SizedBox(width: AppDesign.spaceMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.changePassword,
                              style: AppTextStyles.headline6.copyWith(
                                color: th.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Enter your current password, then set a new secure password.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: th.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                  _buildPasswordField(
                    context,
                    controller: _currentPasswordController,
                    label: 'Current Password',
                    obscureText: _obscureCurrentPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.passwordRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  _buildPasswordField(
                    context,
                    controller: _newPasswordController,
                    label: localizations.newPassword,
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    validator: (value) {
                      final baseValidation =
                          ValidationUtils.validatePassword(value);
                      if (baseValidation != null) {
                        return baseValidation;
                      }
                      if (value == _currentPasswordController.text.trim()) {
                        return 'New password must be different from current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  _buildPasswordField(
                    context,
                    controller: _confirmPasswordController,
                    label: localizations.confirmPassword,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) =>
                        ValidationUtils.validateConfirmPassword(
                      value,
                      _newPasswordController.text.trim(),
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceMD),
                  Text(
                    'Use at least 8 characters with uppercase, lowercase, and a number.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: th.textHint,
                    ),
                  ),
                  const SizedBox(height: AppDesign.spaceLG),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleChangePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDesign.spaceMD,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDesign.radiusLG),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Text(localizations.changePassword),
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

  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    final th = ThemeHelper.of(context);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: th.cardBackground,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: BorderSide(color: th.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: BorderSide(color: th.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDesign.radiusLG)),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final messenger = ScaffoldMessenger.of(context);

    try {
      await AuthService().changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      HapticFeedback.lightImpact();
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully.'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _DropdownContainer extends StatelessWidget {
  final Widget child;

  const _DropdownContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.cardBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusMD),
        border: Border.all(color: th.border),
      ),
      child: child,
    );
  }
}
