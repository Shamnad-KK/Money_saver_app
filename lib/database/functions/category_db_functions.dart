import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/models/category/category_model.dart';

class CategoryDbFunctions {
  // static final ValueNotifier<List<CategoryModal>> incomeModalNotifier =
  //     ValueNotifier([]);
  // static final ValueNotifier<List<CategoryModal>> expenseModalNotifier =
  //     ValueNotifier([]);
  // static final ValueNotifier<List<CategoryModal>> allCategoryNotifier =
  //     ValueNotifier([]);

  CategoryDbFunctions._instance();
  static CategoryDbFunctions instance = CategoryDbFunctions._instance();

  factory CategoryDbFunctions() {
    return instance;
  }

  Future<void> addCategory(CategoryModal categoryModal) async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    await categoryDB.put(categoryModal.id, categoryModal);
    // await refreshUi();
  }

  Future<List<CategoryModal>> getAllCategories() async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    return categoryDB.values.toList();
  }

  Future<List<CategoryModal>> refreshUi() async {
    final getAllCatogories = await getAllCategories();
    return getAllCatogories;
  }

  Future<void> deleteCategory(String key) async {
    final categoryDB = await Hive.openBox<CategoryModal>(categoryDbName);
    await categoryDB.delete(key);
//    await refreshUi();
  }
}
