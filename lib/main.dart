import 'package:flutter/material.dart';
import 'package:open_diet/components/bottom_navigation_bar.dart';
import 'package:open_diet/pages/foods_page.dart';
import 'package:open_diet/pages/login_page.dart';
import 'package:open_diet/pages/meals_page.dart';
import 'package:open_diet/pages/profile_page.dart';
import 'package:open_diet/services/api.dart';
import 'package:open_diet/theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.instance.restoreSession();
  runApp(const OpenDietApp());
}

class OpenDietApp extends StatelessWidget {
  const OpenDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Diet',
      theme: ThemeData(
        // The Android page transition fades through the surface color, so it
        // has to match the pages or the screen flashes white.
        colorScheme: .fromSeed(
          seedColor: Colors.green,
          surface: AppColors.background,
        ),
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

  static const _pages = [FoodsPage(), MealsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Api.instance,
      builder: (context, _) {
        if (!Api.instance.isLoggedIn) return const LoginPage();

        return Scaffold(
          bottomNavigationBar: AppBottomNav(
            currentIndex: currentPageIndex,
            onChange: onChangeTab,
          ),
          body: SafeArea(child: _pages[currentPageIndex]),
          backgroundColor: AppColors.background,
        );
      },
    );
  }
}
