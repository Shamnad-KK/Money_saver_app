import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/getx/get_x.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/screens/add_transaction_screen.dart';
import 'package:money_manager/screens/search_screen.dart';
import 'package:money_manager/widgets/all_transaction_list.dart';
import 'package:money_manager/widgets/home_card_widget.dart';
import 'package:money_manager/widgets/this_week_transctn_list.dart';
import 'package:money_manager/widgets/today_trasaction_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../database/models/transaction_model/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  late DropDownController dropDownController;
  String name = '';

  filter() async {
    await dropDownController.allFilter(tabController: tabController);
    dropDownController.rebuildList.value =
        !dropDownController.rebuildList.value;
    await dropDownController.customFilter(tabController: tabController);
  }

  late final List<TransactionModal> allData;

  initialise() async {
    allData = TransactionDbFunctions.allTransactionNotifier.value;
    await TransactionDbFunctions().refreshUi();
    dropDownController.foundData.value = allData;
    dropDownController.rebuildList.value =
        !dropDownController.rebuildList.value;
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    dropDownController = Get.put(DropDownController());
    saveName();
    CategoryDbFunctions().refreshUi();

    // Future.delayed(const Duration(milliseconds: 500), () {
    // setState(() {
    //dropDownController.foundData.value = dropDownController.allData;
    // dropDownController.rebuildList.value =
    //     !dropDownController.rebuildList.value;
    //});
    // });
    initialise();
    TransactionDbFunctions().refreshUi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filter();
      //Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        dropDownController.foundData.value = dropDownController.allData;
        dropDownController.rebuildList.value =
            !dropDownController.rebuildList.value;
      });
      //});
    });
    super.initState();
  }

  Future<void> saveName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final shared = sharedPreferences.getString(nameKey);
    setState(() {
      name = shared.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text(
                  name.toUpperCase(),
                ),
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
                        Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              alignment: Alignment.centerRight,
                              elevation: 16,
                              value: dropDownController.dropDownValue.value,
                              items: <String>[
                                'ALL',
                                'INCOME',
                                'EXPENSE',
                              ]
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: appLargeTextStyle,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) async {
                                dropDownController.foundData.value =
                                    dropDownController.allData;
                                dropDownController.dropDownValue.value =
                                    newValue!;
                                await dropDownController.allFilter(
                                    tabController: tabController);
                                if (tabController.index == 2) {
                                  await dropDownController.customFilter(
                                      tabController: tabController);
                                }
                                dropDownController.rebuildList.value =
                                    !dropDownController.rebuildList.value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    sBoxH10,
                  ],
                ),
              ),
              TabBar(
                onTap: (value) {
                  dropDownController.foundData.value =
                      dropDownController.allData;

                  tabController.index == 2
                      ? dropDownController.customFilter(
                          tabController: tabController)
                      : dropDownController.allFilter(
                          tabController: tabController);

                  dropDownController.rebuildList.value =
                      !dropDownController.rebuildList.value;
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
              //Tab bar view
              Obx(
                () => Expanded(
                  child: dropDownController.rebuildList.value
                      ? tabbarView()
                      : tabbarView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TabBarView tabbarView() {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        //ALL
        all(),
        //TODAY
        today(),
        //THIS WEEK
        custom(),
      ],
    );
  }

  TodayTransactionList today() {
    return TodayTransactionList(
      foundData: dropDownController.foundData,
      tabController: tabController,
    );
  }

  AllTransactionList all() {
    return AllTransactionList(
      foundData: dropDownController.foundData,
      tabController: tabController,
    );
  }

  CustomTransactionList custom() {
    return CustomTransactionList(
      tabController: tabController,
      foundData: dropDownController.foundData,
    );
  }
}
