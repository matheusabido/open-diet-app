import 'package:flutter/material.dart';
import 'package:open_diet/components/input/text_input.dart';

class NumberInput extends StatelessWidget {
  const NumberInput({super.key, this.controller, this.hint});

  final TextEditingController? controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      hint: hint,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
