import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionChart extends StatefulWidget {
  const NutritionChart({super.key, required this.proteinGrams, required this.carbohydrateGrams, required this.fatGrams, required this.size});

  final double proteinGrams;
  final double carbohydrateGrams;
  final double fatGrams;
  final double size;

  @override
  State<StatefulWidget> createState() => NutritionChartState();
}

class NutritionChartState extends State<NutritionChart> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: .w700,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: Offset(0, 1),
          blurRadius: 5,
        )
      ],
    );

    final radius = widget.size / 2;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sectionsSpace: 0,
          sections: [
            PieChartSectionData(
              value: widget.proteinGrams,
              color: Colors.red,
              title: "${widget.proteinGrams.round()}g",
              titleStyle: textStyle,
              radius: radius,
            ),
            PieChartSectionData(
              value: widget.carbohydrateGrams,
              color: Colors.blue,
              title: "${widget.carbohydrateGrams.round()}g",
              radius: radius,
              titleStyle: textStyle,
            ),
            PieChartSectionData(
              value: widget.fatGrams,
              color: Colors.amber,
              title: "${widget.fatGrams.round()}g",
              radius: radius,
              titleStyle: textStyle,
            )
          ]
        ),
        duration: Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}