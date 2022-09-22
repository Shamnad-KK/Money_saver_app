import 'package:flutter/material.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/models/category/category_model.dart';

class CategoryDBProvider with ChangeNotifier {
  static final List<CategoryModal> incomeModalNotifier = [];
  static final List<CategoryModal> expenseModalNotifier = [];
  static List<CategoryModal> allCategoryNotifier = [];
  void getAll() async {
    final allList = await CategoryDbFunctions().getAllCategories();
    allCategoryNotifier = allList;
    notifyListeners();
  }
}
