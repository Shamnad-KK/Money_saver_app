import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:provider/provider.dart';

class AddExpenseCategoryTabbarView extends StatelessWidget {
  const AddExpenseCategoryTabbarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryDBController>(
        builder: (BuildContext context, value, Widget? child) {
      if (value.expenseModalNotifier.isEmpty) {
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
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      value.expenseModalNotifier[index].name,
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
                      value.showDeletePopUp(
                          context, value.expenseModalNotifier[index]);
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
          itemCount: value.expenseModalNotifier.length,
        );
      }
    });
  }
}
