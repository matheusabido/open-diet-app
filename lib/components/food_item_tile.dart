import 'package:flutter/material.dart';
import 'package:open_diet/models/food_item.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';

class FoodItemTile extends StatefulWidget {
  const FoodItemTile({super.key, required this.item, required this.onTap});

  final FoodItem item;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => FoodItemTileState();
}

class FoodItemTileState extends State<FoodItemTile> {
  @override
  Widget build(BuildContext context) {
    const nameTextStyle = TextStyle(color: Colors.white);

    const amountTextStyle = TextStyle(color: Colors.white54);

    final item = widget.item;

    return Opacity(
      opacity: item.isPending ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.container2,
            borderRadius: .circular(8),
          ),
          child: InkWell(
            onTap: item.isPending ? null : widget.onTap,
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
                        Text(item.food.name, style: nameTextStyle),
                        Text("·", style: amountTextStyle),
                        Text(
                          "${formatAmount(item.amount)} ${item.unit}",
                          style: amountTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Text("${item.kcal.round()} kcal", style: nameTextStyle),
                  Icon(Icons.keyboard_arrow_right, color: Colors.white70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
