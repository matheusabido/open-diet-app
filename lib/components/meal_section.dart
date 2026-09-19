import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class MealSection extends StatefulWidget {
  const MealSection({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => MealSectionState();
}

class MealSectionState extends State<MealSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.container,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: .fromLTRB(16, 8, 8, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: .w500,
                  ),
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => {
                  print(widget.title)
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
    );
  }
}