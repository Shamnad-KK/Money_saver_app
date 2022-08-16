import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
