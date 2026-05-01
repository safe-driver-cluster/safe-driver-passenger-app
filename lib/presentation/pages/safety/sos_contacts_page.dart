import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/core/services/sos_service.dart';
import 'package:safedriver_passenger_app/presentation/widgets/common/custom_back_button.dart';

class SosContactsPage extends StatefulWidget {
  const SosContactsPage({super.key});

  @override
  State<SosContactsPage> createState() => _SosContactsPageState();
}

class _SosContactsPageState extends State<SosContactsPage> {
  final SosService _sosService = SosService();
  List<SosContact> _contacts = [];
  bool _isLoading = true;
  bool _autoSendEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await _sosService.getContacts();
    final autoSend = await _sosService.isAutoSendEnabled();
    setState(() {
      _contacts = contacts;
      _autoSendEnabled = autoSend;
      _isLoading = false;
    });
  }

  Future<void> _toggleAutoSend(bool value) async {
    await _sosService.setAutoSendEnabled(value);
    setState(() => _autoSendEnabled = value);
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationshipController = TextEditingController();
    bool sendSms = true;
    bool sendWhatsapp = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: AppColors.dangerColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Text(
                'Add SOS Contact',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogTextField(
                  controller: nameController,
                  label: 'Contact Name',
                  hint: 'e.g., Mom, Dad, Spouse',
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildDialogTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hint: 'e.g., 0771234567',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildDialogTextField(
                  controller: relationshipController,
                  label: 'Relationship',
                  hint: 'e.g., Parent, Friend',
                  icon: Icons.favorite_rounded,
                ),
                const SizedBox(height: AppDesign.spaceLG),
                const Text(
                  'Alert Methods',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                SwitchListTile(
                  value: sendSms,
                  onChanged: (v) => setDialogState(() => sendSms = v),
                  title: Row(
                    children: [
                      Icon(Icons.sms_rounded,
                          color: AppColors.primaryColor, size: 20),
                      const SizedBox(width: AppDesign.spaceSM),
                      const Text('SMS',
                          style: TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                SwitchListTile(
                  value: sendWhatsapp,
                  onChanged: (v) => setDialogState(() => sendWhatsapp = v),
                  title: Row(
                    children: [
                      Icon(Icons.chat_rounded,
                          color: AppColors.successColor, size: 20),
                      const SizedBox(width: AppDesign.spaceSM),
                      const Text('WhatsApp',
                          style: TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                  activeColor: AppColors.successColor,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in name and phone number'),
                      backgroundColor: AppColors.dangerColor,
                    ),
                  );
                  return;
                }

                final contact = SosContact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                  sendSms: sendSms,
                  sendWhatsapp: sendWhatsapp,
                );

                await _sosService.addContact(contact);
                if (context.mounted) Navigator.pop(context);
                _loadContacts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dangerColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: const Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditContactDialog(SosContact contact) {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phoneNumber);
    final relationshipController =
        TextEditingController(text: contact.relationship);
    bool sendSms = contact.sendSms;
    bool sendWhatsapp = contact.sendWhatsapp;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              const Text(
                'Edit Contact',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogTextField(
                  controller: nameController,
                  label: 'Contact Name',
                  hint: 'e.g., Mom, Dad, Spouse',
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildDialogTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hint: 'e.g., 0771234567',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppDesign.spaceMD),
                _buildDialogTextField(
                  controller: relationshipController,
                  label: 'Relationship',
                  hint: 'e.g., Parent, Friend',
                  icon: Icons.favorite_rounded,
                ),
                const SizedBox(height: AppDesign.spaceLG),
                const Text(
                  'Alert Methods',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceSM),
                SwitchListTile(
                  value: sendSms,
                  onChanged: (v) => setDialogState(() => sendSms = v),
                  title: Row(
                    children: [
                      Icon(Icons.sms_rounded,
                          color: AppColors.primaryColor, size: 20),
                      const SizedBox(width: AppDesign.spaceSM),
                      const Text('SMS',
                          style: TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                  activeColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                SwitchListTile(
                  value: sendWhatsapp,
                  onChanged: (v) => setDialogState(() => sendWhatsapp = v),
                  title: Row(
                    children: [
                      Icon(Icons.chat_rounded,
                          color: AppColors.successColor, size: 20),
                      const SizedBox(width: AppDesign.spaceSM),
                      const Text('WhatsApp',
                          style: TextStyle(color: AppColors.textPrimary)),
                    ],
                  ),
                  activeColor: AppColors.successColor,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in name and phone number'),
                      backgroundColor: AppColors.dangerColor,
                    ),
                  );
                  return;
                }

                final updated = contact.copyWith(
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                  sendSms: sendSms,
                  sendWhatsapp: sendWhatsapp,
                );

                await _sosService.updateContact(updated);
                if (context.mounted) Navigator.pop(context);
                _loadContacts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteContact(SosContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: AppColors.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Text(
              'Remove Contact',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove ${contact.name} from your SOS contacts?',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              await _sosService.deleteContact(contact.id);
              if (context.mounted) Navigator.pop(context);
              _loadContacts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textHint),
        prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.greyMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: AppColors.greyExtraLight,
      ),
    );
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
              AppColors.dangerColor,
              AppColors.criticalColor,
              AppColors.scaffoldBackground,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: AppDesign.spaceLG),
                  decoration: const BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.dangerColor))
                      : _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactDialog,
        backgroundColor: AppColors.dangerColor,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Contact',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: const CustomBackButton(color: AppColors.white),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          const Text(
            'SOS Contacts',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auto-send toggle
          _buildAutoSendToggle(),
          const SizedBox(height: AppDesign.spaceLG),
          // Info card
          _buildInfoCard(),
          const SizedBox(height: AppDesign.spaceLG),
          // Contacts list
          _buildContactsList(),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildAutoSendToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowSM,
      ),
      child: SwitchListTile(
        value: _autoSendEnabled,
        onChanged: _toggleAutoSend,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: AppColors.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-Send SOS',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Automatically send alerts to all contacts',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        activeColor: AppColors.dangerColor,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceSM),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: const Icon(
              Icons.info_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          const Expanded(
            child: Text(
              'Add trusted contacts who will receive your SOS alerts via SMS and WhatsApp with your live location.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    if (_contacts.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDesign.spaceSM),
              decoration: BoxDecoration(
                color: AppColors.dangerColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
              child: const Icon(
                Icons.contacts_rounded,
                color: AppColors.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDesign.spaceMD),
            const Text(
              'My SOS Contacts',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${_contacts.length} contact${_contacts.length != 1 ? 's' : ''}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDesign.spaceLG),
        ..._contacts.map((contact) => _buildContactCard(contact)),
      ],
    );
  }

  Widget _buildContactCard(SosContact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowSM,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDesign.spaceMD),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.dangerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          child: Center(
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.dangerColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDesign.spaceXS),
            Text(
              contact.phoneNumber,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (contact.relationship.isNotEmpty) ...[
              const SizedBox(height: AppDesign.spaceXS),
              Text(
                contact.relationship,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: AppDesign.spaceSM),
            Row(
              children: [
                _buildMethodBadge(
                  icon: Icons.sms_rounded,
                  label: 'SMS',
                  enabled: contact.sendSms,
                  activeColor: AppColors.primaryColor,
                ),
                const SizedBox(width: AppDesign.spaceSM),
                _buildMethodBadge(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  enabled: contact.sendWhatsapp,
                  activeColor: AppColors.successColor,
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _showEditContactDialog(contact),
              icon: const Icon(Icons.edit_rounded,
                  color: AppColors.primaryColor, size: 20),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
            IconButton(
              onPressed: () => _confirmDeleteContact(contact),
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.dangerColor, size: 20),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodBadge({
    required IconData icon,
    required String label,
    required bool enabled,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceSM,
        vertical: AppDesign.spaceXS,
      ),
      decoration: BoxDecoration(
        color: enabled ? activeColor.withOpacity(0.1) : AppColors.greyLight,
        borderRadius: BorderRadius.circular(AppDesign.radiusSM),
        border: Border.all(
          color: enabled ? activeColor.withOpacity(0.3) : AppColors.greyMedium.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14, color: enabled ? activeColor : AppColors.greyMedium),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: enabled ? activeColor : AppColors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.space3XL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        boxShadow: AppDesign.shadowSM,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDesign.spaceXL),
            decoration: BoxDecoration(
              color: AppColors.dangerColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.contacts_rounded,
              color: AppColors.dangerColor,
              size: 48,
            ),
          ),
          const SizedBox(height: AppDesign.spaceXL),
          const Text(
            'No SOS Contacts Yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceMD),
          const Text(
            'Add trusted contacts who will receive your emergency alerts with your live location.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDesign.spaceXL),
          ElevatedButton.icon(
            onPressed: _showAddContactDialog,
            icon: const Icon(Icons.person_add_rounded),
            label: const Text('Add Your First Contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerColor,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesign.spaceXL,
                vertical: AppDesign.spaceMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDesign.radiusLG),
              ),
            ),
          ),
        ],
      ),
    );
  }
}