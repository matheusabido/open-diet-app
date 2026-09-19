import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';

class FoodItem extends StatefulWidget {
  const FoodItem({super.key, required this.name, required this.kcal, required this.amount, required this.unit});

  final String name;
  final double kcal;

  final double amount;
  final String unit;

  @override
  State<StatefulWidget> createState() => FoodItemState();
}

class FoodItemState extends State<FoodItem> {
  @override
  Widget build(BuildContext context) {
    const nameTextStyle = TextStyle(
      color: Colors.white,
    );

    const amountTextStyle = TextStyle(
      color: Colors.white54,
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.container2,
          borderRadius: .circular(8)
        ),
        child: InkWell(
          onTap: () => print(widget.name),
          borderRadius: .circular(8),
          child: Padding(
            padding: .all(8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: .start,
                    spacing: 8,
                    children: [
                      Text(widget.name, style: nameTextStyle),
                      Text("·", style: amountTextStyle),
                      Text("${formatAmount(widget.amount)} ${widget.unit}", style: amountTextStyle),
                    ],
                  ),
                ),
                Text("${widget.kcal.round()} kcal", style: nameTextStyle),
                Icon(Icons.keyboard_arrow_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}