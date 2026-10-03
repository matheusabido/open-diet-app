import 'package:flutter/material.dart';
import 'package:open_diet/utils/numbers.dart';

class NutrientTag extends StatelessWidget {
  const NutrientTag({
    super.key,
    required this.label,
    required this.grams,
    required this.color,
  });

  final String label;
  final double grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: 4,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: .circle),
        ),
        Text(
          '$label ${formatRounded(grams)}g',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
