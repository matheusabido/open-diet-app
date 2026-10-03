import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_draft.dart';

class FoodBarcode {
  final Food? food;
  final FoodDraft? draft;

  FoodBarcode({this.food, this.draft});

  factory FoodBarcode.fromJson(Map<String, dynamic> json) {
    final food = json['food'];
    final draft = json['draft'];

    return FoodBarcode(
      food: food == null ? null : Food.fromJson(food),
      draft: draft == null ? null : FoodDraft.fromJson(draft),
    );
  }
}
