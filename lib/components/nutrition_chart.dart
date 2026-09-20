import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionChart extends StatefulWidget {
  const NutritionChart({super.key, required this.proteinGrams, required this.carbohydrateGrams, required this.fatGrams, required this.kcalRemaining, required this.size});

  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;
  final double kcalRemaining;
  final double size;

  @override
  State<StatefulWidget> createState() => NutritionChartState();
}

class NutritionChartState extends State<NutritionChart> {
  @override
  Widget build(BuildContext context) {
    const shadows = <Shadow>[
      Shadow(
          offset: Offset(0, 1),
          blurRadius: 5,
        )
    ];

    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: .w700,
      color: Colors.white,
      shadows: shadows,
    );

    const kcalTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: .w700,
      shadows: shadows,
    );

    const kcalSubtextStyle = TextStyle(
      color: Colors.white70,
      fontSize: 11,
      shadows: shadows,
    );

    final radius = widget.size / 2;
    const sectionRadius = 20.0;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: .center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: radius - sectionRadius,
              sectionsSpace: 0,
              sections: [
                PieChartSectionData(
                  value: widget.proteinGrams,
                  color: Colors.red,
                  title: "${widget.proteinGrams.round()}g",
                  titleStyle: textStyle,
                  radius: sectionRadius,
                ),
                PieChartSectionData(
                  value: widget.carbohydrateGrams,
                  color: Colors.blue,
                  title: "${widget.carbohydrateGrams.round()}g",
                  radius: sectionRadius,
                  titleStyle: textStyle,
                ),
                PieChartSectionData(
                  value: widget.fatGrams,
                  color: Colors.amber,
                  title: "${widget.fatGrams.round()}g",
                  radius: sectionRadius,
                  titleStyle: textStyle,
                )
              ]
            ),
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
          ),
          Column(
            mainAxisAlignment: .center,
            spacing: -4,
            children: [
              Text(widget.kcalRemaining.round().toString(), style: kcalTextStyle),
              Text("kcal restantes", style: kcalSubtextStyle)
            ],
          ),
        ],
      )
    );
  }
}