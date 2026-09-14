import 'package:flutter/material.dart';
import 'package:open_diet/theme/colors.dart';

class AppBottomNav extends StatefulWidget {
  const AppBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<StatefulWidget> createState() => AppBottomNavState();
}

class AppBottomNavState extends State<AppBottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.container,
      
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      selectedFontSize: 12,
      unselectedFontSize: 12,

      currentIndex: widget.currentIndex,
      items: const [
        BottomNavigationBarItem(
          label: "Cadastros",
          icon: Icon(Icons.add),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: "Refeições",
        ),
        BottomNavigationBarItem(
          label: "Perfil",
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}