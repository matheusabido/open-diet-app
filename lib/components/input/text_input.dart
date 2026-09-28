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
  });

  final TextEditingController? controller;
  final String? label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

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

        contentPadding: .all(8),

        filled: true,
        fillColor: AppColors.container,

        labelStyle: TextStyle(color: Colors.grey.shade500),
        floatingLabelStyle: TextStyle(color: AppColors.textSecondary),
      ),
      style: TextStyle(color: Colors.grey.shade200),
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
