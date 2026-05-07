import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safedriver_passenger_app/l10n/arb/app_localizations.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../core/services/sos_service.dart';
import '../../../core/utils/theme_helper.dart';
import '../../../data/models/passenger_model.dart';
import '../../../data/services/passenger_service.dart';
import '../../widgets/common/professional_widgets.dart';
import '../../widgets/sos/sos_contacts_dialog.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _sosService = SosService();

  // Form controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dateOfBirthController;

  // Address controllers
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;

  // Emergency contact controllers
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _emergencyRelationController;

  // State variables
  PassengerModel? _currentProfile;
  File? _selectedImage;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _profileImageUrl;

  // Preference states
  bool _notificationsEnabled = true;
  bool _locationSharingEnabled = true;
  String _preferredLanguage = 'English';
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Initialize _selectedGender with a placeholder that will be updated in _loadUserProfile or build
    _selectedGender = '';
    _loadUserProfile();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();

    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();

    _emergencyNameController = TextEditingController();
    _emergencyPhoneController = TextEditingController();
    _emergencyRelationController = TextEditingController();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile =
            await PassengerService.instance.getPassengerProfile(user.uid);
        if (profile != null) {
          _populateFormFields(profile);
        }
        await _loadLatestSosContact();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
            AppLocalizations.of(context).errorLoadingProfile(e.toString()));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateFormFields(PassengerModel profile) {
    setState(() {
      _currentProfile = profile;
      _profileImageUrl = profile.profileImageUrl;

      // Basic info
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _phoneController.text = profile.phoneNumber;
      _dateOfBirthController.text = _formatDateOfBirth(profile.dateOfBirth);

      // Address
      if (profile.address != null) {
        _streetController.text = profile.address!.street;
        _cityController.text = profile.address!.city;
        _stateController.text = ''; // No state field in model
        _zipCodeController.text = profile.address!.postalCode;
      }

      // Emergency contact
      if (profile.emergencyContact != null) {
        _emergencyNameController.text = profile.emergencyContact!.name;
        _emergencyPhoneController.text = profile.emergencyContact!.phoneNumber;
        _emergencyRelationController.text =
            profile.emergencyContact!.relationship;
      }

      // Preferences
      _notificationsEnabled = profile.preferences.notifications.journeyUpdates;
      _locationSharingEnabled = profile.preferences.privacy.shareLocation;

      // Map language code to display name
      _preferredLanguage =
          _mapLanguageCodeToDisplayName(profile.preferences.language);

      // Set gender dropdown value
      _selectedGender = _mapGenderToDisplayValue(profile.gender);
    });
  }

  Future<void> _loadLatestSosContact() async {
    final contacts = await _sosService.getContacts();
    if (!mounted || contacts.isEmpty) return;

    final latestContact = [...contacts]..sort(_compareSosContactsNewestFirst);
    final contact = latestContact.first;

    setState(() {
      _emergencyNameController.text = contact.name;
      _emergencyPhoneController.text = contact.phoneNumber;
      _emergencyRelationController.text = contact.relationship;
    });
  }

  int _compareSosContactsNewestFirst(SosContact a, SosContact b) {
    final aId = int.tryParse(a.id);
    final bId = int.tryParse(b.id);

    if (aId != null && bId != null) {
      return bId.compareTo(aId);
    }

    return b.id.compareTo(a.id);
  }

  String _formatDateOfBirth(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);

    // Ensure _selectedGender is initialized with a localized value if it's still empty
    if (_selectedGender.isEmpty) {
      _selectedGender = l10n.preferNotToSay;
    }

    return Scaffold(
      backgroundColor: th.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor,
              AppColors.primaryColor,
              th.background,
            ],
            stops: const [0.0, 0.3, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Professional Header
              _buildProfessionalHeader(context),

              // Form Content
              Expanded(
                child: _isLoading ? _buildLoadingState() : _buildFormContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Row(
        children: [
          // Professional back button
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.glassGradient,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: AppDesign.spaceMD),

          // Title
          Expanded(
            child: Text(
              AppLocalizations.of(context).editProfile,
              style: AppTextStyles.headline5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Save button
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.successGradient,
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              boxShadow: [
                BoxShadow(
                  color: AppColors.successColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context).save,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          Text(
            AppLocalizations.of(context).loadingProfile,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    final th = ThemeHelper.of(context);
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDesign.spaceLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            _buildProfilePictureSection(),
            const SizedBox(height: AppDesign.spaceLG),

            // Basic Information
            _buildBasicInfoSection(),
            const SizedBox(height: AppDesign.spaceLG),

            // Address Information
            _buildAddressSection(),
            const SizedBox(height: AppDesign.spaceLG),

            // Emergency Contact
            _buildEmergencyContactSection(),
            const SizedBox(height: AppDesign.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(
                Icons.photo_camera_rounded,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                AppLocalizations.of(context).profilePicture,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Profile picture display and upload
          Center(
            child: GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              _profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultAvatar(),
                            ),
                          )
                        : _buildDefaultAvatar(),
              ),
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),

          Center(
            child: TextButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(AppLocalizations.of(context).changePicture),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final l10n = AppLocalizations.of(context);
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                AppLocalizations.of(context).basicInformation,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Email (non-editable)
          _buildReadOnlyField(
            AppLocalizations.of(context).emailAddress,
            _currentProfile?.email ?? AppLocalizations.of(context).noEmail,
            Icons.email_outlined,
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Name fields
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: _firstNameController,
                  label: AppLocalizations.of(context).firstName,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.firstNameRequired;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildFormField(
                  controller: _lastNameController,
                  label: AppLocalizations.of(context).lastName,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return l10n.lastNameRequired;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Phone number
          _buildFormField(
            controller: _phoneController,
            label: AppLocalizations.of(context).phoneNumber,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return l10n.phoneRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Date of birth
          _buildFormField(
            controller: _dateOfBirthController,
            label: AppLocalizations.of(context).dateOfBirth,
            icon: Icons.calendar_today_outlined,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Gender
          _buildDropdownField(
            label: AppLocalizations.of(context).gender,
            value: _selectedGender,
            items: [
              l10n.male,
              l10n.female,
              l10n.other,
              l10n.preferNotToSay,
            ],
            onChanged: (value) => setState(() => _selectedGender = value!),
            icon: Icons.wc_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                AppLocalizations.of(context).addressInformation,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Street address
          _buildFormField(
            controller: _streetController,
            label: AppLocalizations.of(context).streetAddress,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // City and State
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildFormField(
                  controller: _cityController,
                  label: AppLocalizations.of(context).city,
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildFormField(
                  controller: _stateController,
                  label: AppLocalizations.of(context).state,
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // ZIP code
          _buildFormField(
            controller: _zipCodeController,
            label: AppLocalizations.of(context).zipCode,
            icon: Icons.markunread_mailbox_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
    final l10n = AppLocalizations.of(context);
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(
                Icons.emergency_outlined,
                color: AppColors.errorColor,
                size: 24,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                AppLocalizations.of(context).emergencyContact,
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          Container(
            padding: const EdgeInsets.all(AppDesign.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.errorColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              border: Border.all(
                color: AppColors.errorColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.contacts_rounded,
                  color: AppColors.errorColor,
                  size: 20,
                ),
                const SizedBox(width: AppDesign.spaceMD),
                Expanded(
                  child: Text(
                    l10n.manageSosContacts,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showSosContactsDialog(context);
                    await _loadLatestSosContact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                    ),
                  ),
                  child: Text(l10n.manage),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Emergency contact name
          _buildFormField(
            controller: _emergencyNameController,
            label: AppLocalizations.of(context).contactName,
            icon: Icons.person_pin_outlined,
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Emergency contact phone number
          _buildFormField(
            controller: _emergencyPhoneController,
            label: l10n.phoneNumber,
            icon: Icons.phone_in_talk_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    final th = ThemeHelper.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: th.subtleBackground,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: th.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: th.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: th.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: th.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.lock_outlined,
            color: AppColors.greyMedium,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        filled: true,
        fillColor: ThemeHelper.of(context).cardBackground,
        contentPadding: const EdgeInsets.all(AppDesign.spaceMD),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: ThemeHelper.of(context).cardBackground,
        contentPadding: const EdgeInsets.all(AppDesign.spaceMD),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: AppTextStyles.bodyMedium),
        );
      }).toList(),
    );
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
            AppLocalizations.of(context).errorSelectingImage(e.toString()));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Parse date of birth
      DateTime? dateOfBirth;
      if (_dateOfBirthController.text.isNotEmpty) {
        try {
          final parts = _dateOfBirthController.text.split('/');
          if (parts.length == 3) {
            dateOfBirth = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } catch (e) {
          // Keep existing date if parsing fails
          dateOfBirth = _currentProfile?.dateOfBirth;
        }
      }

      // Map display gender value back to actual value
      final genderValue = _mapDisplayValueToGender(
          _selectedGender, AppLocalizations.of(context));

      // Create updated address
      final updatedAddress = PassengerAddress(
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _zipCodeController.text.trim(),
        country: 'Sri Lanka', // Default to Sri Lanka (no country input)
        latitude: _currentProfile?.address?.latitude,
        longitude: _currentProfile?.address?.longitude,
      );

      // Create updated preferences
      final updatedPreferences = PassengerPreferences(
        language: _mapDisplayNameToLanguageCode(_preferredLanguage),
        theme: _currentProfile?.preferences.theme ?? 'system',
        notifications: PassengerNotificationSettings(
          safetyAlerts:
              _currentProfile?.preferences.notifications.safetyAlerts ?? true,
          journeyUpdates: _notificationsEnabled,
          emergencyAlerts:
              _currentProfile?.preferences.notifications.emergencyAlerts ??
                  true,
          systemAnnouncements:
              _currentProfile?.preferences.notifications.systemAnnouncements ??
                  true,
        ),
        privacy: PassengerPrivacySettings(
          shareLocation: _locationSharingEnabled,
          shareJourneyData:
              _currentProfile?.preferences.privacy.shareJourneyData ?? true,
        ),
      );

      // Create updated emergency contact
      final updatedEmergencyContact = PassengerEmergencyContact(
        name: _emergencyNameController.text.trim(),
        phoneNumber: _emergencyPhoneController.text.trim(),
        relationship: _emergencyRelationController.text.trim(),
      );

      // Create updated profile
      final updatedProfile = _currentProfile!.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: dateOfBirth,
        gender: genderValue,
        address: updatedAddress,
        preferences: updatedPreferences,
        emergencyContact: updatedEmergencyContact,
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await PassengerService.instance.updatePassengerProfile(
        userId: user.uid,
        passenger: updatedProfile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccessfully),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
          ),
        );

        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
            AppLocalizations.of(context).errorSavingProfile(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusXL),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorColor,
              size: 28,
            ),
            const SizedBox(width: AppDesign.spaceMD),
            Text(AppLocalizations.of(context).error),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  // Helper method to map language codes to display names
  String _mapLanguageCodeToDisplayName(String languageCode) {
    final l10n = AppLocalizations.of(context);
    switch (languageCode.toLowerCase()) {
      case 'en':
        return l10n.english;
      case 'si':
        return l10n.sinhala;
      case 'ta':
        return l10n.tamil;
      default:
        return l10n.english; // Default fallback
    }
  }

  // Helper method to map display names back to language codes
  String _mapDisplayNameToLanguageCode(String displayName) {
    final l10n = AppLocalizations.of(context);
    if (displayName == l10n.english) return 'en';
    if (displayName == l10n.sinhala) return 'si';
    if (displayName == l10n.tamil) return 'ta';
    return 'en'; // Default fallback
  }

  // Helper method to map gender from model to display value
  String _mapGenderToDisplayValue(String? gender) {
    final l10n = AppLocalizations.of(context);
    if (gender == null || gender.isEmpty) return l10n.preferNotToSay;

    switch (gender.toLowerCase()) {
      case 'male':
      case 'm':
        return l10n.male;
      case 'female':
      case 'f':
        return l10n.female;
      case 'other':
      case 'o':
        return l10n.other;
      default:
        return l10n.preferNotToSay;
    }
  }

  // Helper method to map display value back to gender code
  String? _mapDisplayValueToGender(String displayValue, AppLocalizations l10n) {
    if (displayValue == l10n.male) {
      return 'Male';
    } else if (displayValue == l10n.female) {
      return 'Female';
    } else if (displayValue == l10n.other) {
      return 'Other';
    } else if (displayValue == l10n.preferNotToSay) {
      return null;
    }
    return null;
  }
}
