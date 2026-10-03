import 'package:flutter/material.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/models/voice_food_item.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/utils/requests.dart';

const _fieldLabels = {
  'food_id': 'Alimento',
  'date': 'Data',
  'meal': 'Refeição',
  'amount': 'Quantidade',
  'unit': 'Unidade',
  'audio': 'Áudio',
};

Future<void> addFoodItem(BuildContext context, FoodItemDraft draft) {
  return runRequest(
    context,
    () => Api.instance.addFoodItem(draft),
    fieldLabels: _fieldLabels,
  );
}

Future<void> updateFoodItem(
  BuildContext context,
  FoodItem item,
  FoodItemDraft draft,
) {
  return runRequest(
    context,
    () => Api.instance.updateFoodItem(item, draft),
    fieldLabels: _fieldLabels,
  );
}

Future<void> removeFoodItem(BuildContext context, FoodItem item) {
  return runRequest(
    context,
    () => Api.instance.removeFoodItem(item),
    fieldLabels: _fieldLabels,
  );
}

Future<VoiceFoodItem?> voiceFoodItem(BuildContext context, String audioPath) {
  return runRequest(
    context,
    () => Api.instance.voiceFoodItem(audioPath),
    fieldLabels: _fieldLabels,
  );
}

Future<bool> linkFoodAlias(BuildContext context, int aliasId, Food food) async {
  final linked = await runRequest(context, () async {
    await Api.instance.linkFoodAlias(aliasId, food);
    return true;
  }, fieldLabels: _fieldLabels);
  return linked ?? false;
}
