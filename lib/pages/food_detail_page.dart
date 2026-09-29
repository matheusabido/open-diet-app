import 'package:flutter/material.dart';
import 'package:open_diet/components/confirm_dialog.dart';
import 'package:open_diet/components/nutrient_row.dart';
import 'package:open_diet/components/primary_button.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/pages/food_form_page.dart';
import 'package:open_diet/pages/food_item_form_page.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/food_items.dart';
import 'package:open_diet/utils/numbers.dart';
import 'package:open_diet/utils/toast.dart';

class FoodDetailPage extends StatefulWidget {
  const FoodDetailPage({
    super.key,
    required this.food,
    required this.onUpdated,
    required this.onDeleted,
  });

  final Food food;
  final ValueChanged<Food> onUpdated;
  final VoidCallback onDeleted;

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  late Food food = widget.food;
  bool isDeleting = false;
  String? errorMessage;

  Future<void> edit() async {
    final updated = await Navigator.of(
      context,
    ).push<Food>(MaterialPageRoute(builder: (_) => FoodFormPage(food: food)));
    if (updated == null) return;

    setState(() {
      food = updated;
    });
    widget.onUpdated(updated);
  }

  Future<void> addToMeal() async {
    final draft = await Navigator.of(context).push<FoodItemDraft>(
      MaterialPageRoute(builder: (_) => FoodItemFormPage(food: food)),
    );
    if (draft == null || !mounted) return;

    showToast(context, 'Adicionado em ${mealNames[draft.meal]}');
    addFoodItem(context, draft);
  }

  Future<void> delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Excluir alimento',
        message: 'Tem certeza que deseja excluir "${food.name}"?',
        confirmLabel: 'Excluir',
      ),
    );
    if (confirmed != true) return;

    setState(() {
      isDeleting = true;
      errorMessage = null;
    });

    try {
      await Api.instance.delete('/foods/${food.id}');
      widget.onDeleted();
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Não foi possível excluir o alimento';
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Não foi possível conectar ao servidor';
      });
    } finally {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Api.instance.user?.isAdmin ?? false;
    final brand = food.brand;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Alimento'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: isDeleting ? null : edit,
              icon: Icon(Icons.edit_outlined),
            ),
          if (isAdmin)
            IconButton(
              onPressed: isDeleting ? null : delete,
              icon: Icon(Icons.delete_outline, color: Colors.red.shade300),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: .all(16),
          children: [
            Column(
              crossAxisAlignment: .stretch,
              spacing: 8,
              children: [
                Text(
                  food.name,
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 24,
                    fontWeight: .bold,
                  ),
                ),
                if (brand != null)
                  Text(brand, style: TextStyle(color: AppColors.textSecondary)),
                SizedBox(height: 8),
                Text(
                  'Valores nutricionais por ${formatAmount(food.amount)} ${food.unit}',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                NutrientRow(label: 'Calorias', value: food.kcal, unit: 'kcal'),
                NutrientRow(
                  label: 'Proteína',
                  value: food.protein,
                  unit: 'g',
                  color: Colors.red,
                ),
                NutrientRow(
                  label: 'Carboidrato',
                  value: food.carbohydrate,
                  unit: 'g',
                  color: Colors.blue,
                ),
                NutrientRow(
                  label: 'Gordura',
                  value: food.fat,
                  unit: 'g',
                  color: Colors.amber,
                ),
                SizedBox(height: 8),
                PrimaryButton(
                  label: 'Adicionar à refeição',
                  onPressed: addToMeal,
                ),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: .center,
                    style: TextStyle(color: Colors.red.shade300),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
