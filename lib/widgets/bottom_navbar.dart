import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/controllers/bottom_nav_controller.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/controllers/transaction_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/screens/add_category_screen.dart';
import 'package:money_manager/screens/home_screen.dart';
import 'package:money_manager/screens/settings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List pageList = [
      const HomeScreen(),
      const AddCategoryScreen(),
      const SettingScreen(),
    ];
    final transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    final categoryDbController = Provider.of<CategoryDBController>(
      context,
      listen: false,
    );
    final bottomNavController =
        Provider.of<BottomNavController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await transactionController.refreshUi();
      await categoryDbController.refreshUi();
      bottomNavController.setIndex(0);
    });
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     if (selectedIndex != 0) {
        //       setState(() {
        //         selectedIndex = 0;
        //       });
        //       return true;
        //     }
        //     return false;
        //   },
        //   child:
        Consumer<BottomNavController>(
            builder: (BuildContext context, bottomNavConsumer, Widget? child) {
      return Scaffold(
        body: pageList[bottomNavConsumer.currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: bottomNavConsumer.currentIndex,
          onTap: (newIndex) {
            bottomNavConsumer.setIndex(newIndex);
          },
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
    });
  }
}
