import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';

class NutrientRow extends StatelessWidget {
  const NutrientRow({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.color,
  });

  final String label;
  final double value;
  final String unit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color;

    return Container(
      padding: .symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.container2,
        borderRadius: .circular(8),
      ),
      child: Row(
        spacing: 8,
        children: [
          if (color != null)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: .circle),
            ),
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.white70)),
          ),
          Text(
            '${formatRounded(value)} $unit',
            style: TextStyle(color: Colors.white, fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}
