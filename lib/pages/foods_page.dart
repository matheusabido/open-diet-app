import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: AppColors.container2,
      ),
    );
    
    final controller = TextEditingController();

    return Padding(
      padding: .all(16),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquisar por nome...',

                      enabledBorder: border,
                      focusedBorder: border,

                      contentPadding: .all(8),

                      filled: true,
                      fillColor: AppColors.container,
                      
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade200,
                    ),
                    controller: controller,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => print(controller.text),
                  icon: Icon(Icons.add, color: Colors.grey.shade300),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}