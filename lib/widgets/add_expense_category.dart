import 'package:flutter/material.dart';
import 'package:money_manager/database/functions/category_db_functions.dart';
import 'package:money_manager/database/models/category_model/category_model.dart';
import 'package:money_manager/database/models/category_model/category_type_model/category_type_model.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExpenseCategoryTabbarView extends StatelessWidget {
  const AddExpenseCategoryTabbarView({Key? key, required this.tabController})
      : super(key: key);
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDbFunctions.expenseModalNotifier,
      builder: (BuildContext context, List<CategoryModal> categoryList,
          Widget? child) {
        if (categoryList.isEmpty) {
          return Center(
            child: Text(
              'Add Category',
              style: appBodyTextStyle,
            ),
          );
        } else {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 3 / 1),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.h, 0.h),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        categoryList[index].name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 19.sp,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (tabController.index == 1 &&
                            categoryList[index].type == CategoryType.expense) {
                          showPopUp(context, index, categoryList[index]);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: categoryList.length,
          );
        }
      },
    );
  }

  void showPopUp(BuildContext context, int index, CategoryModal modal) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text('Do you want to delete ?'),
          actions: [
            TextButton(
              onPressed: () {
                if (tabController.index == 1) {
                  CategoryDbFunctions().deleteCategory(modal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Category deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                } else {}
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
