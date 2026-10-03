import 'package:flutter/material.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/components/secondary_button.dart';
import 'package:open_diet/models/voice_food_item.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';

enum VoiceLinkAction { link, recordAgain }

class VoiceLinkPage extends StatelessWidget {
  const VoiceLinkPage({super.key, required this.voice});

  final VoiceFoodItem voice;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(color: AppColors.textSecondary);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Vincular alimento'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(
        child: ListView(
          padding: .all(16),
          children: [
            Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                Text('Você disse', style: labelStyle),
                Text(
                  voice.name,
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 24,
                    fontWeight: .bold,
                  ),
                ),
                Text(
                  '${formatAmount(voice.amount)} ${voice.unit}',
                  style: labelStyle,
                ),
                SizedBox(height: 4),
                Text(
                  'Esse nome ainda não está vinculado a nenhum alimento. '
                  'Vincule uma vez e, nas próximas, ele já abre o alimento '
                  'escolhido.',
                  style: labelStyle,
                ),
                SizedBox(height: 4),
                PrimaryButton(
                  label: 'Vincular',
                  onPressed: () =>
                      Navigator.of(context).pop(VoiceLinkAction.link),
                ),
                SecondaryButton(
                  label: 'Gravar novamente',
                  icon: Icons.mic,
                  onPressed: () =>
                      Navigator.of(context).pop(VoiceLinkAction.recordAgain),
                ),
                SecondaryButton(
                  label: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
