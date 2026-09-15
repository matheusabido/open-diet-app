import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_diet/components/nutrition_chart.dart';
import 'package:open_diet/theme/colors.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({
    super.key,
    required this.proteinGrams,
    required this.carbohydrateGrams,
    required this.fatGrams,
    required this.proteinGoal,
    required this.carbohydrateGoal,
    required this.fatGoal,
  });

  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;

  final double proteinGoal;
  final double carbohydrateGoal;
  final double fatGoal;

  @override
  State<StatefulWidget> createState() => StatsCardState();
}

class StatsCardState extends State<StatsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          Text(
            "Suas Estatísticas",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: .w500,
            ),
          ),
          Row(
            spacing: 16,
            children: [
              NutritionChart(
                proteinGrams: widget.proteinGrams,
                carbohydrateGrams: widget.carbohydrateGrams,
                fatGrams: widget.fatGrams,
                size: 120,
              ),

              Expanded(
                child: Column(
                  mainAxisSize: .min,
                  spacing: 16,
                  children: [
                    NutritionProgressBar(currentAmount: widget.proteinGrams, goalAmount: widget.proteinGoal, color: Colors.red),
                    NutritionProgressBar(currentAmount: widget.carbohydrateGrams, goalAmount: widget.carbohydrateGoal, color: Colors.blue),
                    NutritionProgressBar(currentAmount: widget.fatGrams, goalAmount: widget.fatGoal, color: Colors.amber),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class NutritionProgressBar extends StatefulWidget {
  const NutritionProgressBar({super.key, required this.currentAmount, required this.goalAmount, required this.color});

  final double currentAmount;
  final double goalAmount;
  final Color color;

  @override
  State<StatefulWidget> createState() => NutritionChartState();
}

class NutritionProgressBarState extends State<NutritionProgressBar> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Color.fromARGB(255, 227, 227, 227),
      fontSize: 13,
      shadows: [
        Shadow(
          blurRadius: 3,
          offset: Offset(0, 1)
        ),
      ],
    );

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: min(widget.currentAmount / widget.goalAmount, 1),
            color: widget.color,
            borderRadius: .circular(8),
            minHeight: 6,
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            "${widget.goalAmount.round()}g",
            style: textStyle,
          ),
        )
      ],
    );
  }
}