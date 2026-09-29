import 'package:flutter/material.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/utils/errors.dart';
import 'package:open_diet/utils/toast.dart';

const _fieldLabels = {
  'food_id': 'Alimento',
  'date': 'Data',
  'meal': 'Refeição',
  'amount': 'Quantidade',
  'unit': 'Unidade',
};

Future<void> addFoodItem(BuildContext context, FoodItemDraft draft) {
  return _run(context, () => Api.instance.addFoodItem(draft));
}

Future<void> updateFoodItem(
  BuildContext context,
  FoodItem item,
  FoodItemDraft draft,
) {
  return _run(context, () => Api.instance.updateFoodItem(item, draft));
}

Future<void> _run(BuildContext context, Future<void> Function() action) async {
  String? error;
  try {
    await action();
  } on ApiException catch (e) {
    error = e.message ?? formatErrors(e.errors, _fieldLabels);
  } catch (_) {
    error = 'Não foi possível conectar ao servidor';
  }

  if (error != null && context.mounted) {
    showToast(context, error, type: ToastType.error);
  }
}
