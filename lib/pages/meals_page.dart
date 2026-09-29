import 'package:flutter/material.dart';
import 'package:open_diet/components/meal_section.dart';
import 'package:open_diet/components/stats_card.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/services/api.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  double sum(List<FoodItem> items, double Function(FoodItem item) value) {
    return items.fold(0, (total, item) => total + value(item));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Api.instance,
      builder: (context, _) {
        final user = Api.instance.user!;
        final items = Api.instance.foodItems;

        return RefreshIndicator(
          onRefresh: Api.instance.syncFoodItems,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: .all(16),
              child: Column(
                spacing: 16,
                children: [
                  StatsCard(
                    kcal: sum(items, (i) => i.kcal),
                    kcalGoal: user.kcalGoal.toDouble(),
                    proteinGrams: sum(items, (i) => i.protein),
                    proteinGoal: user.proteinGoal.toDouble(),
                    carbohydrateGrams: sum(items, (i) => i.carbohydrate),
                    carbohydrateGoal: user.carbohydrateGoal.toDouble(),
                    fatGrams: sum(items, (i) => i.fat),
                    fatGoal: user.fatGoal.toDouble(),
                  ),
                  for (final meal in mealNames.keys)
                    MealSection(
                      meal: meal,
                      items: items.where((i) => i.meal == meal).toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
