import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';

class CategoryDbFunctions {
  static final ValueNotifier<List<CategoryModal>> incomeModalNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<CategoryModal>> expenseModalNotifier =
      ValueNotifier([]);
  static final ValueNotifier<List<CategoryModal>> allCategoryNotifier =
      ValueNotifier([]);

  CategoryDbFunctions._instance();
  static CategoryDbFunctions instance = CategoryDbFunctions._instance();

  factory CategoryDbFunctions() {
    return instance;
  }

  Future<void> addCategory(CategoryModal categoryModal) async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    await categoryDB.put(categoryModal.id, categoryModal);
    await refreshUi();
  }

  Future<List<CategoryModal>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    return categoryDB.values.toList();
  }

  Future<void> refreshUi() async {
    final getAllCatogories = await getAllCategories();
    allCategoryNotifier.value.clear();
    incomeModalNotifier.value.clear();
    expenseModalNotifier.value.clear();
    await Future.forEach(
      getAllCatogories,
      (CategoryModal category) {
        allCategoryNotifier.value.add(category);
        if (category.type == CategoryType.income) {
          incomeModalNotifier.value.add(category);
        } else if (category.type == CategoryType.expense) {
          expenseModalNotifier.value.add(category);
        }
      },
    );
    allCategoryNotifier.notifyListeners();
    incomeModalNotifier.notifyListeners();
    expenseModalNotifier.notifyListeners();
  }

  Future<void> deleteCategory(String key) async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    await categoryDB.delete(key);
    await refreshUi();
  }
}
