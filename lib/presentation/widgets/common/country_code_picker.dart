import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryCodePicker extends StatelessWidget {
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;

  const CountryCodePicker({
    super.key,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  static const List<Map<String, String>> countries = [
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCountryCode,
          isExpanded: false,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onCountryCodeChanged(newValue);
            }
          },
          items: countries.map<DropdownMenuItem<String>>((country) {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    country['flag']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    country['code']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;
  final String? Function(String?)? validator;
  final String labelText;
  final bool enabled;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    this.validator,
    this.labelText = 'Phone Number',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Country Code Picker
        CountryCodePicker(
          selectedCountryCode: selectedCountryCode,
          onCountryCodeChanged: onCountryCodeChanged,
        ),
        const SizedBox(width: 12),
        // Phone Number Field
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.phone,
              enabled: enabled,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: labelText,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.grey[600],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}
