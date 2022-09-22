import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/database/functions/transaction_db_functions.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class DropDownProvider with ChangeNotifier {
  String dropDownValue = 'ALL';
  String customDropDownValue = 'ONE WEEK';
  String statsDropDownValue = 'ALL';

  List<TransactionModal> foundData = [];

  List<TransactionModal> allData =
      TransactionDbFunctions.allTransactionNotifier.value;

  Widget homeDrop(TabController tabController) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        alignment: Alignment.centerRight,
        elevation: 16,
        value: dropDownValue,
        items: <String>[
          'ALL',
          'INCOME',
          'EXPENSE',
        ]
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: appLargeTextStyle,
                ),
              ),
            )
            .toList(),
        onChanged: (String? newValue) async {
          foundData = allData;
          dropDownValue = newValue!;
          await allFilter(tabController: tabController);
          if (tabController.index == 2) {
            await customFilter(tabController: tabController);
          }
          notifyListeners();
        },
      ),
    );
  }

  Future allFilter({required TabController tabController}) async {
    foundData = allData;
    List<TransactionModal> results = <TransactionModal>[];
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
    notifyListeners();
  }

  Future customFilter({required TabController tabController}) async {
    foundData = allData;
    List<TransactionModal> results = <TransactionModal>[];
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
    notifyListeners();
  }

  statsFilter({required TabController tabController}) {
    List<TransactionModal> results = [];
    final todayDate = DateTime.now();
    final date = DateFormat('yMMMMd').format(todayDate);
    final parsedTodayDate = DateFormat('yMMMMd').parse(date);
    final weekDate = DateTime.now().subtract(const Duration(days: 7));
    final monthDate = DateTime.now().subtract(const Duration(days: 28));
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
      results = allData
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
    }
    //
    else if (statsDropDownValue == 'ALL' && tabController.index == 2) {
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
          .where((element) =>
              element.type == CategoryType.expense &&
              element.date.isAfter(monthDate))
          .toList();
    }
    foundData = results;
    notifyListeners();
    return foundData;
  }
}
