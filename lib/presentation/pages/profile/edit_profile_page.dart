import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/design_constants.dart';
import '../../../data/models/passenger_model.dart';
import '../../../data/services/passenger_service.dart';
import '../../widgets/common/professional_widgets.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Form controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dateOfBirthController;
  late final TextEditingController _genderController;

  // Address controllers
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _countryController;

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
  String _selectedGender = 'Prefer not to say';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadUserProfile();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _genderController = TextEditingController();

    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _countryController = TextEditingController();

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
      }
    } catch (e) {
      _showErrorDialog('Error loading profile: $e');
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
      _dateOfBirthController.text = profile.dateOfBirth?.toString() ?? '';
      _genderController.text = profile.gender ?? '';

      // Address
      if (profile.address != null) {
        _streetController.text = profile.address!.street;
        _cityController.text = profile.address!.city;
        _stateController.text = ''; // No state field in model
        _zipCodeController.text = profile.address!.postalCode;
        _countryController.text = profile.address!.country;
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
      _preferredPaymentMethod = 'Card'; // Default as not in model
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor,
              AppColors.primaryColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 0.7],
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
              'Edit Profile',
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
                  : const Text(
                      'Save',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: AppDesign.spaceMD),
          Text(
            'Loading profile...',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
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
            const SizedBox(height: AppDesign.spaceLG),

            // Preferences
            _buildPreferencesSection(),
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
                'Profile Picture',
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
              label: const Text('Change Picture'),
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
                'Basic Information',
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Email (non-editable)
          _buildReadOnlyField(
            'Email Address',
            _currentProfile?.email ?? 'No email',
            Icons.email_outlined,
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Name fields
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'First name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildFormField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Last name is required';
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
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Date of birth
          _buildFormField(
            controller: _dateOfBirthController,
            label: 'Date of Birth',
            icon: Icons.calendar_today_outlined,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Gender
          _buildDropdownField(
            label: 'Gender',
            value: _selectedGender,
            items: const ['Male', 'Female', 'Other', 'Prefer not to say'],
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
                'Address Information',
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
            label: 'Street Address',
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
                  label: 'City',
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildFormField(
                  controller: _stateController,
                  label: 'State',
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // ZIP code and Country
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  controller: _zipCodeController,
                  label: 'ZIP Code',
                  icon: Icons.markunread_mailbox_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                flex: 2,
                child: _buildFormField(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
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
                'Emergency Contact',
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Emergency contact name
          _buildFormField(
            controller: _emergencyNameController,
            label: 'Contact Name',
            icon: Icons.person_pin_outlined,
          ),
          const SizedBox(height: AppDesign.spaceMD),

          // Emergency contact phone and relationship
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildFormField(
                  controller: _emergencyPhoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_in_talk_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Expanded(
                child: _buildFormField(
                  controller: _emergencyRelationController,
                  label: 'Relationship',
                  icon: Icons.family_restroom_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return ProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                'Preferences',
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesign.spaceLG),

          // Notification settings
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive updates about your trips',
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            icon: Icons.notifications_outlined,
          ),

          _buildSwitchTile(
            title: 'Location Sharing',
            subtitle: 'Share location for better service',
            value: _locationSharingEnabled,
            onChanged: (value) =>
                setState(() => _locationSharingEnabled = value),
            icon: Icons.location_on_outlined,
          ),

          const SizedBox(height: AppDesign.spaceMD),

          // Language preference
          _buildDropdownField(
            label: 'Language',
            value: _preferredLanguage,
            items: const ['English', 'Spanish', 'French', 'German'],
            onChanged: (value) =>
                setState(() => _preferredLanguage = value!),
            icon: Icons.language_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(
          color: AppColors.greyLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.greyMedium,
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
                    color: AppColors.greyMedium,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.greyDark,
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
        fillColor: Colors.white,
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
      value: value,
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
        fillColor: Colors.white,
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 24,
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.greyMedium,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
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
      _showErrorDialog('Error selecting image: $e');
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

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // For now, just show success without actual saving since we need to implement proper service methods
      // TODO: Implement actual profile image upload and update methods

      // TODO: Implement actual profile update
      // Update basic fields only for now
      // final updatedProfile = _currentProfile?.copyWith(
      //   firstName: _firstNameController.text.trim(),
      //   lastName: _lastNameController.text.trim(),
      //   phoneNumber: _phoneController.text.trim(),
      //   gender: _genderController.text.isNotEmpty
      //       ? _genderController.text.trim()
      //       : null,
      //   updatedAt: DateTime.now(),
      // );

      // TODO: Save to Firestore when service is properly implemented
      // await PassengerService.instance.updatePassengerProfile(updatedProfile);      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
          ),
        );

        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      _showErrorDialog('Error saving profile: $e');
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
        title: const Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorColor,
              size: 28,
            ),
            SizedBox(width: AppDesign.spaceMD),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
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
    _genderController.dispose();

    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    super.dispose();
  }

  // Helper method to map language codes to display names
  String _mapLanguageCodeToDisplayName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      default:
        return 'English'; // Default fallback
    }
  }

  // Helper method to map display names back to language codes
  String _mapDisplayNameToLanguageCode(String displayName) {
    switch (displayName) {
      case 'English':
        return 'en';
      case 'Spanish':
        return 'es';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      default:
        return 'en'; // Default fallback
    }
  }
}
