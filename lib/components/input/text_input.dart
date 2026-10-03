import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.controller,
    this.label,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.container2),
    );

    return TextField(
      decoration: InputDecoration(
        labelText: label,

        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,

        contentPadding: .all(8),

        filled: true,
        fillColor: AppColors.container,

        labelStyle: TextStyle(color: Colors.grey.shade500),
        floatingLabelStyle: TextStyle(color: AppColors.textSecondary),
      ),
      style: TextStyle(
        color: enabled ? Colors.grey.shade200 : Colors.grey.shade500,
      ),
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
