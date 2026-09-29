import 'package:flutter/material.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/pages/foods_page.dart';
import 'package:open_diet/theme/colors.dart';

class SelectFoodPage extends StatelessWidget {
  const SelectFoodPage({super.key, required this.meal});

  final String meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Adicionar em ${mealNames[meal]}'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.grey.shade200,
      ),
      body: SafeArea(child: FoodsPage(meal: meal)),
    );
  }
}
