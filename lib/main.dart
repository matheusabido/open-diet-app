import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              height: 150,
              child: PieChart(
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
                      )
                    ]
                  ),
                  duration: Duration(milliseconds: 150),
                  curve: Curves.linear,
                )
              ),
            )
        ),
      )
    );
  }
}
