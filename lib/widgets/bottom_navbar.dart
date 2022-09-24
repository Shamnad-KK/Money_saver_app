import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/screens/add_category_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;
  final List pageList = [
    const HomeScreen(),
    const AddCategoryScreen(),
    SettingScreen(),
  ];

  void onTapped(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        onTap: onTapped,
        height: 60.h,
        color: mainColor,
        backgroundColor: whiteColor,
        items: const [
          Icon(
            Icons.home,
            color: whiteColor,
          ),
          Icon(
            Icons.category,
            color: whiteColor,
          ),
          Icon(
            Icons.settings,
            color: whiteColor,
          ),
        ],
        animationDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
