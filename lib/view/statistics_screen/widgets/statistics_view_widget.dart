import 'package:flutter/material.dart';
import 'package:money_manager/controllers/statistics_controller.dart';
import 'package:money_manager/models/statistics/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsViewWidget extends StatelessWidget {
  const StatisticsViewWidget({
    Key? key,
    required this.statisticsConsumer,
  }) : super(key: key);
  final StatisticsController statisticsConsumer;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: statisticsConsumer.tabController,
        children: [
          //overview
          statisticsConsumer.foundData.isNotEmpty
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
                      dataSource: statisticsConsumer
                          .chartSort(statisticsConsumer.foundData),
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
          statisticsConsumer.foundData.isNotEmpty
              ? SfCircularChart(
                  legend: Legend(
                    isResponsive: true,
                    isVisible: true,
                  ),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                        explode: true,
                        explodeGesture: ActivationMode.longPress,
                        dataSource: statisticsConsumer
                            .chartSort(statisticsConsumer.foundData),
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
          statisticsConsumer.foundData.isNotEmpty
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
                        dataSource: statisticsConsumer
                            .chartSort(statisticsConsumer.foundData),
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
  }
}
