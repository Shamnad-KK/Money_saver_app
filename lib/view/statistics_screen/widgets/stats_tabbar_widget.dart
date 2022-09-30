import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/statistics_controller.dart';
import 'package:money_manager/helpers/colors.dart';

class StatsTabbarWidget extends StatelessWidget {
  const StatsTabbarWidget({
    Key? key,
    required this.statisticsConsumer,
  }) : super(key: key);

  final StatisticsController statisticsConsumer;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (_) {
        statisticsConsumer.chartSort(
            statisticsConsumer.statsFilter(statisticsConsumer.tabController));
      },
      controller: statisticsConsumer.tabController,
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
  }
}
