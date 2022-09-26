import 'package:flutter/material.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/repository/statistics_repository.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';

class StatisticsController extends ChangeNotifier {
  List<TransactionModal> allData =
      TransactionDbFunctions.allTransactionNotifier;

  List<TransactionModal> foundData = [];

  String? _statsDropDownValue = 'ALL';
  String? get statsDropDownValue => _statsDropDownValue;

  void setStatsDropDown(String? statsDropDownValue) {
    _statsDropDownValue = statsDropDownValue;
    notifyListeners();
  }

  List<TransactionModal> statsFilter(TabController tabController) {
    foundData = StatisticsRepository().statsFilter(
      foundData,
      allData,
      statsDropDownValue,
      tabController,
    );

    notifyListeners();
    return foundData;
  }
}
