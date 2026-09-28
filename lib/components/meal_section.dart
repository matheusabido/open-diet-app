import 'package:flutter/material.dart';
import 'package:open_diet/components/food_item.dart';
import 'package:open_diet/theme/colors.dart';

class MealSection extends StatefulWidget {
  const MealSection({super.key, required this.title, required this.totalKcal});

  final String title;
  final double totalKcal;

  @override
  State<StatefulWidget> createState() => MealSectionState();
}

class MealSectionState extends State<MealSection> {
  @override
  Widget build(BuildContext context) {
    const amountTextStyle = TextStyle(color: Colors.white70);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: .all(16),
      child: Column(
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  spacing: 8,
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: .w500,
                      ),
                    ),
                    Text("·", style: amountTextStyle),
                    Text(
                      "${widget.totalKcal.round()} kcal",
                      style: amountTextStyle,
                    ),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => {print(widget.title)},
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),

          FoodItem(name: "Pizza", kcal: 400, amount: 1, unit: "un"),
          FoodItem(name: "Ice Cream", kcal: 123, amount: 60, unit: "g"),
        ],
      ),
    );
  }
}
