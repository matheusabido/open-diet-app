import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class UnitSelect extends StatelessWidget {
  const UnitSelect({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  static const _units = ['g', 'kg', 'mg', 'oz', 'lb', 'ml', 'L', 'dL'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.container,
        border: Border.all(color: AppColors.container2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.container2,
          style: TextStyle(color: Colors.grey.shade200),
          items: _units
              .map((u) => DropdownMenuItem(value: u, child: Text(u)))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
