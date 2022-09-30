import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModal extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  CategoryModal categoryModal;
  @HiveField(2)
  DateTime date;
  @HiveField(3)
  CategoryType type;
  @HiveField(4)
  num amount;
  @HiveField(5)
  String? description;

  TransactionModal({
    required this.amount,
    required this.id,
    required this.categoryModal,
    required this.date,
    required this.type,
    this.description,
  });

  editTransaction(TransactionModal newTransaction) {
    id = newTransaction.id;
    amount = newTransaction.amount;
    categoryModal = newTransaction.categoryModal;
    date = newTransaction.date;
    type = newTransaction.type;
    description = newTransaction.description;
    save();
  }

  deleteTransaction(TransactionModal newTransaction) async {
    await newTransaction.delete();
    //delete();
  }
}
