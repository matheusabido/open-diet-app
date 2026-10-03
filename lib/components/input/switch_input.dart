import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class SwitchInput extends StatelessWidget {
  const SwitchInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: Colors.grey.shade200)),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.grey.shade200,
          activeTrackColor: Colors.blue.shade800,
          inactiveThumbColor: AppColors.textSecondary,
          inactiveTrackColor: AppColors.container,
          trackOutlineColor: WidgetStatePropertyAll(AppColors.container2),
        ),
      ],
    );
  }
}
