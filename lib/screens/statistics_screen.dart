import 'package:flutter/material.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/controllers/dropdown_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/statistics_sort/stats_sort.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  //String dropDownValue = 'ALL';
  late DropDownController dropDownController;
  late TabController tabController;

  filter() async {
    await dropDownController.statsFilter(tabController: tabController);
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    dropDownController = Provider.of(context, listen: false);
    dropDownController.setFoundData(dropDownController.allData);

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
            Consumer<DropDownController>(
                builder: (BuildContext context, value, Widget? child) {
              return DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: blackColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                      ),
                    ),
                    value: value.statsDropDownValue,
                    items: ['ALL', 'TODAY', '7 DAYS', '30 DAYS']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) async {
                      dropDownController
                          .setFoundData(dropDownController.allData);
                      dropDownController.setStatsDropDown(newValue);
                      await chartSort(
                          value.statsFilter(tabController: tabController));
                    }),
              );
            }),
            sBoxH30,
            Consumer<DropDownController>(
                builder: (BuildContext context, value, Widget? child) {
              return TabBar(
                onTap: (_) async {
                  // dropDownController.setFoundData(dropDownController.allData);
                  await chartSort(dropDownController.statsFilter(
                      tabController: tabController));
                },
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
                      'All',
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
              );
            }),
            Consumer<DropDownController>(
                builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                flex: 2,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    //overview
                    dropDownController.foundData.isNotEmpty
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
                                dataSource: chartSort(value.statsFilter(
                                    tabController: tabController)),
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
                    dropDownController.foundData.isNotEmpty
                        ? SfCircularChart(
                            legend: Legend(
                              isResponsive: true,
                              isVisible: true,
                            ),
                            series: <CircularSeries>[
                              PieSeries<ChartData, String>(
                                  explode: true,
                                  explodeGesture: ActivationMode.longPress,
                                  dataSource: chartSort(
                                      dropDownController.statsFilter(
                                          tabController: tabController)),
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
                    dropDownController.foundData.isNotEmpty
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
                                  dataSource: chartSort(
                                      dropDownController.statsFilter(
                                          tabController: tabController)),
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
