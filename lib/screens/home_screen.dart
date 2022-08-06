import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  String name = '';

  @override
  void initState() {
    saveName();
    CategoryDbFunctions().refreshUi();
    TransactionDbFunctions().refreshUi;
    TransactionDbFunctions().sortCustomTransaction();

    tabController = TabController(length: 3, vsync: this);
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

  final ValueNotifier<String> dropDownValue = ValueNotifier('ALL');
  final ValueNotifier<String> customDropDownValue = ValueNotifier('THIS WEEK');

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
                          type: ScreenType.addScreen,
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
                        ValueListenableBuilder(
                          builder: (BuildContext context, String value,
                              Widget? child) {
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                alignment: Alignment.centerRight,
                                elevation: 16,
                                value: dropDownValue.value,
                                items: <String>[
                                  'ALL',
                                  'INCOME',
                                  'EXPENSE',
                                ]
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: appLargeTextStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (String? newValue) {
                                  dropDownValue.value = newValue ?? '';
                                  setState(() {});
                                },
                              ),
                            );
                          },
                          valueListenable: dropDownValue,
                        )
                      ],
                    ),
                    sBoxH10,
                  ],
                ),
              ),
              TabBar(
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
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    //ALL
                    AllTransactionList(
                      valueListenable: allFilter(tabController: tabController),
                    ),
                    //TODAY
                    TodayTransactionList(
                      valueListenable:
                          todayFilter(tabController: tabController),
                    ),
                    //THIS WEEK
                    ValueListenableBuilder(
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return CustomTransactionList(
                          customDropDownValue: customDropDownValue,
                          valueListenable: customFilter(),
                          dropDownValue: dropDownValue,
                        );
                      },
                      valueListenable: customDropDownValue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  allFilter({required TabController tabController}) {
    if (dropDownValue.value == 'ALL') {
      return TransactionDbFunctions.allTransactionNotifier;
    } else if (dropDownValue.value == 'INCOME') {
      return TransactionDbFunctions.incomeTransactionNotifier;
    } else if (dropDownValue.value == 'EXPENSE') {
      return TransactionDbFunctions.expenseTransactionNotifier;
    }
  }

  todayFilter({required TabController tabController}) {
    if (dropDownValue.value == 'ALL') {
      return TransactionDbFunctions.todayTransactionNotifier;
    } else if (dropDownValue.value == 'INCOME') {
      return TransactionDbFunctions.todayIncomeNotifier;
    } else if (dropDownValue.value == 'EXPENSE') {
      return TransactionDbFunctions.todayExpenseNotifier;
    }
  }

  customFilter() {
    if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'THIS WEEK') {
      return TransactionDbFunctions.instance.thisWeekAllNotifier;
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'THIS WEEK') {
      return TransactionDbFunctions.instance.thisWeekIncomeNotifier;
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'THIS WEEK') {
      return TransactionDbFunctions.instance.thisWeekExpenseNotifier;
    } else if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'THIS MONTH') {
      return TransactionDbFunctions.instance.thisMonthAllNotifier;
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'THIS MONTH') {
      return TransactionDbFunctions.instance.thisMonthIncomeNotifier;
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'THIS MONTH') {
      return TransactionDbFunctions.instance.thisMonthExpenseNotifier;
    } else if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'THIS YEAR') {
      return TransactionDbFunctions.instance.thisYearAllNotifier;
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'THIS YEAR') {
      return TransactionDbFunctions.instance.thisYearIncomeNotifier;
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'THIS YEAR') {
      return TransactionDbFunctions.instance.thisYearExpenseNotifier;
    }
  }
}
