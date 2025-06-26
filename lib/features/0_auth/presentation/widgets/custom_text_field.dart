// File: lib/features/0_auth/presentation/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? prefixText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
