import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class StatisticsRepository {
  statsFilter(
    List<TransactionModal> foundData,
    List<TransactionModal> allData,
    String? statsDropDownValue,
    TabController tabController,
  ) {
    List<TransactionModal> results = [];

    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    final weekDate = DateTime.now().subtract(const Duration(days: 7));
    final monthDate = DateTime.now().subtract(const Duration(days: 30));
    if (statsDropDownValue == 'ALL' && tabController.index == 0) {
      results = allData;
    } else if (statsDropDownValue == 'TODAY' && tabController.index == 0) {
      results = foundData
          .where((element) => element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue == '7 DAYS' && tabController.index == 0) {
      results =
          foundData.where((element) => element.date.isAfter(weekDate)).toList();
    } else if (statsDropDownValue == '30 DAYS' && tabController.index == 0) {
      results = foundData
          .where((element) => element.date.isAfter(monthDate))
          .toList();
    } else if (statsDropDownValue == 'ALL' && tabController.index == 1) {
      results = foundData
          .where((element) => element.type == CategoryType.income)
          .toList();
    } else if (statsDropDownValue == 'TODAY' && tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue == '7 DAYS' && tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.date.isAfter(weekDate) &&
              element.type == CategoryType.income)
          .toList();
    } else if (statsDropDownValue == '30 DAYS' && tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(monthDate))
          .toList();
    } else if (statsDropDownValue == 'ALL' && tabController.index == 2) {
      results = foundData
          .where((element) => element.type == CategoryType.expense)
          .toList();
    } else if (statsDropDownValue == 'TODAY' && tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue == '7 DAYS' && tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.date.isAfter(weekDate) &&
              element.type == CategoryType.expense)
          .toList();
    } else if (statsDropDownValue == '30 DAYS' && tabController.index == 2) {
      results = foundData
          .where(
            (element) =>
                element.type == CategoryType.expense &&
                element.date.isAfter(monthDate),
          )
          .toList();
    }

    foundData = results;

    return foundData;
  }
}
