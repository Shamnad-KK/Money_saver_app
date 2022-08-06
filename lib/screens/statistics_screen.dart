import 'package:flutter/material.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/statistics_sort/stats_sort.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        leading: 'Statistics',
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: tabController,
              indicatorColor: Colors.transparent,
              labelColor: whiteColor,
              unselectedLabelColor: blackColor,
              labelStyle: TextStyle(
                color: whiteColor,
                fontSize: 20.sp,
              ),
              unselectedLabelStyle: TextStyle(
                color: blackColor,
                fontSize: 20.sp,
              ),
              indicator: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(
                  20.r,
                ),
              ),
              tabs: const [
                Tab(
                  child: Text(
                    'Overview',
                  ),
                ),
                Tab(
                  child: Text(
                    'Income',
                  ),
                ),
                Tab(
                  child: Text(
                    'Expense',
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: TabBarView(
                controller: tabController,
                children: [
                  //overview
                  TransactionDbFunctions.allTransactionNotifier.value.isNotEmpty
                      ? SfCircularChart(
                          legend: Legend(
                            isResponsive: true,
                            isVisible: true,
                          ),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              explode: true,
                              explodeGesture: ActivationMode.longPress,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                              ),
                              dataSource: chartSort(TransactionDbFunctions
                                  .allTransactionNotifier.value),
                              xValueMapper: (ChartData transaction, _) =>
                                  transaction.name,
                              yValueMapper: (ChartData transaction, _) =>
                                  transaction.amount,
                            ),
                          ],
                        )
                      : const Center(
                          child: Text(
                            'No Transactions to display',
                          ),
                        ),
                  //income
                  TransactionDbFunctions
                          .incomeTransactionNotifier.value.isNotEmpty
                      ? SfCircularChart(
                          legend: Legend(
                            isResponsive: true,
                            isVisible: true,
                          ),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                                explode: true,
                                explodeGesture: ActivationMode.longPress,
                                dataSource: chartSort(TransactionDbFunctions
                                    .incomeTransactionNotifier.value),
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                ),
                                xValueMapper: (ChartData transaction, _) =>
                                    transaction.name,
                                yValueMapper: (ChartData transaction, _) =>
                                    transaction.amount),
                          ],
                        )
                      : const Center(
                          child: Text(
                            'No Transactions to display',
                          ),
                        ),
                  //expense
                  TransactionDbFunctions
                          .expenseTransactionNotifier.value.isNotEmpty
                      ? SfCircularChart(
                          legend: Legend(
                            isResponsive: true,
                            isVisible: true,
                          ),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                                explode: true,
                                explodeGesture: ActivationMode.longPress,
                                dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                ),
                                dataSource: chartSort(TransactionDbFunctions
                                    .expenseTransactionNotifier.value),
                                xValueMapper: (ChartData transaction, _) =>
                                    transaction.name,
                                yValueMapper: (ChartData transaction, _) =>
                                    transaction.amount),
                          ],
                        )
                      : const Center(
                          child: Text(
                            'No Transactions to display',
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
