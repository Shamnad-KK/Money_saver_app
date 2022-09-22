import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/controllers/auth_controller.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';
import 'package:money_manager/screens/search_screen.dart';
import 'package:money_manager/widgets/all_transaction_list_widget.dart';
import 'package:money_manager/widgets/home_card_widget.dart';
import 'package:money_manager/widgets/this_week_transctn_list.dart';
import 'package:money_manager/widgets/today_trasaction_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    authController.saveName();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TransactionDbFunctions().refreshUi();
      CategoryDbFunctions().refreshUi();
      dropDownController.allFilter(tabController: tabController);
    });
    log("build called");
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              backgroundColor: mainColor,
              expandedHeight: 390.h,
              pinned: true,
              floating: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const SearchScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.search,
                  size: 35.sp,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTransactionScreen(
                          type: ScreenAction.addScreen,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    size: 35.sp,
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 1,
                title: Consumer<AuthController>(
                    builder: (BuildContext context, value, Widget? child) {
                  return Text(
                    value.name.toUpperCase(),
                  );
                }),
                background: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeCardWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  top: 10.h,
                  right: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TRANSACTIONS',
                          style: appLargeTextStyle,
                        ),
                        Consumer<DropDownController>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return value.homeDrop(tabController);
                          },
                        ),
                      ],
                    ),
                    sBoxH10,
                  ],
                ),
              ),
              TabBar(
                onTap: (value) {
                  dropDownController.foundData = dropDownController.allData;

                  tabController.index == 2
                      ? dropDownController.customFilter(
                          tabController: tabController)
                      : dropDownController.allFilter(
                          tabController: tabController);
                },
                indicatorColor: mainColor,
                controller: tabController,
                tabs: [
                  Tab(
                    child: Text(
                      'ALL',
                      style: appBodyTextStyle,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'TODAY',
                      style: appBodyTextStyle,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'CUSTOM',
                      style: appBodyTextStyle,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AllTransactionList(
                    tabController: tabController,
                  ),
                  TodayTransactionList(
                    tabController: tabController,
                  ),
                  CustomTransactionList(
                    tabController: tabController,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
