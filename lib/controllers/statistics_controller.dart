import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/statistics_repository.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/models/statistics/chart_model.dart';

class StatisticsController extends ChangeNotifier {
  late StatisticsController statisticsController;
  late TabController tabController;
  List<TransactionModal> allData = TransactionRepository.allTransactionNotifier;

  List<TransactionModal> foundData = [];

  String? _statsDropDownValue = 'ALL';
  String? get statsDropDownValue => _statsDropDownValue;

  void setStatsDropDown(String? statsDropDownValue) {
    _statsDropDownValue = statsDropDownValue;
    notifyListeners();
  }

  List<TransactionModal> statsFilter(TabController tabController) {
    foundData = allData;
    foundData = StatisticsRepository().statsFilter(
      foundData,
      allData,
      statsDropDownValue,
      tabController,
    );

    notifyListeners();
    return foundData;
  }

  chartSort(List<TransactionModal> modal) {
    List<ChartData> chart = [];
    List newList = [];
    int amount;
    String name;
    for (int i = 0; i < modal.length; i++) {
      newList.add(0);
    }
    for (int i = 0; i < modal.length; i++) {
      amount = modal[i].amount.toInt();
      name = modal[i].categoryModal.name;
      for (int j = i + 1; j < modal.length; j++) {
        if (name == modal[j].categoryModal.name) {
          amount += modal[j].amount.toInt();
          newList[j] = -1;
        }
      }
      if (newList[i] != -1) {
        chart.add(ChartData(name: modal[i].categoryModal.name, amount: amount));
      }
    }
    return chart;
  }
}
