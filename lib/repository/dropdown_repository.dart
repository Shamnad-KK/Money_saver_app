import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class DropDownRepository {
  Future allFilter(
    String? dropDownValue,
    List<TransactionModal> allData,
    List<TransactionModal> foundData,
    TabController tabController,
    List<TransactionModal> results,
  ) async {
    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    if (dropDownValue == 'ALL' && tabController.index == 0) {
      results = allData;
    } else if (dropDownValue == 'INCOME' && tabController.index == 0) {
      results = foundData
          .where((element) => element.type == CategoryType.income)
          .toList();
    } else if (dropDownValue == 'EXPENSE' && tabController.index == 0) {
      results = foundData
          .where((element) => element.type == CategoryType.expense)
          .toList();
    } else if (dropDownValue == 'ALL' && tabController.index == 1) {
      results = foundData
          .where((element) => element.date == parsedTodayDate)
          .toList();
    } else if (dropDownValue == 'INCOME' && tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.type == CategoryType.income)
          .toList();
    } else if (dropDownValue == 'EXPENSE' && tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.type == CategoryType.expense)
          .toList();
    }
    foundData = results;

    return foundData;
  }

  Future customFilter(
    List<TransactionModal> results,
    List<TransactionModal> allData,
    List<TransactionModal> foundData,
    String? customDropDownValue,
    String? dropDownValue,
    TabController tabController,
  ) async {
    final weekDate = DateTime.now().subtract(const Duration(days: 7));
    final monthDate = DateTime.now().subtract(const Duration(days: 28));
    final yearDate = DateTime.now().subtract(const Duration(days: 365));
    if (dropDownValue == 'ALL' &&
        customDropDownValue == 'ONE WEEK' &&
        tabController.index == 2) {
      results =
          foundData.where((element) => element.date.isAfter(weekDate)).toList();
    } else if (dropDownValue == 'INCOME' &&
        customDropDownValue == 'ONE WEEK' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(weekDate))
          .toList();
    } else if (dropDownValue == 'EXPENSE' &&
        customDropDownValue == 'ONE WEEK' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(weekDate))
          .toList();
    } else if (dropDownValue == 'ALL' &&
        customDropDownValue == 'ONE MONTH' &&
        tabController.index == 2) {
      results = foundData
          .where((element) => element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue == 'INCOME' &&
        customDropDownValue == 'ONE MONTH' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue == 'EXPENSE' &&
        customDropDownValue == 'ONE MONTH' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue == 'ALL' &&
        customDropDownValue == 'ONE YEAR' &&
        tabController.index == 2) {
      results =
          foundData.where((element) => element.date.isAfter(yearDate)).toList();
    } else if (dropDownValue == 'INCOME' &&
        customDropDownValue == 'ONE YEAR' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(yearDate))
          .toList();
    } else if (dropDownValue == 'EXPENSE' &&
        customDropDownValue == 'ONE YEAR' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(yearDate))
          .toList();
    }
    foundData = results;
    return foundData;
  }
}
