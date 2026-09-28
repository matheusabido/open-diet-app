import 'package:flutter/material.dart';
import 'package:open_diet/components/input/text_input.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({
    super.key,
    this.controller,
    this.label,
    this.decimal = true,
  });

  final TextEditingController? controller;
  final String? label;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      label: label,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    );
  }
}
