import 'package:flutter/material.dart';
import 'package:open_diet/components/input/meal_select.dart';
import 'package:open_diet/components/input/number_input.dart';
import 'package:open_diet/components/input/unit_select.dart';
import 'package:open_diet/components/nutrient_row.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/components/secondary_button.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';
import 'package:open_diet/utils/units.dart';

class FoodItemFormPage extends StatefulWidget {
  const FoodItemFormPage({
    super.key,
    required this.food,
    this.meal,
    this.item,
    this.amount,
    this.unit,
    this.onRelink,
  });

  final Food food;
  final String? meal;
  final FoodItem? item;
  final double? amount;
  final String? unit;
  final VoidCallback? onRelink;

  @override
  State<FoodItemFormPage> createState() => _FoodItemFormPageState();
}

class _FoodItemFormPageState extends State<FoodItemFormPage> {
  late final amountController = TextEditingController(
    text: formatAmount(
      widget.item?.amount ?? widget.amount ?? widget.food.amount,
    ),
  );
  late final units = compatibleUnits(widget.food.unit);

  late String meal = widget.item?.meal ?? widget.meal ?? mealNames.keys.first;
  late String unit =
      widget.item?.unit ??
      (units.contains(widget.unit) ? widget.unit! : widget.food.unit);
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    amountController.addListener(onAmountChanged);
  }

  void onAmountChanged() {
    setState(() {});
  }

  double? get amount {
    return double.tryParse(amountController.text.trim().replaceAll(',', '.'));
  }

  void submit() {
    final amount = this.amount;
    if (amount == null || amount <= 0) {
      setState(() {
        errorMessage = 'Quantidade deve ser maior que 0';
      });
      return;
    }

    final FoodItemDraft draft = (
      food: widget.food,
      meal: meal,
      amount: amount,
      unit: unit,
    );
    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final brand = food.brand;
    final isEditing = widget.item != null;
    final amount = this.amount ?? 0;
    final portion = food.portion(amount, unit);
    const labelStyle = TextStyle(color: AppColors.textSecondary);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar refeição' : 'Adicionar à refeição'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(
        child: ListView(
          padding: .all(16),
          children: [
            Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: [
                Text(
                  food.name,
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 24,
                    fontWeight: .bold,
                  ),
                ),
                if (brand != null) Text(brand, style: labelStyle),
                SizedBox(height: 4),
                Text('Refeição', style: labelStyle),
                SizedBox(
                  height: 48,
                  child: MealSelect(
                    value: meal,
                    onChanged: (value) => setState(() => meal = value),
                  ),
                ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: NumberInput(
                          label: 'Quantidade *',
                          controller: amountController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: UnitSelect(
                        value: unit,
                        units: units,
                        onChanged: (value) => setState(() => unit = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Valores nutricionais para ${formatAmount(amount)} $unit',
                  style: labelStyle,
                ),
                NutrientRow(
                  label: 'Calorias',
                  value: food.kcal * portion,
                  unit: 'kcal',
                ),
                NutrientRow(
                  label: 'Proteína',
                  value: food.protein * portion,
                  unit: 'g',
                  color: Colors.red,
                ),
                NutrientRow(
                  label: 'Carboidrato',
                  value: food.carbohydrate * portion,
                  unit: 'g',
                  color: Colors.blue,
                ),
                NutrientRow(
                  label: 'Gordura',
                  value: food.fat * portion,
                  unit: 'g',
                  color: Colors.amber,
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                SizedBox(height: 4),
                PrimaryButton(
                  label: isEditing ? 'Salvar' : 'Adicionar',
                  onPressed: submit,
                ),
                if (widget.onRelink != null)
                  SecondaryButton(
                    label: 'Vincular outro alimento',
                    icon: Icons.link,
                    onPressed: widget.onRelink!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
