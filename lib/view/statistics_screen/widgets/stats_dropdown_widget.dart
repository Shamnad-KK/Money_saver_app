import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/statistics_controller.dart';
import 'package:money_manager/helpers/colors.dart';

class StatsDropDownWidget extends StatelessWidget {
  const StatsDropDownWidget({
    Key? key,
    required this.statisticsConsumer,
  }) : super(key: key);

  final StatisticsController statisticsConsumer;

  @override
  Widget build(BuildContext context) {
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
        value: statisticsConsumer.statsDropDownValue,
        items: ['ALL', 'TODAY', '7 DAYS', '30 DAYS']
            .map(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            )
            .toList(),
        onChanged: (String? newValue) async {
          // statisticsController
          //     .setFoundData(statisticsController.foundData);
          statisticsConsumer.setStatsDropDown(newValue);
          await statisticsConsumer.chartSort(
              statisticsConsumer.statsFilter(statisticsConsumer.tabController));
        },
      ),
    );
  }
}
