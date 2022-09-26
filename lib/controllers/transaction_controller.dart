import 'package:flutter/material.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class TransactionController with ChangeNotifier {
  DateTime? selectedDate;
  CategoryType _categoryType = CategoryType.income;
  CategoryType get categoryType => _categoryType;
  CategoryModal? _categoryModal;
  CategoryModal? get categoryModal => _categoryModal;
  String? _dropDownValue;
  String? get dropDownValue => _dropDownValue;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double totalIncome = 0;
  double totalExpense = 0;
  double currentBalance = 0;

  Future<void> showDate(BuildContext context) async {
    final DateTime? result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      selectedDate = result;
    }
  }

  void setCategoryType(CategoryType categoryType) {
    _categoryType = categoryType;
    notifyListeners();
  }

  void setDropDownValue(String? newValue) {
    _dropDownValue = newValue;
    notifyListeners();
  }

  void setCategoryModel(CategoryModal? categoryModal) {
    _categoryModal = categoryModal;
  }

  Future<void> addTransaction(TransactionModal transactionModal) async {
    _isLoading = true;
    await TransactionDbFunctions().addTransaction(transactionModal);
    _isLoading = false;
    refreshUi();
  }

  Future<void> refreshUi() async {
    _isLoading = true;
    final getAllCatogories = await TransactionDbFunctions().refreshUi();
    totalIncome = 0;
    totalExpense = 0;
    currentBalance = 0;
    await Future.forEach(
      getAllCatogories,
      (TransactionModal transaction) {
        currentBalance = currentBalance + transaction.amount;
        if (transaction.type == CategoryType.income) {
          totalIncome = totalIncome + transaction.amount;
        } else if (transaction.type == CategoryType.expense) {
          totalExpense = totalExpense + transaction.amount;
        }
      },
    );
    currentBalance = totalIncome - totalExpense;
    _isLoading = false;
    notifyListeners();
  }
}
