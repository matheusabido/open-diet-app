import 'package:flutter/material.dart';
import 'package:open_diet/components/input/text_input.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  child: TextInput(
                    hint: 'Pesquisar por nome...',
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
