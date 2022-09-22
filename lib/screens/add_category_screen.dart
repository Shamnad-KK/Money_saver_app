import 'package:flutter/material.dart';
import 'package:money_manager/constants/constants.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:money_manager/widgets/category_exp_tabview_widget.dart';
import 'package:money_manager/widgets/category_inc_tabview_widget.dart';
import 'package:money_manager/widgets/appbar_widget.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController categoryController = TextEditingController();
  late TabController tabController;
  @override
  void initState() {
    CategoryDbFunctions().refreshUi();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    return Scaffold(
      appBar: const AppBarWidget(
        leading: 'Add Category',
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              unselectedLabelColor: blackColor,
              labelColor: whiteColor,
              indicatorColor: Colors.transparent,
              labelStyle: const TextStyle(
                color: whiteColor,
                fontSize: 20,
              ),
              unselectedLabelStyle: const TextStyle(
                color: blackColor,
                fontSize: 20,
              ),
              indicator: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              tabs: const [
                Tab(
                  child: Text(
                    'Income',
                  ),
                ),
                Tab(
                  child: Text(
                    'Expense',
                  ),
                ),
              ],
            ),
            sBoxH30,
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: [
                  AddIncomeCategoryTabbarView(
                    tabController: tabController,
                  ),
                  AddExpenseCategoryTabbarView(
                    tabController: tabController,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          if (tabController.index == 0) {
            categoryController.clear();
            openDialogue();
          } else if (tabController.index == 1) {
            categoryController.clear();
            openDialogue();
          }
        },
      ),
    );
  }

  Future openDialogue() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: tabController.index == 0
            ? const Text(
                'Enter Income Category',
              )
            : const Text(
                'Enter Expense Category',
              ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: categoryController,
            validator: (value) {
              if (tabController.index == 0) {
                final income = CategoryDbFunctions.incomeModalNotifier.value
                    .map((e) => e.name.trim().toLowerCase())
                    .toList();
                if (income
                    .contains(categoryController.text.trim().toLowerCase())) {
                  return 'Category already exists';
                }
              }
              if (tabController.index == 1) {
                final expense = CategoryDbFunctions.expenseModalNotifier.value
                    .map((e) => e.name.trim().toLowerCase())
                    .toList();
                if (expense
                    .contains(categoryController.text.trim().toLowerCase())) {
                  return 'Category already exists';
                }
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await addCategory();
              }
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addCategory() async {
    if (categoryController.text.isEmpty) {
      return;
    } else {
      final incomeCategory = CategoryModal(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: categoryController.text.trim(),
        type: tabController.index == 0
            ? CategoryType.income
            : CategoryType.expense,
      );
      await CategoryDbFunctions.instance.addCategory(incomeCategory);
      if (!mounted) {}
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Category added'),
          backgroundColor: Colors.green,
        ),
      );
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    categoryController.clear();
  }
}
