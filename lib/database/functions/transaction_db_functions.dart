import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/models/category_model/category_model.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/database/models/transaction_model/transaction_model.dart';

class TransactionDbFunctions {
  TransactionDbFunctions._instance();
  static TransactionDbFunctions instance = TransactionDbFunctions._instance();

  factory TransactionDbFunctions() {
    return instance;
  }
  static final ValueNotifier<double> totalIncome = ValueNotifier(0);
  static final ValueNotifier<double> totalExpense = ValueNotifier(0);
  static final ValueNotifier<double> currentBalance = ValueNotifier(0);
  static final ValueNotifier<List<TransactionModal>> incomeTransactionNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<TransactionModal>>
      expenseTransactionNotifier = ValueNotifier([]);

  static final ValueNotifier<List<TransactionModal>> allTransactionNotifier =
      ValueNotifier([]);

  static final ValueNotifier<List<TransactionModal>> todayTransactionNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<TransactionModal>> todayIncomeNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<TransactionModal>> todayExpenseNotifier =
      ValueNotifier([]);
//
//
  static final DateTime todayDate = DateTime.now();
  final String date = DateFormat('yMMMMd').format(todayDate);
  static final DateTime thisWeek =
      DateTime.now().subtract(const Duration(days: 7));
  final String thisWeekDate = DateFormat('yMMMMd').format(thisWeek);
  static final DateTime thisMonth =
      DateTime.now().subtract(const Duration(days: 30));
  final String thisMonthDate = DateFormat('yMMMMd').format(thisMonth);
  static final DateTime thisYear =
      DateTime.now().subtract(const Duration(days: 365));
  final String thisYearDate = DateFormat('yMMMMd').format(thisYear);
//
//
  final ValueNotifier<List<TransactionModal>> thisWeekAllNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisWeekIncomeNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisWeekExpenseNotifier =
      ValueNotifier([]);
//
//
  final ValueNotifier<List<TransactionModal>> thisMonthAllNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisMonthIncomeNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisMonthExpenseNotifier =
      ValueNotifier([]);
//
//
  final ValueNotifier<List<TransactionModal>> thisYearAllNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisYearIncomeNotifier =
      ValueNotifier([]);
  final ValueNotifier<List<TransactionModal>> thisYearExpenseNotifier =
      ValueNotifier([]);
//
//
  Future<void> addTransaction(TransactionModal transactionModal) async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);
    await transactionDB.put(transactionModal.id, transactionModal);
    await refreshUi();
  }

  Future<List<TransactionModal>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);

    return transactionDB.values.toList();
  }

  Future<void> refreshUi() async {
    final getAllCatogories = await getAllTransactions();
    getAllCatogories
        .sort((firstDate, lastDate) => lastDate.date.compareTo(firstDate.date));
    allTransactionNotifier.value.clear();
    allTransactionNotifier.value.addAll(getAllCatogories);
    allTransactionNotifier.notifyListeners();
    incomeTransactionNotifier.value.clear();
    expenseTransactionNotifier.value.clear();
    totalIncome.value = 0;
    totalExpense.value = 0;
    currentBalance.value = 0;
    await Future.forEach(
      getAllCatogories,
      (TransactionModal transaction) {
        currentBalance.value = currentBalance.value + transaction.amount;
        if (transaction.type == CategoryType.income) {
          incomeTransactionNotifier.value.add(transaction);
          totalIncome.value = totalIncome.value + transaction.amount;
        } else if (transaction.type == CategoryType.expense) {
          expenseTransactionNotifier.value.add(transaction);
          totalExpense.value = totalExpense.value + transaction.amount;
        }
      },
    );
    currentBalance.value = totalIncome.value - totalExpense.value;
    incomeTransactionNotifier.notifyListeners();
    expenseTransactionNotifier.notifyListeners();

    totalIncome.notifyListeners();
    totalExpense.notifyListeners();
    currentBalance.notifyListeners();
  }

  Future<void> sortTodayTransactions() async {
    final getAllCatogories = await getAllTransactions();
    getAllCatogories
        .sort((firstDate, lastDate) => lastDate.date.compareTo(firstDate.date));
    todayTransactionNotifier.value.clear();
    todayIncomeNotifier.value.clear();
    todayExpenseNotifier.value.clear();
    final parsedDate = DateFormat('yMMMMd').parse(date);
    await Future.forEach(
      getAllCatogories,
      (TransactionModal transaction) {
        if (transaction.date == parsedDate) {
          todayTransactionNotifier.value.add(transaction);
        }
        if (transaction.date == parsedDate &&
            transaction.type == CategoryType.income) {
          todayIncomeNotifier.value.add(transaction);
        }
        if (transaction.date == parsedDate &&
            transaction.type == CategoryType.expense) {
          todayExpenseNotifier.value.add(transaction);
        }
      },
    );
    todayTransactionNotifier.notifyListeners();
    todayIncomeNotifier.notifyListeners();
    todayExpenseNotifier.notifyListeners();
  }

  Future<void> sortCustomTransaction() async {
    final getAllCatogories = await getAllTransactions();
    getAllCatogories
        .sort((firstDate, lastDate) => lastDate.date.compareTo(firstDate.date));
    thisWeekAllNotifier.value.clear();
    thisWeekIncomeNotifier.value.clear();
    thisWeekExpenseNotifier.value.clear();
    thisMonthAllNotifier.value.clear();
    thisMonthIncomeNotifier.value.clear();
    thisMonthExpenseNotifier.value.clear();
    thisYearAllNotifier.value.clear();
    thisYearIncomeNotifier.value.clear();
    thisYearExpenseNotifier.value.clear();
    final parsedThisWeekDate = DateFormat('yMMMMd').parse(thisWeekDate);
    final parsedThisMonthDate = DateFormat('yMMMMd').parse(thisMonthDate);
    final parsedThisYearDate = DateFormat('yMMMMd').parse(thisYearDate);
    await Future.forEach(
      getAllCatogories,
      (TransactionModal transaction) {
        if (transaction.date.isAfter(parsedThisWeekDate)) {
          thisWeekAllNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisWeekDate) &&
            transaction.type == CategoryType.income) {
          thisWeekIncomeNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisWeekDate) &&
            transaction.type == CategoryType.expense) {
          thisWeekExpenseNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisMonthDate)) {
          thisMonthAllNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisMonthDate) &&
            transaction.type == CategoryType.income) {
          thisMonthIncomeNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisMonthDate) &&
            transaction.type == CategoryType.expense) {
          thisMonthExpenseNotifier.value.add(transaction);
        }

        if (transaction.date.isAfter(parsedThisYearDate)) {
          thisYearAllNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisYearDate) &&
            transaction.type == CategoryType.income) {
          thisYearIncomeNotifier.value.add(transaction);
        }
        if (transaction.date.isAfter(parsedThisYearDate) &&
            transaction.type == CategoryType.expense) {
          thisYearExpenseNotifier.value.add(transaction);
        }
      },
    );
    thisWeekAllNotifier.notifyListeners();
    thisWeekIncomeNotifier.notifyListeners();
    thisWeekExpenseNotifier.notifyListeners();
    thisMonthAllNotifier.notifyListeners();
    thisMonthIncomeNotifier.notifyListeners();
    thisMonthExpenseNotifier.notifyListeners();
    thisYearAllNotifier.notifyListeners();
    thisYearIncomeNotifier.notifyListeners();
    thisYearExpenseNotifier.notifyListeners();
    //await refreshUi();
  }

  Future<void> deleteTransaction(String key) async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);
    await transactionDB.delete(key);
    await refreshUi();
  }

  Future<void> deleteAllData() async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    await transactionDB.deleteFromDisk();
    await categoryDB.deleteFromDisk();
    await refreshUi();
  }
}
