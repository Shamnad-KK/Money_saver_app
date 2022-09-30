import 'package:flutter/material.dart';
import 'package:money_manager/repository/database/category_repository.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/utils/delete_alert_dialogue.dart';
import 'package:money_manager/utils/snackbars.dart';
import 'package:money_manager/view/add_category_screen/widgets/add_alert_dialogue_widget.dart';

class CategoryDBController with ChangeNotifier {
  final List<CategoryModal> incomeModalNotifier = [];
  final List<CategoryModal> expenseModalNotifier = [];
  List<CategoryModal> allCategoryNotifier = [];
  TextEditingController categoryNameController = TextEditingController();
  late TabController tabController;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  Future<void> addCategory(context) async {
    if (categoryNameController.text.isEmpty) {
      return;
    } else {
      final incomeCategory = CategoryModal(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: categoryNameController.text.trim(),
        type: tabController.index == 0
            ? CategoryType.income
            : CategoryType.expense,
      );
      await CategoryDbFunctions().addCategory(incomeCategory);
      await refreshUi();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Category added'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      categoryNameController.clear();
    }
  }

  Future<void> getAll() async {
    final allList = await CategoryDbFunctions().getAllCategories();
    allCategoryNotifier = allList;
    notifyListeners();
  }

  Future<void> refreshUi() async {
    final getAllCategories = await CategoryDbFunctions().refreshUi();
    allCategoryNotifier.clear();
    incomeModalNotifier.clear();
    expenseModalNotifier.clear();
    await Future.forEach(
      getAllCategories,
      (CategoryModal category) {
        allCategoryNotifier.add(category);
        if (category.type == CategoryType.income) {
          incomeModalNotifier.add(category);
        } else if (category.type == CategoryType.expense) {
          expenseModalNotifier.add(category);
        }
      },
    );
    notifyListeners();
  }

  Future<void> deleteCategory(String key) async {
    await CategoryDbFunctions().deleteCategory(key);
    await refreshUi();
  }

  Future openDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AddAlertDialogueWidget(),
    );
  }

  String? addScreenValidate(String? value) {
    if (value!.isEmpty) {
      return "Category is empty";
    }
    if (tabController.index == 0) {
      final income =
          incomeModalNotifier.map((e) => e.name.trim().toLowerCase()).toList();
      if (income.contains(categoryNameController.text.trim().toLowerCase())) {
        return 'Category already exists';
      }
    }
    if (tabController.index == 1) {
      final expense =
          expenseModalNotifier.map((e) => e.name.trim().toLowerCase()).toList();
      if (expense.contains(categoryNameController.text.trim().toLowerCase())) {
        return 'Category already exists';
      }
    }

    return null;
  }

  Future<void> validated(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await addCategory(context);
    }
  }

  void showDeletePopUp(BuildContext context, CategoryModal modal) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialogue(
          ontap: () {
            deleteCategory(modal.id);

            SnackBars.customSnackbar('Category deleted');
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
