import 'package:open_diet/models/food.dart';

const mealNames = {
  'breakfast': 'Café da Manhã',
  'lunch': 'Almoço',
  'dinner': 'Jantar',
  'snacks': 'Lanches',
};

typedef FoodItemDraft = ({Food food, String meal, double amount, String unit});

class FoodItem {
  final int id;
  final Food food;

  final String date;
  final String meal;
  final double amount;
  final String unit;

  bool get isPending => id < 0;

  FoodItem({
    required this.id,
    required this.food,
    required this.date,
    required this.meal,
    required this.amount,
    required this.unit,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      food: Food.fromJson(json['food']),
      date: json['date'],
      meal: json['meal'],
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'date': date,
      'meal': meal,
      'amount': amount,
      'unit': unit,
    };
  }

  double get _portion => food.portion(amount, unit);

  double get kcal => food.kcal * _portion;
  double get protein => food.protein * _portion;
  double get carbohydrate => food.carbohydrate * _portion;
  double get fat => food.fat * _portion;
}
