import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/color_constants.dart';
import '../../../data/services/sms_gateway_service.dart';
import 'country_code_selector.dart';

class PhoneInputWidget extends StatefulWidget {
  final TextEditingController phoneController;
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onCountryChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final String? hintText;
  final String? labelText;
  final bool autofocus;

  const PhoneInputWidget({
    super.key,
    required this.phoneController,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.autofocus = false,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final _smsGateway = SmsGatewayService();

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // For Sri Lankan numbers, use existing validation
    if (widget.selectedCountry.code == 'LK') {
      final fullNumber = widget.selectedCountry.dialCode + value;
      final formatted = _smsGateway.formatSriLankanPhoneNumber(fullNumber);
      if (!_smsGateway.isValidSriLankanPhoneNumber(formatted)) {
        return 'Please enter a valid Sri Lankan phone number';
      }
    } else {
      // Basic validation for other countries
      final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanNumber.length < 7 || cleanNumber.length > 15) {
        return 'Please enter a valid phone number';
      }
    }

    return null;
  }

  String _getHintText() {
    if (widget.hintText != null) return widget.hintText!;

    switch (widget.selectedCountry.code) {
      case 'LK':
        return '77 123 4567';
      case 'IN':
        return '98765 43210';
      case 'US':
      case 'CA':
        return '555 123 4567';
      case 'GB':
        return '7911 123456';
      case 'AU':
        return '412 345 678';
      default:
        return 'Enter phone number';
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    final formatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
    ];

    switch (widget.selectedCountry.code) {
      case 'LK':
        formatters.add(LengthLimitingTextInputFormatter(9));
        break;
      case 'IN':
        formatters.add(LengthLimitingTextInputFormatter(10));
        break;
      case 'US':
      case 'CA':
        formatters.add(LengthLimitingTextInputFormatter(10));
        break;
      case 'GB':
        formatters.add(LengthLimitingTextInputFormatter(11));
        break;
      case 'AU':
        formatters.add(LengthLimitingTextInputFormatter(9));
        break;
      default:
        formatters.add(LengthLimitingTextInputFormatter(15));
    }

    return formatters;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Selector
            CountryCodeSelector(
              selectedCountry: widget.selectedCountry,
              onCountryChanged: widget.onCountryChanged,
              enabled: widget.enabled,
            ),

            const SizedBox(width: 12),

            // Phone Number Input
            Expanded(
              child: TextFormField(
                controller: widget.phoneController,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                keyboardType: TextInputType.phone,
                inputFormatters: _getInputFormatters(),
                validator: widget.validator ?? _defaultValidator,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: _getHintText(),
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.errorColor,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.errorColor,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey[200]!,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: !widget.enabled,
                  fillColor: widget.enabled ? null : Colors.grey[50],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getFullPhoneNumber() {
    return widget.selectedCountry.dialCode + widget.phoneController.text.trim();
  }
}
