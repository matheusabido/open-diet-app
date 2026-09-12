import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

void main() {
  runApp(const OpenDietApp());
}

class OpenDietApp extends StatelessWidget {
  const OpenDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Diet',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Open Diet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: AppColors.container,
              borderRadius: BorderRadius.circular(16),
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
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(child: NutritionChart()),
                      Expanded(
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            LinearProgressIndicator(
                              value: 0.5,
                              color: Colors.blue,
                              borderRadius: .circular(8),
                              minHeight: 6,
                            ),
                            SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: 0.5,
                              color: Colors.red,
                              borderRadius: .circular(8),
                              minHeight: 6,
                            ),
                            SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: 0.5,
                              color: Colors.green,
                              borderRadius: .circular(8),
                              minHeight: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          )
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}

class NutritionChart extends StatelessWidget {
  const NutritionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 0,
        sections: [
          PieChartSectionData(
            value: 10,
            color: Colors.red,
            title: "10g",
            radius: 60,
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.blue,
            title: "20g",
            radius: 60,
          ),
          PieChartSectionData(
            value: 50,
            color: Colors.green,
            title: "50g",
            radius: 60,
          )
        ]
      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
    );
  }
}