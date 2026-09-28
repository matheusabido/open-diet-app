import 'package:flutter/material.dart';
import 'package:open_diet/components/nutrient_tag.dart';
import 'package:open_diet/models/food.dart';
import 'package:open_diet/theme/colors.dart';
import 'package:open_diet/utils/numbers.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food, required this.onTap});

  final Food food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = food.brand;
    final portion = '${formatAmount(food.amount)} ${food.unit}';
    const secondaryTextStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 12,
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.container2,
          borderRadius: .circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(8),
          child: Padding(
            padding: .symmetric(horizontal: 12, vertical: 8),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 2,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Flexible(
                            child: Text(
                              food.name,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: .w600,
                              ),
                            ),
                          ),
                          if (brand != null)
                            Flexible(
                              child: Text(
                                brand,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: secondaryTextStyle,
                              ),
                            ),
                          Text('·', style: secondaryTextStyle),
                          Text(portion, style: secondaryTextStyle),
                        ],
                      ),
                      Row(
                        spacing: 12,
                        children: [
                          NutrientTag(
                            label: 'P',
                            grams: food.protein,
                            color: Colors.red,
                          ),
                          NutrientTag(
                            label: 'C',
                            grams: food.carbohydrate,
                            color: Colors.blue,
                          ),
                          NutrientTag(
                            label: 'G',
                            grams: food.fat,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${food.kcal.round()} kcal',
                  style: TextStyle(color: Colors.white, fontWeight: .w600),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
