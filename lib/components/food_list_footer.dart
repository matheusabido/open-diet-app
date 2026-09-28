import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class FoodListFooter extends StatelessWidget {
  const FoodListFooter({
    super.key,
    required this.isLoading,
    required this.isEmpty,
    required this.onRetry,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isEmpty;
  final VoidCallback onRetry;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: .all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Column(
        children: [
          Text(errorMessage!, style: TextStyle(color: Colors.red.shade300)),
          TextButton(onPressed: onRetry, child: Text('Tentar novamente')),
        ],
      );
    }

    if (isEmpty) {
      return Padding(
        padding: .all(16),
        child: Text(
          'Nenhum alimento encontrado',
          textAlign: .center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
