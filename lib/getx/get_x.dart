import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';

class DropDownController extends GetxController {
  RxString dropDownValue = 'ALL'.obs;
  RxString customDropDownValue = 'ONE WEEK'.obs;
  RxString statsDropDownValue = 'ALL'.obs;

  RxBool rebuildList = false.obs;
  RxList<TransactionModal> foundData = <TransactionModal>[].obs;

  List<TransactionModal> allData =
      TransactionDbFunctions.allTransactionNotifier.value;

  Future allFilter({required TabController tabController}) async {
    foundData.value = allData;
    RxList<TransactionModal> results = <TransactionModal>[].obs;
    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    if (dropDownValue.value == 'ALL' && tabController.index == 0) {
      results.value = allData;
    } else if (dropDownValue.value == 'INCOME' && tabController.index == 0) {
      results.value = foundData
          .where((element) => element.type == CategoryType.income)
          .toList();
    } else if (dropDownValue.value == 'EXPENSE' && tabController.index == 0) {
      results.value = foundData
          .where((element) => element.type == CategoryType.expense)
          .toList();
    } else if (dropDownValue.value == 'ALL' && tabController.index == 1) {
      results.value = foundData
          .where((element) => element.date == parsedTodayDate)
          .toList();
    } else if (dropDownValue.value == 'INCOME' && tabController.index == 1) {
      results.value = foundData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.type == CategoryType.income)
          .toList();
    } else if (dropDownValue.value == 'EXPENSE' && tabController.index == 1) {
      results.value = foundData
          .where((element) =>
              element.date == parsedTodayDate &&
              element.type == CategoryType.expense)
          .toList();
    }
    foundData.value = results;
  }

  Future customFilter({required TabController tabController}) async {
    foundData.value = allData;
    RxList<TransactionModal> results = <TransactionModal>[].obs;
    final weekDate = DateTime.now().subtract(const Duration(days: 7));
    final monthDate = DateTime.now().subtract(const Duration(days: 28));
    final yearDate = DateTime.now().subtract(const Duration(days: 365));
    if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'ONE WEEK' &&
        tabController.index == 2) {
      results.value =
          foundData.where((element) => element.date.isAfter(weekDate)).toList();
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'ONE WEEK' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(weekDate))
          .toList();
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'ONE WEEK' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(weekDate))
          .toList();
    } else if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'ONE MONTH' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) => element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'ONE MONTH' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'ONE MONTH' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(monthDate))
          .toList();
    } else if (dropDownValue.value == 'ALL' &&
        customDropDownValue.value == 'ONE YEAR' &&
        tabController.index == 2) {
      results.value =
          foundData.where((element) => element.date.isAfter(yearDate)).toList();
    } else if (dropDownValue.value == 'INCOME' &&
        customDropDownValue.value == 'ONE YEAR' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(yearDate))
          .toList();
    } else if (dropDownValue.value == 'EXPENSE' &&
        customDropDownValue.value == 'ONE YEAR' &&
        tabController.index == 2) {
      results.value = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(yearDate))
          .toList();
    }
    foundData.value = results;
  }

  statsFilter({required TabController tabController}) {
    List<TransactionModal> results = [];
    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    final weekDate = DateTime.now().subtract(const Duration(days: 7));
    final monthDate = DateTime.now().subtract(const Duration(days: 28));
    if (statsDropDownValue.value == 'ALL' && tabController.index == 0) {
      results = allData;
    } else if (statsDropDownValue.value == 'TODAY' &&
        tabController.index == 0) {
      results = foundData
          .where((element) => element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue.value == '7 DAYS' &&
        tabController.index == 0) {
      results =
          foundData.where((element) => element.date.isAfter(weekDate)).toList();
    } else if (statsDropDownValue.value == '30 DAYS' &&
        tabController.index == 0) {
      results = foundData
          .where((element) => element.date.isAfter(monthDate))
          .toList();
    } else if (statsDropDownValue.value == 'ALL' && tabController.index == 1) {
      results = allData
          .where((element) => element.type == CategoryType.income)
          .toList();
    } else if (statsDropDownValue.value == 'TODAY' &&
        tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue.value == '7 DAYS' &&
        tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.date.isAfter(weekDate) &&
              element.type == CategoryType.income)
          .toList();
    } else if (statsDropDownValue.value == '30 DAYS' &&
        tabController.index == 1) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.income &&
              element.date.isAfter(monthDate))
          .toList();
    }
    //
    else if (statsDropDownValue.value == 'ALL' && tabController.index == 2) {
      results = foundData
          .where((element) => element.type == CategoryType.expense)
          .toList();
    } else if (statsDropDownValue.value == 'TODAY' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date == parsedTodayDate)
          .toList();
    } else if (statsDropDownValue.value == '7 DAYS' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.date.isAfter(weekDate) &&
              element.type == CategoryType.expense)
          .toList();
    } else if (statsDropDownValue.value == '30 DAYS' &&
        tabController.index == 2) {
      results = foundData
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(monthDate))
          .toList();
    }
    foundData = results.obs;
    return foundData;
  }
}
