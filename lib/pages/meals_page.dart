import 'package:flutter/material.dart';
import 'package:open_diet/components/stats_card.dart';
import 'package:open_diet/theme/colors.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatsCard(
          proteinGrams: 50,
          proteinGoal: 136,
          carbohydrateGrams: 30,
          carbohydrateGoal: 181,
          fatGrams: 20,
          fatGoal: 60,
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.container,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: .fromLTRB(16, 8, 8, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Café da Manhã",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => {
                      print("Hello")
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}