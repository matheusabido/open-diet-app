import 'package:open_diet/utils/units.dart';

class Food {
  final int id;
  final String name;
  final String? brand;

  final double kcal;
  final double protein;
  final double carbohydrate;
  final double fat;

  final double amount;
  final String unit;

  Food({
    required this.id,
    required this.name,
    this.brand,
    required this.kcal,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.amount,
    required this.unit,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      kcal: (json['kcal'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'],
    );
  }

  double portion(double amount, String unit) {
    return convertUnit(amount, unit, this.unit) / this.amount;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'kcal': kcal,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'amount': amount,
      'unit': unit,
    };
  }
}
