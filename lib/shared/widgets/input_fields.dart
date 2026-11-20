import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class AmountInputField extends StatelessWidget {
  const AmountInputField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.validator,
    this.hint = '0.00',
    this.currency = 'USD',
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final String hint;
  final String currency;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: label,
      controller: controller,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,9}(\.\d{0,2})?$')),
      ],
      prefixIcon: Icons.attach_money_rounded,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 16, top: 14),
        child: Text(currency, style: AppTextStyles.labelSmall),
      ),
    );
  }
}

class NexSearchBar extends StatelessWidget {
  const NexSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Search…',
    this.onChanged,
    this.onFilter,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (onFilter != null) ...<Widget>[
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: onFilter,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Icon(Icons.tune_rounded, size: 20),
            ),
          ),
        ],
      ],
    );
  }
}
