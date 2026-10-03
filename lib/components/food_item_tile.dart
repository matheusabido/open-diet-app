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

    const brandTextStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 12,
    );

    final item = widget.item;
    final brand = item.food.brand;

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
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: 2,
                      children: [
                        Row(
                          crossAxisAlignment: .baseline,
                          textBaseline: .alphabetic,
                          spacing: 8,
                          children: [
                            Flexible(
                              child: Text(
                                item.food.name,
                                maxLines: 2,
                                overflow: .ellipsis,
                                style: nameTextStyle,
                              ),
                            ),
                            Text("·", style: amountTextStyle),
                            Text(
                              "${formatAmount(item.amount)} ${item.unit}",
                              style: amountTextStyle,
                            ),
                          ],
                        ),
                        if (brand != null)
                          Text(
                            brand,
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: brandTextStyle,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
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
