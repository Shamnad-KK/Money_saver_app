import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/statistics_controller.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/view/statistics_screen/widgets/statistics_view_widget.dart';
import 'package:money_manager/view/statistics_screen/widgets/stats_dropdown_widget.dart';
import 'package:money_manager/view/statistics_screen/widgets/stats_tabbar_widget.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticsController =
        Provider.of<StatisticsController>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      statisticsController.chartSort(
        statisticsController.statsFilter(statisticsController.tabController),
      );
    });

    return Scaffold(
      appBar: const AppBarWidget(
        leading: 'Statistics',
      ),
      body: Builder(builder: (context) {
        statisticsController.tabController =
            TabController(length: 3, vsync: Scaffold.of(context));
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            20.h,
            20.w,
            20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<StatisticsController>(
                builder:
                    (BuildContext context, statisticsConsumer, Widget? child) {
                  return StatsDropDownWidget(
                      statisticsConsumer: statisticsController);
                },
              ),
              sBoxH30,
              Consumer<StatisticsController>(
                builder:
                    (BuildContext context, statisticsConsumer, Widget? child) {
                  return StatsTabbarWidget(
                    statisticsConsumer: statisticsConsumer,
                  );
                },
              ),
              Consumer<StatisticsController>(builder:
                  (BuildContext context, statisticsConsumer, Widget? child) {
                return StatisticsViewWidget(
                  statisticsConsumer: statisticsConsumer,
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
