import 'package:flutter/material.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Foods Page!", style: TextStyle(color: Colors.white))
      ],
    );
  }
}