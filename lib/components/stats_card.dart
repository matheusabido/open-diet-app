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
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: min(widget.proteinGrams / widget.proteinGoal, 1),
                            color: Colors.red,
                            borderRadius: .circular(8),
                            minHeight: 6,
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            "${widget.proteinGoal.round()}g",
                            style: textStyle,
                          ),
                        )
                      ],
                    ),

                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: min(widget.carbohydrateGrams / widget.carbohydrateGoal, 1),
                            color: Colors.blue,
                            borderRadius: .circular(8),
                            minHeight: 6,
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            "${widget.carbohydrateGoal.round()}g",
                            style: textStyle,
                          ),
                        )
                      ],
                    ),
                    
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: min(widget.fatGrams / widget.fatGoal, 1),
                            color: Colors.amber,
                            borderRadius: .circular(8),
                            minHeight: 6,
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            "${widget.fatGoal.round()}g",
                            style: textStyle,
                          ),
                        )
                      ],
                    ),
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