import 'package:flutter/material.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/constants.dart';
import 'package:money_manager/widgets/appbar_widget.dart';
import 'package:money_manager/view/add_category_screen/widgets/category_exp_tabview_widget.dart';
import 'package:money_manager/view/add_category_screen/widgets/category_inc_tabview_widget.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CategoryDBController categoryController =
        Provider.of<CategoryDBController>(context, listen: false);

    categoryController.tabController =
        TabController(length: 2, vsync: Scaffold.of(context));

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
              controller: categoryController.tabController,
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
                controller: categoryController.tabController,
                children: const [
                  AddIncomeCategoryTabbarView(),
                  AddExpenseCategoryTabbarView(),
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
        onPressed: () async {
          await categoryController.openDialogue(context);
        },
      ),
    );
  }
}
