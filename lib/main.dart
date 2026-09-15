import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_diet/components/bottom_navigation_bar.dart';
import 'package:open_diet/pages/foods_page.dart';
import 'package:open_diet/pages/meals_page.dart';
import 'package:open_diet/pages/profile_page.dart';
import 'package:open_diet/theme/colors.dart';

void main() {
  runApp(const OpenDietApp());
}

class OpenDietApp extends StatelessWidget {
  const OpenDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Diet',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 1;

  void onChangeTab(int currentTabIndex) {
    setState(() {
      currentPageIndex = currentTabIndex;
    });
  }

  static const _pages = [
    FoodsPage(),
    MealsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentPageIndex,
        onChange: onChangeTab,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _pages[currentPageIndex],
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
