import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.container,
          disabledBackgroundColor: AppColors.container,
          foregroundColor: Colors.grey.shade200,
          padding: .all(8),
          side: BorderSide(color: AppColors.container2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade200,
                ),
              )
            : Column(
                mainAxisAlignment: .center,
                spacing: 8,
                children: [
                  Icon(icon, size: 32, color: Colors.blue.shade300),
                  Text(label, textAlign: .center),
                ],
              ),
      ),
    );
  }
}
