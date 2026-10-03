import 'package:flutter/material.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/toast.dart';

/// Runs a request and shows its error, if any, in a toast. Returns null when
/// the request fails.
Future<T?> runRequest<T>(
  BuildContext context,
  Future<T> Function() action, {
  Map<String, String> fieldLabels = const {},
}) async {
  T? result;
  String? error;
  try {
    result = await action();
  } on ApiException catch (e) {
    error = e.message ?? formatErrors(e.errors, fieldLabels);
  } catch (_) {
    error = 'Não foi possível conectar ao servidor';
  }

  if (error != null && context.mounted) {
    showToast(context, error, type: ToastType.error);
  }

  return result;
}
