import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class RecordingIndicator extends StatelessWidget {
  const RecordingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16),
      decoration: BoxDecoration(
        color: AppColors.container,
        border: Border.all(color: Colors.red.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(Icons.fiber_manual_record, color: Colors.red.shade400),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: 4,
              children: [
                Text(
                  'Gravando...',
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontWeight: .w500,
                  ),
                ),
                Text(
                  'Diga a quantidade, a unidade e o alimento. '
                  'Ex: "100 gramas de frango"',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
