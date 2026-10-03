import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class VoiceLinkBanner extends StatelessWidget {
  const VoiceLinkBanner({
    super.key,
    required this.isLinking,
    required this.onLink,
    required this.onCancel,
  });

  final bool isLinking;
  final VoidCallback onLink;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16),
      decoration: BoxDecoration(
        color: AppColors.container,
        border: Border.all(color: AppColors.container2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 12,
        children: [
          Row(
            spacing: 12,
            children: [
              Icon(Icons.link_off, color: Colors.amber.shade300),
              Expanded(
                child: Text(
                  isLinking
                      ? 'Escolha na lista o alimento para vincular ao que você disse.'
                      : 'O que você disse ainda não está vinculado a nenhum alimento.',
                  style: TextStyle(color: Colors.grey.shade200),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade400,
                ),
                child: Text('Cancelar'),
              ),
              if (!isLinking)
                FilledButton.icon(
                  onPressed: onLink,
                  icon: Icon(Icons.link),
                  label: Text('Vincular'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
