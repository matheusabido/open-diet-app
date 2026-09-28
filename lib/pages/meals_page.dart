import 'package:flutter/material.dart';
import 'package:open_diet/components/meal_section.dart';
import 'package:open_diet/components/stats_card.dart';
import 'package:open_diet/services/api.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: .all(16),
        child: Column(
          spacing: 16,
          children: [
            ListenableBuilder(
              listenable: Api.instance,
              builder: (context, _) {
                final user = Api.instance.user!;

                return StatsCard(
                  kcal: 0,
                  kcalGoal: user.kcalGoal.toDouble(),
                  proteinGrams: 0.1,
                  proteinGoal: user.proteinGoal.toDouble(),
                  carbohydrateGrams: 0.1,
                  carbohydrateGoal: user.carbohydrateGoal.toDouble(),
                  fatGrams: 0.1,
                  fatGoal: user.fatGoal.toDouble(),
                );
              },
            ),
            MealSection(title: "Café da Manhã", totalKcal: 523),
            MealSection(title: "Almoço", totalKcal: 523),
            MealSection(title: "Jantar", totalKcal: 523),
            MealSection(title: "Lanches", totalKcal: 523),
          ],
        ),
      ),
    );
  }
}
