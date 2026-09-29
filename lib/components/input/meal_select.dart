import 'package:flutter/material.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/theme/colors.dart';

class MealSelect extends StatelessWidget {
  const MealSelect({super.key, required this.value, required this.onChanged});

  final String value;
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
          items: mealNames.entries
              .map((m) => DropdownMenuItem(value: m.key, child: Text(m.value)))
              .toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ),
    );
  }
}
