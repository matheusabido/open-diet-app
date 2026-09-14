import 'package:flutter/material.dart';
import 'package:open_diet/components/nutrition_chart.dart';
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          NutritionChart(
                            proteinGrams: 50,
                            carbohydrateGrams: 30,
                            fatGrams: 20,
                            size: 120,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisSize: .min,
                              children: [
                                LinearProgressIndicator(
                                  value: 0.5,
                                  color: Colors.red,
                                  borderRadius: .circular(8),
                                  minHeight: 6,
                                ),
                                SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: 0.5,
                                  color: Colors.blue,
                                  borderRadius: .circular(8),
                                  minHeight: 6,
                                ),
                                SizedBox(height: 16),
                                LinearProgressIndicator(
                                  value: 0.5,
                                  color: Colors.amber,
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
                          onPressed: ()=> {
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
