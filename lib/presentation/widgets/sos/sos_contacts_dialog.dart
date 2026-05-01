import 'package:flutter/material.dart';
import 'package:safedriver_passenger_app/core/constants/color_constants.dart';
import 'package:safedriver_passenger_app/core/constants/design_constants.dart';
import 'package:safedriver_passenger_app/core/services/sos_service.dart';

Future<void> showSosContactsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const SosContactsDialog(),
  );
}

class SosContactsDialog extends StatefulWidget {
  const SosContactsDialog({super.key});

  @override
  State<SosContactsDialog> createState() => _SosContactsDialogState();
}

class _SosContactsDialogState extends State<SosContactsDialog> {
  final SosService _sosService = SosService();
  bool _isLoading = true;
  bool _autoSendEnabled = true;
  List<SosContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await _sosService.getContacts();
    final autoSend = await _sosService.isAutoSendEnabled();
    if (!mounted) return;
    setState(() {
      _contacts = contacts;
      _autoSendEnabled = autoSend;
      _isLoading = false;
    });
  }

  Future<void> _toggleAutoSend(bool value) async {
    await _sosService.setAutoSendEnabled(value);
    if (!mounted) return;
    setState(() => _autoSendEnabled = value);
  }

  void _showAddEditDialog({SosContact? contact}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController =
        TextEditingController(text: contact?.phoneNumber ?? '');
    final relationshipController =
        TextEditingController(text: contact?.relationship ?? '');
    bool sendSms = contact?.sendSms ?? true;
    bool sendWhatsapp = contact?.sendWhatsapp ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusLG),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDesign.spaceSM),
                decoration: BoxDecoration(
                  color: (contact == null
                          ? AppColors.dangerColor
                          : AppColors.primaryColor)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
                child: Icon(
                  contact == null
                      ? Icons.person_add_rounded
                      : Icons.edit_rounded,
                  color: contact == null
                      ? AppColors.dangerColor
                      : AppColors.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppDesign.spaceMD),
              Text(
                contact == null ? 'Add SOS Contact' : 'Edit SOS Contact',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
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

                final updated = SosContact(
                  id: contact?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                  sendSms: sendSms,
                  sendWhatsapp: sendWhatsapp,
                );

                if (contact == null) {
                  await _sosService.addContact(updated);
                } else {
                  await _sosService.updateContact(updated);
                }

                if (mounted) Navigator.pop(context);
                _loadContacts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    contact == null ? AppColors.dangerColor : AppColors.primaryColor,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDesign.radiusLG),
                ),
              ),
              child: Text(contact == null ? 'Add Contact' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(SosContact contact) {
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
          'Remove ${contact.name} from SOS contacts?',
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
              if (mounted) Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      title: Row(
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
            'SOS Contacts',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: _isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spaceLG),
                  child: CircularProgressIndicator(
                    color: AppColors.dangerColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      value: _autoSendEnabled,
                      onChanged: _toggleAutoSend,
                      title: const Text(
                        'Auto-send SOS alerts',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Send alerts to all contacts instantly',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      activeColor: AppColors.dangerColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppDesign.spaceMD),
                    if (_contacts.isEmpty)
                      _buildEmptyState()
                    else
                      Column(
                        children: _contacts
                            .map((contact) => _buildContactTile(contact))
                            .toList(),
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddEditDialog(),
          icon: const Icon(Icons.person_add_rounded),
          label: const Text('Add Contact'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dangerColor,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactTile(SosContact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesign.spaceMD),
      padding: const EdgeInsets.all(AppDesign.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.greyExtraLight,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.dangerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDesign.radiusLG),
            ),
            child: Center(
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.dangerColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDesign.spaceXS),
                Text(
                  contact.phoneNumber,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                if (contact.relationship.isNotEmpty) ...[
                  const SizedBox(height: AppDesign.spaceXS),
                  Text(
                    contact.relationship,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: AppDesign.spaceXS),
                Wrap(
                  spacing: AppDesign.spaceSM,
                  runSpacing: AppDesign.spaceXS,
                  children: [
                    _buildMethodBadge(
                      icon: Icons.sms_rounded,
                      label: 'SMS',
                      enabled: contact.sendSms,
                      activeColor: AppColors.primaryColor,
                    ),
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
          ),
          IconButton(
            onPressed: () => _showAddEditDialog(contact: contact),
            icon: const Icon(Icons.edit_rounded,
                color: AppColors.primaryColor, size: 20),
          ),
          IconButton(
            onPressed: () => _confirmDelete(contact),
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.dangerColor, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceLG),
      decoration: BoxDecoration(
        color: AppColors.greyExtraLight,
        borderRadius: BorderRadius.circular(AppDesign.radiusLG),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: const Column(
        children: [
          Icon(Icons.contacts_rounded, color: AppColors.dangerColor, size: 32),
          SizedBox(height: AppDesign.spaceSM),
          Text(
            'No SOS contacts yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDesign.spaceXS),
          Text(
            'Add trusted contacts to receive your alerts',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
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
          color: enabled
              ? activeColor.withOpacity(0.3)
              : AppColors.greyMedium.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12, color: enabled ? activeColor : AppColors.greyMedium),
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
}
