import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    this.controller,
    this.hint,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.container2),
    );

    return TextField(
      decoration: InputDecoration(
        hintText: hint,

        enabledBorder: border,
        focusedBorder: border,

        contentPadding: .all(8),

        filled: true,
        fillColor: AppColors.container,

        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      style: TextStyle(color: Colors.grey.shade200),
      controller: controller,
      obscureText: obscureText,
    );
  }
}
