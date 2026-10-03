import 'package:flutter/material.dart';
import 'package:open_diet/components/food_item_tile.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/pages/food_item_form_page.dart';
import 'package:open_diet/pages/select_food_page.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/food_items.dart';

class MealSection extends StatefulWidget {
  const MealSection({super.key, required this.meal, required this.items});

  final String meal;
  final List<FoodItem> items;

  @override
  State<StatefulWidget> createState() => MealSectionState();
}

class MealSectionState extends State<MealSection> {
  Future<void> addFood() async {
    final draft = await Navigator.of(context).push<FoodItemDraft>(
      MaterialPageRoute(builder: (_) => SelectFoodPage(meal: widget.meal)),
    );
    if (draft != null && mounted) addFoodItem(context, draft);
  }

  Future<void> editItem(FoodItem item) async {
    final draft = await Navigator.of(context).push<FoodItemDraft>(
      MaterialPageRoute(
        builder: (_) => FoodItemFormPage(
          food: item.food,
          item: item,
          onDelete: () => deleteItem(item),
        ),
      ),
    );
    if (draft != null && mounted) updateFoodItem(context, item, draft);
  }

  void deleteItem(FoodItem item) {
    Navigator.of(context).pop();
    removeFoodItem(context, item);
  }

  @override
  Widget build(BuildContext context) {
    const amountTextStyle = TextStyle(color: Colors.white70);

    final totalKcal = widget.items.fold(0.0, (total, i) => total + i.kcal);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: .all(16),
      child: Column(
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      mealNames[widget.meal]!,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: .w500,
                      ),
                    ),
                    Text("·", style: amountTextStyle),
                    Text("${totalKcal.round()} kcal", style: amountTextStyle),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: addFood,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),

          for (final item in widget.items)
            FoodItemTile(item: item, onTap: () => editItem(item)),
        ],
      ),
    );
  }
}
