import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/category/category_type_model/category_type_model.dart';
import 'package:provider/provider.dart';

class AddIncomeCategoryTabbarView extends StatelessWidget {
  const AddIncomeCategoryTabbarView({Key? key, required this.tabController})
      : super(key: key);
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryDBController>(
        builder: (BuildContext context, value, Widget? child) {
      if (value.incomeModalNotifier.isEmpty) {
        return Center(
          child: FittedBox(
            child: Text(
              'Add Category',
              style: appBodyTextStyle,
            ),
          ),
        );
      } else {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 3 / 1,
          ),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                5.w,
                0.h,
                5.h,
                0.h,
              ),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(
                  10.r,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      value.incomeModalNotifier[index].name,
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (tabController.index == 0 &&
                          value.incomeModalNotifier[index].type ==
                              CategoryType.income) {
                        showPopUp(
                            context, index, value.incomeModalNotifier[index]);
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: value.incomeModalNotifier.length,
        );
      }
    });
  }

  void showPopUp(BuildContext context, int index, CategoryModal modal) {
    final categoryController = Provider.of<CategoryDBController>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text('Do you want to delete ?'),
          actions: [
            TextButton(
              onPressed: () {
                if (tabController.index == 0) {
                  categoryController.deleteCategory(modal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Category deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                }
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
