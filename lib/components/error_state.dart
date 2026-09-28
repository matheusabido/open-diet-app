import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(vertical: 24),
      child: Column(
        spacing: 12,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 40),
          Text(
            message,
            textAlign: .center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          SizedBox(
            height: 40,
            child: FilledButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Tentar novamente'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.grey.shade200,
                padding: .symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
