import 'package:flutter/material.dart';
import 'package:money_manager/helpers/enums.dart';
import 'package:money_manager/repository/database/transaction_repository.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:money_manager/utils/delete_alert_dialogue.dart';
import 'package:money_manager/utils/snackbars.dart';
import 'package:money_manager/widgets/bottom_navbar.dart';

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

  final formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController? desController = TextEditingController();

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
    await TransactionRepository().addTransaction(transactionModal);
    _isLoading = false;
    amountController.clear();
    dateController.clear();
    desController?.clear();
    selectedDate = null;
    setDropDownValue(null);
    setCategoryModel(null);
    setCategoryType(CategoryType.income);
    await refreshUi();
  }

  Future<void> refreshUi() async {
    _isLoading = true;
    final getAllCatogories = await TransactionRepository().refreshUi();
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

  Future<void> addorEditTransaction(
    TextEditingController amountController,
    TextEditingController dateController,
    TextEditingController? desController,
    ScreenAction type,
    TransactionModal? transactionModall,
    BuildContext context,
  ) async {
    if (categoryModal == null ||
        amountController.text.isEmpty ||
        dateController.text.isEmpty) {
      return;
    } else {
      final amounttext = amountController.text;
      final parsedAmount = num.tryParse(amounttext);

      selectedDate ??= transactionModall?.date;
      final transactionModal = TransactionModal(
        amount: parsedAmount!,
        description:
            desController?.text == '' ? "No description" : desController!.text,
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        categoryModal: categoryModal!,
        date: selectedDate!,
        type: categoryType,
      );
      final scaffoldContext = ScaffoldMessenger.of(context);
      final navContext = Navigator.of(context);
      if (type == ScreenAction.addScreen) {
        await addTransaction(transactionModal);

        SnackBars.customSnackbar('Transaction added');
      } else if (type == ScreenAction.editScreen) {
        await transactionModall?.editTransaction(transactionModal);

        scaffoldContext.showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Transaction edited'),
            backgroundColor: Colors.green,
          ),
        );
      }

      setCategoryType(CategoryType.income);
      navContext.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const BottomNavBar(),
          ),
          (route) => false);
    }
  }

  Future<void> confirmDelete(
      BuildContext context, int index, List<TransactionModal> value) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return DeleteAlertDialogue(
          ontap: () async {
            value[index].delete().then((_) async {
              value.removeAt(index);
              Navigator.of(context).pop();
              await refreshUi();
              SnackBars.customSnackbar('Transaction deleted');
            });

            notifyListeners();
          },
        );
      },
    );
  }

  Future<void> deleteAllData() async {
    await TransactionRepository().deleteAllData();
  }
}
