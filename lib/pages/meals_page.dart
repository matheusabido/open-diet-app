import 'package:flutter/material.dart';
import 'package:open_diet/components/meal_section.dart';
import 'package:open_diet/components/stats_card.dart';

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
              StatsCard(
                proteinGrams: 50,
                proteinGoal: 136,
                carbohydrateGrams: 30,
                carbohydrateGoal: 181,
                fatGrams: 20,
                fatGoal: 60,
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