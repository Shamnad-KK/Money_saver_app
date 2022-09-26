import 'package:flutter/material.dart';
import 'package:money_manager/repository/database/category_repository.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';

class CategoryDBController with ChangeNotifier {
  final List<CategoryModal> incomeModalNotifier = [];
  final List<CategoryModal> expenseModalNotifier = [];
  List<CategoryModal> allCategoryNotifier = [];

  Future<void> addCategory(CategoryModal categoryModal) async {
    await CategoryDbFunctions().addCategory(categoryModal);
    await refreshUi();
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
}
