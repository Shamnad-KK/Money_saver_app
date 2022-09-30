import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/view/home_screen/widgets/home_bottom_section_widget.dart';
import 'package:money_manager/view/home_screen/widgets/home_top_section_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(
      context,
      listen: false,
    );

    final dropDownController = Provider.of<DropDownController>(
      context,
      listen: false,
    );

    TabController tabController = TabController(
      length: 3,
      vsync: Scaffold.of(context),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await authController.saveName();

      await dropDownController.allFilter(tabController: tabController);
    });

    log("build called");
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            const HomeTopSectionWidget(),
          ];
        },
        body: HomeBottomSectionWidget(
          tabController: tabController,
          dropDownController: dropDownController,
        ),
      ),
    );
  }
}
