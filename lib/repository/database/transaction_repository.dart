import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class TransactionRepository {
  TransactionRepository._instance();
  static TransactionRepository instance = TransactionRepository._instance();

  factory TransactionRepository() {
    return instance;
  }

  static final List<TransactionModal> allTransactionNotifier = [];

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
    return allTransactionNotifier;
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
