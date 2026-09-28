import 'package:flutter/material.dart';

enum ToastType { success, error }

void showToast(
  BuildContext context,
  String message, {
  ToastType type = ToastType.success,
}) {
  final isSuccess = type == ToastType.success;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
