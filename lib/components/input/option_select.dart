import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class OptionSelect extends StatelessWidget {
  const OptionSelect({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;

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
          isExpanded: true,
          dropdownColor: AppColors.container2,
          style: TextStyle(color: Colors.grey.shade200),
          items: options.entries
              .map((o) => DropdownMenuItem(value: o.key, child: Text(o.value)))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
