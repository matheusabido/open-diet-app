class FoodDraft {
  final String? name;
  final String? brand;
  final String? barcode;

  final double? kcal;
  final double? protein;
  final double? carbohydrate;
  final double? fat;

  final double? amount;
  final String? unit;

  FoodDraft({
    this.name,
    this.brand,
    this.barcode,
    this.kcal,
    this.protein,
    this.carbohydrate,
    this.fat,
    this.amount,
    this.unit,
  });

  factory FoodDraft.fromJson(Map<String, dynamic> json) {
    return FoodDraft(
      name: json['name'],
      brand: json['brand'],
      barcode: json['barcode'],
      kcal: (json['kcal'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbohydrate: (json['carbohydrate'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'],
    );
  }
}
