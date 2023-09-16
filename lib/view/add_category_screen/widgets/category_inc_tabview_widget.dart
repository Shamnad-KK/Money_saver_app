import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_manager/controllers/category_controller.dart';
import 'package:money_manager/helpers/colors.dart';
import 'package:money_manager/helpers/text_style.dart';
import 'package:provider/provider.dart';

class AddIncomeCategoryTabbarView extends StatelessWidget {
  const AddIncomeCategoryTabbarView({Key? key}) : super(key: key);
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
                  const SizedBox(width: 4),
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
                      value.showDeletePopUp(
                          context, value.incomeModalNotifier[index]);
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
}
