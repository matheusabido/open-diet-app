import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class VoiceLinkBanner extends StatelessWidget {
  const VoiceLinkBanner({
    super.key,
    required this.name,
    required this.onCancel,
  });

  final String name;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.container,
        border: Border.all(color: AppColors.container2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        spacing: 12,
        children: [
          Icon(Icons.link, color: Colors.blue.shade300),
          Expanded(
            child: Text(
              'Escolha o alimento para vincular a "$name"',
              style: TextStyle(color: Colors.grey.shade200),
            ),
          ),
          TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade400),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
