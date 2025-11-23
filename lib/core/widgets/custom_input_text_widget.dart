import 'package:flutter/material.dart';

class CustomInputTextWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isSearch;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool isFormField;

  const CustomInputTextWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isSearch = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.validator,
    this.isFormField = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon)
          : isSearch
              ? const Icon(Icons.search)
              : null,
      suffixIcon: suffixIcon != null
          ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon),
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    if (isFormField || validator != null) {
      return TextFormField(
        controller: controller,
        decoration: inputDecoration,
        validator: validator,
        onChanged: onChanged,
      );
    }

    return TextField(
      controller: controller,
      decoration: inputDecoration,
      onChanged: onChanged,
    );
  }
}
