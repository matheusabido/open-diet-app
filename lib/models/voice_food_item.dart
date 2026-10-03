import 'package:open_diet/models/food.dart';

class VoiceFoodItem {
  final int aliasId;
  final Food? food;

  final double amount;
  final String unit;

  VoiceFoodItem({
    required this.aliasId,
    this.food,
    required this.amount,
    required this.unit,
  });

  factory VoiceFoodItem.fromJson(Map<String, dynamic> json) {
    return VoiceFoodItem(
      aliasId: json['alias_id'],
      food: json['food'] == null ? null : Food.fromJson(json['food']),
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'],
    );
  }
}
