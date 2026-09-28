import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.container2,
          borderRadius: .circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(8),
          child: Padding(
            padding: .symmetric(horizontal: 12, vertical: 14),
            child: Row(
              spacing: 12,
              children: [
                Icon(icon, color: Colors.white70),
                Expanded(
                  child: Text(label, style: TextStyle(color: Colors.white)),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
