import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class TransactionDbFunctions {
  TransactionDbFunctions._instance();
  static TransactionDbFunctions instance = TransactionDbFunctions._instance();

  factory TransactionDbFunctions() {
    return instance;
  }

  // static final ValueNotifier<List<TransactionModal>> incomeTransactionNotifier =
  //     ValueNotifier([]);
  // static final ValueNotifier<List<TransactionModal>>
  //     expenseTransactionNotifier = ValueNotifier([]);

  static final List<TransactionModal> allTransactionNotifier = [];

//
  Future<void> addTransaction(TransactionModal transactionModal) async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);
    await transactionDB.put(transactionModal.id, transactionModal);
  }

  Future<List<TransactionModal>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModal>(transactionDbName);

    return transactionDB.values.toList();
  }

  Future<List<TransactionModal>> refreshUi() async {
    final getAllCatogories = await getAllTransactions();
    getAllCatogories
        .sort((firstDate, lastDate) => lastDate.date.compareTo(firstDate.date));
    allTransactionNotifier.clear();
    allTransactionNotifier.addAll(getAllCatogories);
    return getAllCatogories;

    // incomeTransactionNotifier.value.clear();
    // expenseTransactionNotifier.value.clear();
    // totalIncome = 0;
    // totalExpense = 0;
    // currentBalance = 0;
    // await Future.forEach(
    //   getAllCatogories,
    //   (TransactionModal transaction) {
    //     currentBalance = currentBalance + transaction.amount;
    //     if (transaction.type == CategoryType.income) {
    //       // incomeTransactionNotifier.value.add(transaction);
    //       totalIncome = totalIncome + transaction.amount;
    //     } else if (transaction.type == CategoryType.expense) {
    //       //  expenseTransactionNotifier.value.add(transaction);
    //       totalExpense = totalExpense + transaction.amount;
    //     }
    //   },
    // );
    // currentBalance = totalIncome - totalExpense;
    // incomeTransactionNotifier.notifyListeners();
    // expenseTransactionNotifier.notifyListeners();
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
