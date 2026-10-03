import 'package:flutter/material.dart';
import 'package:open_diet/components/input/number_input.dart';

class BarcodeInput extends StatelessWidget {
  const BarcodeInput({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: NumberInput(
              label: 'Ou digite o código',
              controller: controller,
              decimal: false,
            ),
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            onPressed: onSubmit,
            icon: Icon(Icons.search, color: Colors.grey.shade300),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
