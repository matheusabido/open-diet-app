import 'package:flutter/material.dart';
import 'package:open_diet/components/bottom_navigation_bar.dart';
import 'package:open_diet/components/nutrition_chart.dart';
import 'package:open_diet/components/stats_card.dart';
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
      bottomNavigationBar: AppBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                  color: AppColors.container,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Café da Manhã",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: .w500,
                            ),
                          ),
                        ),
                        IconButton(
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
              )
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
